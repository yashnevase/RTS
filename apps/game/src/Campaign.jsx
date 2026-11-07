import React, { useEffect, useRef, useState } from 'react';
import { clockHour, createCampaign, fraction, monsoon, plan } from '../../../packages/sim/src/travel.ts';
import {position} from '../../../packages/sim/src/movement.ts';
import { byId } from './places.js';

export function useCampaign() {
  const worker = useRef(null);
  const [world,setWorld] = useState(createCampaign);
  useEffect(() => {
    worker.current = new Worker(new URL('./travel.worker.js',import.meta.url),{type:'module'});
    worker.current.onmessage = event => setWorld(event.data);
    worker.current.postMessage({type:'inspect'});
    return () => worker.current.terminate();
  },[]);
  return {world, send:cmd=>worker.current?.postMessage(cmd)};
}
export function locationOf(party) {
  if(party.motion)return position(party.motion);
  if(party.point)return party.point;
  const a=byId.get(party.node).coordinate;
  if (!party.path.length) return a;
  const b=byId.get(party.path[0]).coordinate, t=fraction(party);
  return {latitude:a.latitude+(b.latitude-a.latitude)*t,longitude:a.longitude+(b.longitude-a.longitude)*t};
}
export function CampaignPanel({world,send,selected,inspect,setInspect,onLocate,follow,setFollow}) {
  const player=world.parties[0], party=world.parties.find(p=>p.id===inspect)??player;
  const trip=plan(player,selected.id,world.tick);
  const [wait,setWait]=useState(6);
  useEffect(()=>{
    const key=event=>{
      if(event.code!=='Space'||event.repeat||/^(INPUT|SELECT|BUTTON|TEXTAREA|SUMMARY)$/.test(event.target.tagName)) return;
      event.preventDefault();send({type:'speed',value:world.speed?0:1});
    };
    window.addEventListener('keydown',key);return ()=>window.removeEventListener('keydown',key);
  },[world.speed,send]);
  return <section className="march">
    <div className="eyebrow">Campaign clock</div>
    <strong>Day {1+Math.floor((world.tick+6)/24)} · {String(clockHour(world.tick)).padStart(2,'0')}:00</strong>
    <div className="clock-buttons">{[0,1,2,4].map(value=><button key={value} aria-pressed={world.speed===value} onClick={()=>send({type:'speed',value})}>{value?value+'×':'Pause'}</button>)}</div>
    <label>March pace <select value={player.pace} onChange={e=>send({type:'pace',value:e.target.value})}><option value="steady">Steady</option><option value="swift">Swift</option></select></label>
    <div className="trip"><b>{selected.name}</b><span>{trip ? trip.hours ? Math.round(trip.metres/1000)+' km · '+trip.hours+' h · '+Math.ceil(trip.hours/24)+' ration-days per person' : 'Your current camp' : 'Outside the travel network'}</span>
    <button disabled={!trip?.hours} onClick={()=>send({type:'travel',to:selected.id})}>Travel here</button></div>
    <div className="wait"><select aria-label="Wait duration" value={wait} onChange={e=>setWait(Number(e.target.value))}>{[1,6,12,24].map(h=><option key={h} value={h}>{h} hours</option>)}</select>
    <button onClick={()=>send({type:'wait',hours:wait})}>Wait here</button></div>
    <p className="journal-status">{world.waitUntil!==null?'Waiting · '+(world.waitUntil-world.tick)+' h left':world.notice} {monsoon(world.tick)?'Monsoon travel.':''}</p>
    <label>Party journal <select value={party.id} onChange={e=>setInspect(e.target.value)}>{world.parties.map(p=><option key={p.id} value={p.id}>{p.name}</option>)}</select></label>
    <p>{byId.get(party.node).name}{party.path.length?' → '+byId.get(party.path.at(-1)).name:' · Stationary'}</p>
    <button onClick={()=>onLocate(party.id)}>Locate party</button>
    <button aria-pressed={follow} onClick={()=>setFollow(!follow)}>Follow company</button>
    <details><summary>Travel assumptions</summary><p>These preview corridors use approximate distances and inferred terrain costs. The three supporting parties are fictional. Marching runs from 06:00 to 18:00. Ration-days are planning estimates. Swift pace covers 25% more ground per hour. A timed wait holds your position while other parties travel.</p></details>
    <details><summary>Developer console{world.modified?' · modified':''}</summary>
      <button onClick={()=>send({type:'step'})}>Step one hour</button>
      <button disabled={!trip} onClick={()=>send({type:'relocate',to:selected.id})}>Relocate to selection</button>
    </details>
  </section>;
}
