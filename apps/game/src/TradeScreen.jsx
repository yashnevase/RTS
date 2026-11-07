import React,{useEffect,useState} from 'react';
import {goods,caravanEconomy,caravanMarketId,previewTrade,purchasePrice,salePrice} from '../../../packages/sim/src/economy.ts';
import {byId} from './places.js';
import {ItemIcon} from './ItemIcon.jsx';

function MarketPrices({economy,good,relation,site,market}){
  const [expanded,setExpanded]=useState(false);
  const quotes=Object.entries(economy.markets).map(([id,market])=>({
    id, name:byId.get(id)?.name??id,
    ask:market.stock[good]>0?purchasePrice(market,good,id,relation):null,
    bid:market.stock[good]<market.target[good]*3&&salePrice(market,good,id,relation)<=market.money?salePrice(market,good,id,relation):null
  }));
  const ask=purchasePrice(market,good,site,relation);
  const bid=salePrice(market,good,site,relation);
  const cheap=quotes.filter(q=>q.id!==site&&q.ask!==null).sort((a,b)=>a.ask-b.ask).slice(0,5);
  const dear=quotes.filter(q=>q.id!==site&&q.bid!==null).sort((a,b)=>b.bid-a.bid).slice(0,5);
  const signed=n=>n>0?'+'+n:String(n);
  return <div className="price-intel">
    <button aria-expanded={expanded} onClick={()=>setExpanded(!expanded)}>{dear[0]?.bid>ask?'Best export · +'+(dear[0].bid-ask)+' coin at '+dear[0].name:'No profitable export at current quotes'}</button>
    <div className={'price-ranks'+(expanded?' is-expanded':'')}>
      <section><strong>Buy elsewhere, sell here</strong>{cheap.map(q=><div key={q.id}>{q.name} · {q.ask} · {signed(bid-q.ask)} margin</div>)}</section>
      <section><strong>Buy here, sell elsewhere</strong>{dear.map(q=><div key={q.id}>{q.name} · {q.bid} · {signed(q.bid-ask)} margin</div>)}</section>
      <small>One-unit quotes before travel. Zero breaks even. Negative means a loss.</small>
    </div>
  </div>;
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
    const displayed=buy?market.stock[good]-staged:e.inventory[good]+staged;
    return <details className="trade-entry" key={good}>
      <summary><ItemIcon kind={good}/> <b>{good}</b> <span>{displayed} · {quote} coin</span></summary>
      <div className="transfer-controls">
        <button disabled={displayed<=0||pending||Math.abs(staged+direction)>100} onClick={()=>setCounts({...counts,[good]:staged+direction})}>{buy?'Add to company →':'← Add to merchant'}</button>
        <button disabled={pending||Math.sign(staged)!==direction} onClick={()=>setCounts({...counts,[good]:staged-direction})}>Undo one</button>
      </div>
      <label className="quantity-slider">Merchant ← <input type="range" aria-label={good+' transfer quantity'} min={-Math.min(100,e.inventory[good])} max={Math.min(100,market.stock[good])} value={staged} disabled={!!pending} onChange={event=>setCounts({...counts,[good]:Number(event.target.value)})}/> → Company <output>{staged}</output></label>
      <MarketPrices economy={world.economy} good={good} relation={relation} site={site} market={market}/>
    </details>;
  }
  return <>
    <div className="market-heading"><h2>{roadside?'Pack caravan':byId.get(site)?.name+' market'}</h2><strong>Your purse · {e.gold} coin</strong></div>
    <div className="market-layout"><section><h2>Merchant's goods</h2>{goods.map(g=>row(g,true))}</section>
      <section className="market-player"><img src="/art/envoy.webp" alt="Company leader"/><h2>{world.identity.name}</h2></section>
      <section><h2>Your goods</h2>{goods.map(g=>row(g,false))}</section>
    </div>
    <div className="trade-review">
      <p>{lines.length?lines.map(l=>(l.buy?'Buy ':'Sell ')+l.quantity+' '+l.good).join(' · '):'Choose an item to prepare a trade.'}</p>
      {change!==null?<strong>Net coin change {change>0?'+':''}{change}</strong>:<strong>Insufficient funds or stock</strong>}
      <button onClick={onClose}>Cancel</button>
      <button disabled={!lines.length||change===null||pending} onClick={()=>{
        const id=crypto.randomUUID();setPending(id);send({type:'confirm-trade',site,lines,change,id});
      }}>Confirm trade</button>
      <p role="status">{e.notice}</p>
    </div>
  </>;
}
