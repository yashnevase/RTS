import {monthlyWages} from '../../../packages/sim/src/clan.ts';
import {ItemIcon} from './ItemIcon.jsx';
import React,{useState,useEffect} from 'react';
import {readCampaign} from './campaign-save.js';
import {foodPerDay} from '../../../packages/sim/src/company.ts';
import {clockHour} from '../../../packages/sim/src/travel.ts';
export function Creation({send}){
 const [saved]=useState(readCampaign);
 const [name,setName]=useState('Gautam'),[house,setHouse]=useState('Deshmukh'),[color,setColor]=useState('#b74338'),[symbol,setSymbol]=useState('Sun');
 return <div className="creation"><div className="creation-panel"><p className="eyebrow">DECCAN WARLORDS · 1622</p><h1>Begin your story</h1><p>Choose your name and the banner your company carries.</p><form onSubmit={e=>{e.preventDefault();send({type:'start',identity:{name:name.trim(),house:house.trim(),color,symbol}});}}>
 <label>Your name<input required maxLength={32} value={name} onChange={e=>setName(e.target.value)}/></label>
 <label>House name<input required maxLength={32} value={house} onChange={e=>setHouse(e.target.value)}/></label>
 <label>Banner colour<input type="color" value={color} onChange={e=>setColor(e.target.value)}/></label>
 <label>Emblem<select value={symbol} onChange={e=>setSymbol(e.target.value)}>{['Sun','Crescent','Diamond'].map(s=><option key={s}>{s}</option>)}</select></label>
 <button className="begin">Enter the Deccan</button></form>{saved&&<button className="continue" onClick={()=>send({type:'restore',world:saved})}>Continue {saved.identity.name} of {saved.identity.house}</button>}</div><div className="creation-portrait"><img src="/art/envoy.webp" alt="Your fictional traveller"/><div className="personal-banner" style={{background:color}}>{symbol==='Sun'?'☀':symbol==='Crescent'?'☾':'◆'}</div><h2>{name} {house}</h2></div></div>;
}
export function Clock({world,send,follow,setFollow,onLocate}){
 const [toast,setToast]=useState('');
 const action=world.events?.find(event=>/^(Trade completed|Recruited|Released|A guard died|Rations ran short|Victory|Retreat)| joined your company|Suppl(?:y|ies)/.test(event.text));
 useEffect(()=>{
   if(!action||!world.started)return;
   setToast(action.text);
   const timer=setTimeout(()=>setToast(''),3400);
   return ()=>clearTimeout(timer);
 },[action?.id,world.started]);
 useEffect(()=>{
  const handler=e=>{if(!world.started||e.repeat||/INPUT|SELECT|TEXTAREA|BUTTON|SUMMARY/.test(e.target.tagName))return;
   if(e.code==='Space'){e.preventDefault();send({type:'speed',value:world.speed?0:1});}
   if(['1','2','3'].includes(e.key))send({type:'speed',value:{1:1,2:2,3:4}[e.key]});
  };window.addEventListener('keydown',handler);return()=>window.removeEventListener('keydown',handler);
 },[world.speed,world.started,send]);
 const inventory=world.economy?.inventory;
 const food=(inventory?.grain??0)+(inventory?.rice??0)+(inventory?.fish??0);
 const days=Math.floor(food/foodPerDay(world.encounter?.guards??3,world.company?.companions.length??0));
 const entries=world.ledger??[];
 const recent=entries.filter(entry=>entry.tick>world.tick-168);
 const incoming=recent.reduce((sum,e)=>sum+Math.max(0,e.change),0),outgoing=recent.reduce((sum,e)=>sum+Math.max(0,-e.change),0);
 const detached=(world.clan?.detachments??[]).reduce((sum,d)=>sum+(d.allowance??10),0);
 const payroll=monthlyWages((world.encounter?.guards??3)-(world.company?.mounted??0),world.company?.mounted??0,world.company?.companions.length??0)+detached;
 const status=world.waitUntil!==null?'Waiting · '+(world.waitUntil-world.tick)+'h left':world.notice;
 return <>
  <div className="campaign-status">{status}</div>
  <div className="action-toast" role="status" aria-live="polite">{toast}</div>
  <div className="company-hud" aria-label="Company status">
   <div className="hud-inspect" tabIndex="0" aria-label="Coin details"><span>◉ {world.economy?.gold??600}</span><div className="hud-tooltip">
 <strong>Clan treasury</strong><p>Last 7 days · <b className="quote-credit">+{incoming}</b> / <b className="quote-debit">−{outgoing}</b></p>
 <p>Payroll {payroll}/month · {(payroll/30).toFixed(2)}/day<br/>Unpaid {world.clan?.arrears??0}</p>
 {entries.slice(0,8).map((entry,i)=><p key={i}>Day {1+Math.floor(entry.tick/24)} · {entry.reason} <b className={entry.change>0?'quote-credit':'quote-debit'}>{entry.change>0?'+':''}{entry.change}</b></p>)}
 {!entries.length&&<p>No recorded transactions yet.</p>}</div></div>
   <span title="Company strength"><i aria-hidden="true">⚔</i> {1+(world.encounter?.guards??3)}</span>
   <div className="hud-inspect" tabIndex="0" aria-label="Food details"><span>♧ {days}d</span><div className="hud-tooltip"><strong>Company provisions</strong>{['grain','rice','fish'].map(g=><p key={g}><ItemIcon kind={g}/>{g} · {inventory?.[g]??0}</p>)}<p>{foodPerDay(world.encounter?.guards??3,world.company?.companions.length??0).toFixed(2)} rations/day at full health. Recovery uses extra food.</p></div></div>
   <span title="Company health" className={(world.company?.health??100)<60?'quote-debit':''}>♥ {world.company?.health??100}%</span>
   <button onClick={onLocate} title="Center on your company">Find</button>
   <button aria-pressed={follow} onClick={()=>setFollow(!follow)}>Follow</button>
  </div>
  <div className="time-hud" aria-label="Campaign time"><div><small>1622 · Day {1+Math.floor((world.tick+6)/24)}</small><strong>{String(clockHour(world.tick)).padStart(2,'0')}:00</strong></div>
   {[0,1,2,4].map(n=><button aria-label={n?'Speed '+n:'Pause'} title={n?n+'× speed':'Pause · Space'} key={n} aria-pressed={world.speed===n} onClick={()=>send({type:'speed',value:n})}>{n===0?'Ⅱ':n===1?'▶':n+'×'}</button>)}
   <button onClick={()=>send({type:'wait',hours:6})}>Wait 6h</button>
  </div>
 </>;
}
