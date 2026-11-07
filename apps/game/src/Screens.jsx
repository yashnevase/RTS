import React, {useState,useEffect} from 'react';
import {price,goods} from '../../../packages/sim/src/economy.ts';
import {byId} from './places.js';
export function Screens({world,send}) {
  const [page,setPage]=useState(null);
  const e=world.economy,p=world.parties[0],local=!p.path.length;
  function open(value){setPage(value);send({type:'speed',value:0});}
  useEffect(()=>{
    const keys=event=>{
      if(/INPUT|SELECT|TEXTAREA/.test(event.target.tagName))return;
      if(event.key==='Escape')setPage(null);
      const name={i:'Inventory',p:'Party',c:'Character',j:'Quests'}[event.key.toLowerCase()];
      if(name)open(name);
    };
    window.addEventListener('keydown',keys);return()=>window.removeEventListener('keydown',keys);
  },[]);
  return <><nav className="campaign-nav">{['Inventory','Party','Character','Quests','Settlement'].map(name=><button key={name} onClick={()=>open(name)}>{name}</button>)}<span>{e?.gold??600} coin</span></nav>
  {page&&<div className="screen-shade"><section className="game-screen" role="dialog" aria-modal="true" aria-label={page}><button className="close" onClick={()=>setPage(null)}>Close · Esc</button><h1>{page}</h1>
    {page==='Inventory'&&e&&<><p>Your stores</p>{goods.map(g=><p key={g}>{g} · {e.inventory[g]}</p>)}</>}
    {page==='Party'&&<><h2>Your company</h2><p>Camp · {byId.get(p.node).name}</p><p>March pace · {p.pace}</p><p>Recruitment and troop management will connect to this roster.</p></>}
    {page==='Character'&&<><img className="character-art" src="/art/envoy.webp" alt="Fictional player portrait"/><h2>Your traveller</h2><p>Independent company · Fictional player character</p><p>Skills, traits and relationships will appear here as their systems are implemented.</p></>}
    {page==='Quests'&&<><h2>Supplies for Saswad</h2><p>{e?.quest?e.quest.status+' · '+Math.max(0,e.quest.due-world.tick)+' hours remaining':'Speak with the local supplier in Saswad.'}</p><p>20 grain · 50 wood · Reward 900 coin</p></>}
    {page==='Settlement'&&<><h2>{byId.get(p.node).name}</h2>{!local?<p>Arrive before entering the settlement.</p>:<><button onClick={()=>open('Trade')}>Visit the market</button><button disabled={p.node!=='site_saswad'} onClick={()=>open('Talk')}>Talk to the local supplier</button></>}</>}
    {page==='Talk'&&<><img className="character-art" src="/art/envoy.webp" alt="Illustrative fictional supplier"/><h2>A local supplier</h2><blockquote>“We need twenty grain and fifty wood. Bring them here within four days and I will pay nine hundred.”</blockquote><button onClick={()=>send({type:'quest'})}>{e?.quest?'Deliver the supplies':'Accept the request'}</button><p>{e?.notice}</p></>}
    {page==='Trade'&&e&&<><h2>{byId.get(p.node).name} market</h2>{local&&e.markets[p.node]?goods.map(g=><div className="trade-row" key={g}><b>{g}</b><span>Market {e.markets[p.node].stock[g]} · Yours {e.inventory[g]} · {price(e.markets[p.node],g)} coin</span><button onClick={()=>send({type:'trade',good:g,buy:true})}>Buy 1</button><button onClick={()=>send({type:'trade',good:g,buy:false})}>Sell 1</button></div>):<p>A stocked market is available at Pune, Saswad or Ahmadnagar.</p>}</>}
    <p className="subtle">Early campaign systems · Economy values and dialogue are gameplay assumptions.</p>
  </section></div>}</>;
}
