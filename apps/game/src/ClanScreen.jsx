import {PortraitPicker} from './PortraitPicker.jsx';
import {TroopTransfer} from './TroopTransfer.jsx';
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
 const detached=clan.detachments.reduce((sum,d)=>sum+(d.allowance??10),0);
 const bill=monthlyWages(world.encounter.guards-company.mounted,company.mounted,company.companions.length)+detached;
 return <div className="clan-layout">
  <section><div className="clan-leader"><img src="/art/envoy.webp" alt="Clan leader"/><div><p className="eyebrow">Your clan</p><h2>House {world.identity.house}</h2><p>Leader · {world.identity.name}</p></div></div>
   <p>Monthly payroll · {bill} coin<br/>Next payment in {Math.ceil((720-world.tick%720)/24)} days<br/>Unpaid wages · {clan.arrears}</p>
   <p>Foot guard 1 · Mounted scout 2 · Companion 5 coin per month</p>
   {clanRoles.map(role=><div className="clan-role" key={role}><span>{role}</span><PortraitPicker label="Unassigned" value={clan.roles[role]??''} onChange={member=>send({type:'clan-role',role,member})} options={[{id:'',name:'Unassigned'},...['player',...free].map(id=>({id,name:name(id),image:id==='player'?'/art/envoy.webp':'/art/saswad-supplier.webp'}))]}/></div>)}
   <small>Appointments are saved. Role skill bonuses are still under development.</small>
  </section>
  <section><h2>Companion parties</h2>
   {clan.detachments.map(d=><article className="companion-party-card" key={d.id}><img className="party-leader-art" src={d.leader==='site_pune'?'/art/foot-guard.webp':'/art/campaign-rider.webp'} alt="Companion role illustration"/><h3>{name(d.leader)} company</h3><p>{d.foot} foot · {d.mounted} mounted · {d.task}<br/>Purse {d.gold??0} · Food {d.food??0}</p><label>Monthly allowance <input type="number" min="5" max="100" value={d.allowance??10} onChange={e=>send({type:'party-budget',id:d.id,amount:Number(e.target.value)})}/></label><p>{d.decision??'Preparing patrol'}<br/>Party wage debt {d.wageDebt??0}</p><p>Ambition {d.ambition??50} · Generosity {d.generosity??50} · Aggression {d.aggression??35}</p><button onClick={()=>send({type:'recall-party',id:d.id})}>Recall</button><button onClick={()=>send({type:'merge-party',id:d.id})}>Rejoin when nearby</button></article>)}
   <PortraitPicker label="Choose a companion" value={leader} onChange={setLeader} options={[{id:'',name:'Choose a companion'},...free.map(id=>({id,name:name(id),image:'/art/saswad-supplier.webp'}))]}/>
   <TroopTransfer type="foot" count={foot} max={world.encounter.guards-company.mounted} onChange={setFoot}/>
   <TroopTransfer type="mounted" count={mounted} max={company.mounted} onChange={setMounted}/>
   <button disabled={!leader||!foot&&!mounted||!!world.parties[0].motion||!anchor(world.parties[0].node)} onClick={()=>{send({type:'create-party',leader,foot:Math.min(foot,world.encounter.guards-company.mounted),mounted:Math.min(mounted,company.mounted)});setLeader('');setFoot(0);setMounted(0);}}>Create patrol party</button>
   <p>Parties choose markets for resupply or patrol according to food, funds, relations and distance. Recall orders them back toward you. Each receives a starting purse and food, buys provisions locally, and receives a monthly allowance.</p>
  </section>
 </div>;
}
