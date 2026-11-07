import React, {useState} from 'react';
import {recruitsAvailable, settlementServices, troops} from '../../../packages/sim/src/company.ts';

export function SettlementServices({page,site,world,local,send,onBack}) {
  const [selected,setSelected]=useState('foot');
  const [count,setCount]=useState(1);
  const service=settlementServices[site];
  const company=world.company;
  if(!local || !service || !company)return <p>Return to the settlement to use its services.</p>;
  const contact=service.meetingHouse;
  if(page==='Meeting house' && contact){
    const hired=company.companions.includes(site);
    return <div className="service-content">
      <p className="eyebrow">Fictional campaign contact</p>
      <h2>{contact.name}</h2><p>{contact.role}</p>
      <button disabled={hired || world.economy.gold<contact.fee} onClick={()=>send({type:'hire-companion'})}>{hired?'In your company':'Hire companion · '+contact.fee+' coin'}</button>
      <p>Prisoners held · {company.prisoners}</p>
      <button disabled={!company.prisoners} onClick={()=>send({type:'ransom'})}>Ransom one prisoner · +40 coin</button>
      <button onClick={onBack}>Return to settlement</button>
    </div>;
  }
  const available=recruitsAvailable(company,site,selected);
  const price=count*troops[selected].cost;
  return <div className="service-content">
    <p className="eyebrow">Local recruitment · Gameplay roster</p>
    <div className="recruit-offers">{Object.keys(service.recruits).map(troop=>
      <button key={troop} aria-pressed={selected===troop} onClick={()=>{setSelected(troop);setCount(1);}}>
        <img src={troop==='mounted'?'/art/campaign-rider.webp':'/art/campaign-villagers.webp'} alt=""/>
        <strong>{troops[troop].name}</strong>
        <small>{recruitsAvailable(company,site,troop)} available · {troops[troop].cost} coin each</small>
      </button>)}</div>
    <label>Quantity <select value={count} onChange={e=>setCount(Number(e.target.value))}>{Array.from({length:Math.max(count,available)},(_,i)=><option key={i}>{i+1}</option>)}</select></label>
    <p>{world.economy.gold} coin in your purse · {world.encounter.guards+1} in your company</p>
    <button disabled={count>available || price>world.economy.gold} onClick={()=>send({type:'recruit',troop:selected,count})}>Recruit {count} · {price} coin</button>
    <button onClick={onBack}>Return to settlement</button>
  </div>;
}
