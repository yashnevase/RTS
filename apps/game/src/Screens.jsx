import React, {useState,useEffect,useRef} from 'react';
import {purchasePrice,goods} from '../../../packages/sim/src/economy.ts';
import {Encyclopedia} from './Encyclopedia.jsx';
import {saveCampaign} from './campaign-save.js';
import {raiderSite, encounterTerrain} from '../../../packages/sim/src/encounter.ts';
import {byId} from './places.js';
export function Screens({world,send,onLocate}) {
  const [page,setPage]=useState(null);
  const [quantity,setQuantity]=useState(1);
  const [saveStatus,setSaveStatus]=useState('');
  const [topic,setTopic]=useState('greeting');
  const e=world.economy,p=world.parties[0],local=!p.path.length&&!p.motion;
  const wasTravelling=useRef(false);
  useEffect(()=>{
    if(wasTravelling.current&&local&&byId.has(p.node)) setPage(current=>current??'Settlement');
    wasTravelling.current=!local;
  },[local,p.node]);
  function open(value){setPage(value);}
  useEffect(()=>{
    const keys=event=>{
      if(/INPUT|SELECT|TEXTAREA/.test(event.target.tagName))return;
      if(event.key==='Escape')setPage(null);
      const name={i:'Inventory',p:'Party',c:'Character',j:'Quests',n:'Encyclopedia'}[event.key.toLowerCase()];
      if(name)open(name);
    };
    window.addEventListener('keydown',keys);return()=>window.removeEventListener('keydown',keys);
  },[]);
  return <><nav className="campaign-nav">{['Inventory','Party','Character','Quests','Encyclopedia','Settlement'].map(name=><button key={name} onClick={()=>open(name)}>{name}</button>)}<span>{e?.gold??600} coin</span><button disabled={!world.started} onClick={()=>setSaveStatus(saveCampaign(world)?'Campaign saved':'Save unavailable')}>Save</button>{saveStatus&&<output>{saveStatus}</output>}</nav>
  {page&&<div className={'screen-shade'+(page==='Settlement'?' settlement-shade':'')}><section className="game-screen" role="dialog" aria-modal={page!=='Settlement'} aria-label={page}><button className="close" onClick={()=>setPage(null)}>Close · Esc</button><h1>{page}</h1>
    {page==='Encyclopedia'&&<Encyclopedia world={world} onLocate={record=>{setPage(null);onLocate(record);}}/>}
    {page==='Inventory'&&e&&<div className="inventory-layout"><section><h2>Your stores</h2>{goods.map(g=><div className="item-row" key={g}><span className="item-icon">{g==='grain'?'♧':'▥'}</span><b>{g}</b><span>{e.inventory[g]}</span></div>)}</section><section className="equipment"><img src="/art/envoy.webp" alt="Your fictional traveller"/><h2>{world.identity?.name}</h2><p>{world.identity?.house}</p></section><section><h2>Equipment</h2><p>Personal clothing</p><p>Travel pack</p><p>Coin · {e.gold}</p></section></div>}
    {page==='Party'&&<div className="inventory-layout"><section><h2>Prisoners</h2><p>None</p></section><section className="equipment"><img src="/art/envoy.webp" alt="Company leader"/><h2>{world.identity?.name}</h2><p>Company leader</p></section><section><h2>Your company · {1+(world.encounter?.guards??3)}</h2><div className="item-row"><span>⚑</span><b>{world.identity?.name}</b><span>1</span></div><div className="item-row"><span>⚔</span><b>Company guards</b><span>{world.encounter?.guards??3}</span></div><p>Camp · {byId.get(p.node)?.name??'Open country'}</p><label>March pace <select value={p.pace} onChange={e=>send({type:'pace',value:e.target.value})}><option value="steady">Steady</option><option value="swift">Swift</option></select></label></section></div>}
    {page==='Character'&&<><img className="character-art" src="/art/envoy.webp" alt="Fictional player portrait"/><h2>{world.identity?.name} {world.identity?.house}</h2><p>Independent company · Fictional player character</p><p>Saswad supplier relation · {world.relations?.supplier??0}</p><button onClick={()=>open('Encyclopedia')}>Open encyclopedia</button></>}
    {page==='Quests'&&<><h2>Supplies for Saswad</h2><p>{e?.quest?e.quest.status+' · '+Math.max(0,e.quest.due-world.tick)+' hours remaining':'Speak with the local supplier in Saswad.'}</p><p>20 grain · 50 wood · Reward 900 coin</p></>}
    {page==='Settlement'&&<><h2>{byId.get(p.node)?.name??'Open country'}</h2>{!local?<p>Arrive before entering the settlement.</p>:<>
      {byId.has(p.node)&&<img className="settlement-illustration" src={byId.get(p.node).kind==='fort'?'/art/fort-token.webp':'/art/village-token.webp'} alt="Illustration of the settlement type"/>}
      <div className="settlement-actions">
        {e?.markets[p.node]&&<button onClick={()=>open('Trade')}>Visit the market</button>}
        {p.node==='site_saswad'&&<button onClick={()=>open('Talk')}>Talk to the local supplier</button>}
        {p.node===raiderSite&&<button onClick={()=>open('Encounter')}>{world.encounter?.resolved?'Read the encounter report':'Investigate the raiders'}</button>}
        <button onClick={()=>{send({type:'wait',hours:6});setPage(null);}}>Wait here · 6 hours</button>
        <button onClick={()=>setPage(null)}>Leave</button>
      </div></>}</>}
    {page==='Talk'&&<div className="conversation"><div><img src="/art/saswad-supplier.webp" alt="Fictional local supplier"/><h2>Local supplier</h2><small>Saswad · Relation {world.relations?.supplier??0}</small></div><section><p className="eyebrow">A conversation in Saswad</p><blockquote>{e?.quest?.status==='completed'?'Your supplies have arrived. Here is your payment. You have our thanks.':e?.quest?.status==='failed'?'The deadline has passed. We had to seek help elsewhere.':topic==='greeting'?'Welcome, traveller. The settlement needs supplies. Can your company help?':'Bring twenty grain and fifty wood within four days. I can offer nine hundred coin when you deliver.'}</blockquote>
    <div className="dialogue-options"><button onClick={()=>setTopic('request')}>What supplies do you need?</button><button disabled={!local||p.node!=='site_saswad'||['completed','failed'].includes(e?.quest?.status)} onClick={()=>{send({type:'quest'});setTopic('request');}}>{e?.quest?'I brought the supplies.':'I will bring them.'}</button><button onClick={()=>open('Trade')}>Let me see your market.</button><button onClick={()=>open('Settlement')}>We will speak another time.</button></div><p role="status">{e?.notice}</p></section></div>}
    {page==='Encounter'&&world.encounter&&<div className="conversation encounter"><div><img src="/art/campaign-rider.webp" alt="Illustrated company rider"/><h2>Kondhana approaches</h2></div><section><p className="eyebrow">Fictional encounter</p>
      {world.encounter.result?<><h2>{world.encounter.result.outcome}</h2><p>{world.encounter.result.terrain} · {world.encounter.result.guardsLost} {world.encounter.result.guardsLost===1?'guard':'guards'} lost · {world.encounter.result.coin} coin recovered</p>
        <p>Company strength {world.encounter.result.strength} · Opposition {world.encounter.result.opposition}</p><button onClick={()=>setPage(null)}>Return to map</button></>:<>
        <blockquote>A raiding party watches the approach. Your company has {world.encounter.guards} guards.</blockquote>
        <p>{p.point?encounterTerrain(p.point).name:''}. Cover and elevation can favor the defenders.</p>
        <button disabled={!local||p.node!==raiderSite} onClick={()=>send({type:'resolve-encounter'})}>Send the company · Auto-resolve</button>
        <button onClick={()=>open('Settlement')}>Withdraw</button></>}
    </section></div>}
    {page==='Trade'&&e&&<><div className="market-heading"><h2>{byId.get(p.node)?.name??'Open country'} market</h2><strong>Your purse · {e.gold} coin</strong>{p.node==='site_saswad'&&world.relations?.supplier>=15&&<small>Supplier favor · reduced buy prices</small>}<label>Quantity <select value={quantity} onChange={event=>setQuantity(Number(event.target.value))}>{[1,5,10,20,50].map(n=><option key={n}>{n}</option>)}</select></label></div>
    {local&&e.markets[p.node]?<div className="market-layout"><section><h2>Merchant's goods</h2>{goods.map(g=><div className="market-item" key={g}><div className="goods-symbol">{g==='grain'?'♧':'▥'}</div><div><h3>{g}</h3><p>{e.markets[p.node].stock[g]} available · from {purchasePrice(e.markets[p.node],g,p.node,world.relations?.supplier??0)} coin each</p></div><button onClick={()=>send({type:'trade',good:g,buy:true,quantity})}>Buy {quantity} →</button></div>)}</section><section className="market-player"><img src="/art/envoy.webp" alt="Your company leader"/><h2>{world.identity?.name}</h2><p>{world.identity?.house}</p></section><section><h2>Your goods</h2>{goods.map(g=><div className="market-item" key={g}><div className="goods-symbol">{g==='grain'?'♧':'▥'}</div><div><h3>{g}</h3><p>{e.inventory[g]} in your stores</p></div><button disabled={e.inventory[g]<quantity} onClick={()=>send({type:'trade',good:g,buy:false,quantity})}>← Sell {quantity}</button></div>)}</section></div>:<p>Arrive at Pune, Saswad or Ahmadnagar to trade.</p>}<p role="status">{e.notice}</p><small>Prices adjust per unit as stock changes. Transactions require sufficient funds and stock for the whole quantity.</small></>}


  </section></div>}</>;
}
