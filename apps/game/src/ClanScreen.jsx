import {anchor} from '../../../packages/sim/src/navigation.ts';
import React,{useState} from 'react';
import {clanRoles,monthlyWages} from '../../../packages/sim/src/clan.ts';
import {settlementServices} from '../../../packages/sim/src/company.ts';
export function ClanScreen({world,send}){
 const [leader,setLeader]=useState(''),[foot,setFoot]=useState(0),[mounted,setMounted]=useState(0);
 const clan=world.clan,company=world.company;
 if(!clan||!company)return null;
 const free=company.companions.filter(id=>!clan.detachments.some(d=>d.leader===id));
 const name=id=>id==='player'?world.identity.name:settlementServices[id]?.meetingHouse?.name??id;
 const detached=clan.detachments.reduce((sum,d)=>sum+monthlyWages(d.foot,d.mounted,0),0);
 const bill=monthlyWages(world.encounter.guards-company.mounted,company.mounted,company.companions.length)+detached;
 return <div className="clan-layout">
  <section><h2>House {world.identity.house}</h2><p>Leader · {world.identity.name}</p>
   <p>Monthly payroll · {bill} coin<br/>Next payment in {Math.ceil((720-world.tick%720)/24)} days<br/>Unpaid wages · {clan.arrears}</p>
   <p>Foot guard 1 · Mounted scout 2 · Companion 5 coin per month</p>
   {clanRoles.map(role=><label className="clan-role" key={role}>{role}<select value={clan.roles[role]??''} onChange={e=>send({type:'clan-role',role,member:e.target.value})}><option value="">Unassigned</option>{['player',...free].map(id=><option key={id} value={id}>{name(id)}</option>)}</select></label>)}
   <small>Appointments are saved. Role skill bonuses are still under development.</small>
  </section>
  <section><h2>Companion parties</h2>
   {clan.detachments.map(d=><article key={d.id}><h3>{name(d.leader)} company</h3><p>{d.foot} foot · {d.mounted} mounted · {d.task}</p><button onClick={()=>send({type:'recall-party',id:d.id})}>Recall</button><button onClick={()=>send({type:'merge-party',id:d.id})}>Rejoin when nearby</button></article>)}
   <label>Party leader <select value={leader} onChange={e=>setLeader(e.target.value)}><option value="">Choose a companion</option>{free.map(id=><option key={id} value={id}>{name(id)}</option>)}</select></label>
   <label className="quantity-slider">Foot guards<input type="range" min="0" max={world.encounter.guards-company.mounted} value={foot} onChange={e=>setFoot(Number(e.target.value))}/><output>{foot}</output></label>
   <label className="quantity-slider">Mounted scouts<input type="range" min="0" max={company.mounted} value={mounted} onChange={e=>setMounted(Number(e.target.value))}/><output>{mounted}</output></label>
   <button disabled={!leader||!foot&&!mounted||!!world.parties[0].motion||!anchor(world.parties[0].node)} onClick={()=>{send({type:'create-party',leader,foot,mounted});setLeader('');setFoot(0);setMounted(0);}}>Create patrol party</button>
   <p>Patrols move independently between their home and Saswad. Recall orders them back toward you. Each draws one grain per day from shared clan stores.</p>
  </section>
 </div>;
}
