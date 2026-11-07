import React,{useEffect,useState} from 'react';
import {goods,caravanEconomy,caravanMarketId,previewTrade,purchasePrice,salePrice,profitableDestinations,stockTarget,units} from '../../../packages/sim/src/economy.ts';
import {byId} from './places.js';
import {ItemIcon} from './ItemIcon.jsx';

function MarketPrices({economy,good,relation,site,quantity}){
  const destinations=profitableDestinations(economy,site,good,quantity,relation);
  if(!destinations.length)return null;
  const best=destinations[0];
  return <details className="profit-routes">
    <summary>Sell in {byId.get(best.id)?.name} <strong>+{best.profit} coin</strong></summary>
    <ul>{destinations.map(route=><li key={route.id}>{byId.get(route.id)?.name} <strong>+{route.profit}</strong></li>)}</ul>
    <small>For {quantity} {good} bought here. Before travel and changes in stock.</small>
  </details>;
}

export function TradeScreen({world,site,local,send,onClose}){
  const [counts,setCounts]=useState({});
  const [pending,setPending]=useState(null);
  const roadside=site===caravanMarketId;
  const e=roadside?caravanEconomy(world.economy,world.merchant):world.economy;
  const market=e.markets[site],relation=world.relations?.supplier??0;
  const lines=goods.flatMap(good=>counts[good]?[{good,buy:counts[good]>0,quantity:Math.abs(counts[good])}]:[]);
  const draft=previewTrade(e,site,lines,relation);
  const change=draft?draft.gold-e.gold:null;
  useEffect(()=>{
    if(pending && world.tradeReply?.id===pending){
      setPending(null);
      if(world.tradeReply.accepted)setCounts({});
    }
  },[pending,world.tradeReply]);
  if(!local||!market)return <><p>{roadside?'The caravan is out of reach.':'Arrive at a market settlement to trade.'}</p><button onClick={onClose}>Leave</button></>;
  function row(good,buy){
    const quote=buy?purchasePrice(market,good,site,relation):salePrice(market,good,site,relation);
    const direction=buy?1:-1, staged=counts[good]??0;
    const displayed=buy?units(market.stock,good)-staged:units(e.inventory,good)+staged;
    return <details className="trade-entry" key={good}>
      <summary><ItemIcon kind={good}/> <b>{good}</b> <span>{displayed} · {quote} coin</span></summary>
      <div className="transfer-controls">
        <button disabled={displayed<=0||pending||Math.abs(staged+direction)>100} onClick={()=>setCounts({...counts,[good]:staged+direction})}>{buy?'Add to company →':'← Add to merchant'}</button>
        <button disabled={pending||Math.sign(staged)!==direction} onClick={()=>setCounts({...counts,[good]:staged-direction})}>Undo one</button>
      </div>
      <label className="quantity-slider">Merchant ← <input type="range" aria-label={good+' transfer quantity'} min={-Math.min(100,units(e.inventory,good))} max={Math.min(100,units(market.stock,good))} value={staged} disabled={!!pending} onChange={event=>setCounts({...counts,[good]:Number(event.target.value)})}/> → Company <output>{staged}</output></label>
      {buy&&staged>=0&&<MarketPrices economy={e} good={good} relation={relation} site={site} quantity={Math.max(1,staged)}/>}
    </details>;
  }
  return <>
    <div className="market-heading"><h2>{roadside?'Pack caravan':byId.get(site)?.name+' market'}</h2><strong>Your purse · {e.gold} coin</strong></div>
    <details className="market-ledger">
      <summary>Regional market rates</summary>
      <table><caption>Buy / sell per unit · live quotes</caption><thead><tr><th>Market</th>{goods.map(g=><th key={g}>{g}</th>)}</tr></thead>
        <tbody>{Object.entries(world.economy.markets).map(([id,town])=><tr key={id}><th>{byId.get(id)?.name??id}</th>
          {goods.map(g=><td key={g}><span>{units(town.stock,g)>0?purchasePrice(town,g,id,relation):'—'}</span> / <span>{units(town.stock,g)<stockTarget(town,g)*3&&town.money>=salePrice(town,g,id,relation)?salePrice(town,g,id,relation):'—'}</span></td>)}</tr>)}</tbody>
      </table>
    </details>
    <div className="market-layout"><section><h2>Merchant's goods</h2>{goods.map(g=>row(g,true))}</section>
      <section className="market-player"><img src="/art/envoy.webp" alt="Company leader"/><h2>{world.identity.name}</h2></section>
      <section><h2>Your goods</h2>{goods.map(g=>row(g,false))}</section>
    </div>
    <div className="trade-review">
      <p>{lines.length?lines.map(l=>(l.buy?'Buy ':'Sell ')+l.quantity+' '+l.good).join(' · '):'Choose an item to prepare a trade.'}</p>
      {change!==null?<strong className={change>0?'quote-credit':change<0?'quote-debit':''}>Net coin change {change>0?'+':''}{change}</strong>:<strong>Insufficient funds or stock</strong>}
      <button onClick={onClose}>Cancel</button>
      <button disabled={!lines.length||change===null||pending} onClick={()=>{
        const id=crypto.randomUUID();setPending(id);send({type:'confirm-trade',site,lines,change,id});
      }}>Confirm trade</button>
      <p role="status" className="quote-notice">{e.notice}</p>
    </div>
  </>;
}
