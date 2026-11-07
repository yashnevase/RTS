import React, {useState} from 'react';
import {recruitsAvailable, settlementServices, troops} from '../../../packages/sim/src/company.ts';

export function SettlementServices({page,site,world,local,send,onBack}) {
  const [selected,setSelected]=useState('foot');
  const [count,setCount]=useState(1);
  const [returned,setReturned]=useState({foot:0,mounted:0});
  const service=settlementServices[site];
  const company=world.company;
  if(!local || !service || !company)return <p>Return to the settlement to use its services.</p>;
  const contact=service.meetingHouse;
  if(page==='Sarai' && contact){
    const hired=company.companions.includes(site);
    return <div className="service-content">
      <p className="eyebrow">Fictional campaign contact</p>
      <img className="companion-portrait" src={site==='site_pune'?'/art/foot-guard.webp':'/art/campaign-rider.webp'} alt="Illustration of the companion role"/><h2>{contact.name}</h2><p>{contact.role}</p>
      <button disabled={hired || world.economy.gold<contact.fee} onClick={()=>send({type:'hire-companion'})}>{hired?'In your company':'Hire companion · '+contact.fee+' coin'}</button>
      <div className="troop-return"><h3>Return hired troops</h3>
        {['foot','mounted'].map(type=>{
          const max=type==='mounted'?company.mounted:world.encounter.guards-company.mounted;
          return <label className="quantity-slider" key={type}>{troops[type].name}<input type="range" min="0" max={max} value={Math.min(returned[type],max)} onChange={e=>setReturned({...returned,[type]:Number(e.target.value)})}/><output>{returned[type]}</output></label>;
        })}
        <p>Refund · {returned.foot*troops.foot.cost+returned.mounted*troops.mounted.cost} coin</p>
        <button onClick={()=>setReturned({foot:0,mounted:0})}>Cancel transfer</button>
        <button disabled={!returned.foot&&!returned.mounted} onClick={()=>{send({type:'return-troops',...returned});setReturned({foot:0,mounted:0});}}>Confirm troop return</button>
      </div>
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
        <img src={troop==='mounted'?'/art/campaign-rider.webp':'/art/foot-guard.webp'} alt=""/>
        <strong>{troops[troop].name}</strong>
        <small>{recruitsAvailable(company,site,troop)} available · {troops[troop].cost} coin each</small>
      </button>)}</div>
    <label className="quantity-slider">Recruits <input type="range" min={0} max={Math.max(0,available)} value={Math.min(count,Math.max(0,available))} onChange={e=>setCount(Number(e.target.value))}/> <output>{Math.min(count,Math.max(0,available))}</output></label>
    <p>{world.economy.gold} coin in your purse · {world.encounter.guards+1} in your company</p>
    <button disabled={!count || count>available || price>world.economy.gold} onClick={()=>send({type:'recruit',troop:selected,count})}>Recruit {count} · {price} coin</button>
    <button onClick={onBack}>Return to settlement</button>
  </div>;
}
