import {WorkshopScreen} from './WorkshopScreen.jsx';
import {SaveScreen} from './SaveScreen.jsx';
import {EntityText} from './EntityText.jsx';
import {ClanScreen} from './ClanScreen.jsx';
import {TradeScreen} from './TradeScreen.jsx';
import {ItemIcon} from './ItemIcon.jsx';
import {SettlementServices} from './SettlementServices.jsx';
import {foodPerDay,marchBudget,settlementServices} from '../../../packages/sim/src/company.ts';
import React, {useState,useEffect} from 'react';
import {goods} from '../../../packages/sim/src/economy.ts';
import {Encyclopedia} from './Encyclopedia.jsx';
import {saveCampaign} from './campaign-save.js';
import {raiderSite, encounterTerrain} from '../../../packages/sim/src/encounter.ts';
import {byId} from './places.js';
const navigation = [['Inventory','▤','I'],['Party','⚔','P'],['Character','♙','C'],['Clan','◇','L'],['Quests','✧','J'],['Encyclopedia','▣','N'],['Settlement','⌂']];

function CompanyPortrait({identity,role}) {
  return <section className="equipment">
    <div className="roster-portrait"><img src="/art/envoy.webp" alt="Your fictional traveller"/></div>
    <h2>{identity?.name}</h2>
    <p>{role??identity?.house}</p>
  </section>;
}

export function Screens({world,send,onLocate,arrival,dismissal}) {
  const [page,setPage]=useState(null);
  const [entry,setEntry]=useState('site_pune');
  function openEntry(id){setEntry(id);setPage('Encyclopedia');}
  const [portrait,setPortrait]=useState(true);
  const [dismiss,setDismiss]=useState({foot:0,mounted:0});
  const [saveStatus,setSaveStatus]=useState('');
  const [topic,setTopic]=useState('greeting');
  const e=world.economy,p=world.parties[0],local=!p.path.length&&!p.motion;
  const site=byId.get(p.node), service=settlementServices[p.node];
  const company=world.company, mounted=company?.mounted??0, guards=world.encounter?.guards??3;
  const march=e&&marchBudget('steady',guards,mounted,e.inventory,company?.health??100);
  const power=id=>({polity_nizam_shahi:'Nizam Shahi',polity_adil_shahi:'Adil Shahi',polity_mughal:'Mughal',polity_portuguese:'Portuguese'}[id]??(id?id.replace(/^polity_/,'').replaceAll('_',' '):'Unknown'));
  useEffect(()=>{if(page)send({type:'speed',value:0});},[page]);
  useEffect(()=>{
    if(arrival && byId.has(arrival.id)) setPage(current=>current??'Settlement');
  },[arrival]);
  useEffect(()=>{
    setPage(current=>current==='Settlement'?null:current);
  },[dismissal]);
  useEffect(()=>{
    if(!local) setPage(current=>current==='Settlement'?null:current);
  },[local]);
  function open(value){setDismiss({foot:0,mounted:0});setPage(value);}
  useEffect(()=>{
    const keys=event=>{
      if(/INPUT|SELECT|TEXTAREA/.test(event.target.tagName))return;
      if(event.key==='Escape')open(null);
      const name={i:'Inventory',p:'Party',c:'Character',j:'Quests',n:'Encyclopedia',l:'Clan'}[event.key.toLowerCase()];
      if(name)open(name);
    };
    window.addEventListener('keydown',keys);return()=>window.removeEventListener('keydown',keys);
  },[]);
  return <><nav className="campaign-nav" aria-label="Campaign screens">{navigation.map(([name,symbol,key])=><button key={name} aria-label={name} aria-pressed={page===name} title={key?name+' · '+key:name} onClick={()=>open(name)}><span aria-hidden="true">{['Party','Inventory'].includes(name)?<ItemIcon kind={name}/>:symbol}</span>{name}</button>)}<button disabled={!world.started} onClick={()=>open('Saves')}>Save</button>{saveStatus&&<output>{saveStatus}</output>}</nav>
  {page&&<div className={'screen-shade'+(page==='Settlement'?' settlement-shade':'')}><section className={'game-screen'+(['Inventory','Party'].includes(page)?' roster-screen':'')} role="dialog" aria-modal={page!=='Settlement'} aria-label={page}><button className="close" onClick={()=>open(null)}>Close · Esc</button>{page!=='Settlement'&&<h1>{page}</h1>}
    {page==='Workshop'&&<WorkshopScreen world={world} send={send}/>}
    {page==='Saves'&&<SaveScreen world={world} send={send} onClose={()=>open(null)}/>}
    {page==='Encyclopedia'&&<Encyclopedia initialId={entry} key={entry} world={world} onLocate={record=>{setPage(null);onLocate(record);}}/>}
    {page==='Inventory'&&e&&<>
      <div className={'inventory-layout'+(portrait?'':' portrait-hidden')}>
        <section><h2>Equipment</h2><div className="item-row"><span>♙</span><b>Personal clothing</b></div><div className="item-row"><span>▣</span><b>Travel pack</b></div></section>
        {portrait&&<CompanyPortrait identity={world.identity}/>}
        <section><h2>Your stores</h2>{goods.map(g=><details className="trade-entry" key={g}><summary><ItemIcon kind={g}/><b>{g}</b><span>{e.inventory[g]??0}</span></summary><p>{g==='wood'?'Two load units each':'One load unit each'}</p></details>)}<p>Coin · {e.gold}</p></section>
      </div>
      <footer className="roster-footer"><button onClick={()=>setPortrait(!portrait)}>{portrait?'Hide portrait':'Show portrait'}</button><button onClick={()=>setPage(null)}>Done</button></footer>
    </>}
    {page==='Party'&&<>
      <div className={'inventory-layout'+(portrait?'':' portrait-hidden')}>
        <section><h2>Prisoners</h2><p>{company?.prisoners??0} held</p></section>
        {portrait&&<CompanyPortrait identity={world.identity} role="Company leader"/>}
        <section><h2>Your company · {1+(world.encounter?.guards??3)}</h2>
          <div className="item-row"><span>⚑</span><b>{world.identity?.name}</b><span>1</span></div>
          {[['foot','Foot guards',guards-mounted],['mounted','Mounted scouts',mounted]].filter(([, ,count])=>count>0).map(([id,name,count])=>
            <details className="trade-entry" key={id}><summary><img className="troop-icon" src={id==='mounted'?'/art/campaign-rider.webp':'/art/foot-guard.webp'} alt=""/><b>{name} · {count-dismiss[id]}</b></summary>
              <label className="quantity-slider">Release ← <input type="range" min="0" max={count} value={dismiss[id]} onChange={e=>setDismiss({...dismiss,[id]:Number(e.target.value)})}/> <output>{dismiss[id]}</output></label><button disabled={count<=dismiss[id]} onClick={()=>setDismiss({...dismiss,[id]:dismiss[id]+1})}>← Queue dismissal</button><button disabled={!dismiss[id]} onClick={()=>setDismiss({...dismiss,[id]:dismiss[id]-1})}>Undo one</button></details>)}
          {company?.companions.map(id=>{const contact=settlementServices[id]?.meetingHouse;return contact&&<div className="item-row" key={id}><span>◇</span><b>{contact.name}</b><span>{contact.role}</span></div>;})}
          {march&&<p>March · {(march.total/1000).toFixed(2)} km/h before terrain<br/><small>Base {(march.base/1000).toFixed(2)} + mounted {(march.cavalry/1000).toFixed(2)} − cargo {(march.penalty/1000).toFixed(2)} − fatigue {(march.fatigue/1000).toFixed(2)} · Load {march.load}/{march.capacity}</small></p>}
          <p>{p.motion?'On the march':'Camp · '+(byId.get(p.node)?.name??'Open country')}</p>
          <p>Food use · {foodPerDay(guards,company?.companions.length??0).toFixed(2)} rations/day at full health · Health {company?.health??100}%</p>
        </section>
      </div>
      <footer className="roster-footer"><button onClick={()=>setPortrait(!portrait)}>{portrait?'Hide portrait':'Show portrait'}</button><button onClick={()=>open(null)}>Cancel</button><button onClick={()=>{if(dismiss.foot||dismiss.mounted)send({type:'confirm-dismiss',counts:dismiss});open(null);}}>Done{dismiss.foot+dismiss.mounted>0?' · Dismiss '+(dismiss.foot+dismiss.mounted):''}</button></footer>
    </>}
    {page==='Clan'&&<ClanScreen world={world} send={send}/>}
    {page==='Character'&&<><img className="character-art" src="/art/envoy.webp" alt="Fictional player portrait"/><h2>{world.identity?.name} {world.identity?.house}</h2><p>Independent company · Fictional player character</p>{world.character&&<div className="character-stats"><p>Renown {world.character.renown} · Influence {world.character.influence} · Morale {world.character.morale}</p><h3>Skills</h3>{Object.entries(world.character.skills).map(([name,value])=><div className="skill-row" key={name}><strong>{name}</strong><progress max="100" value={value}/><b>{value}</b><small>{name==='trading'?'Grows after completed trades':name==='fighting'?'Grows through encounters and improves combat strength':'Reserved for future tactical decisions'}</small></div>)}<h3>Personality</h3>{Object.entries(world.character.traits).map(([name,value])=><p key={name}>{name} · {value}</p>)}<small>Trading grows with trades. Fighting grows with encounters. Victories and completed contracts earn renown. Influence is recorded for future political actions.</small></div>}<p><button className="entity-link" onClick={()=>openEntry('supplier')}>Saswad supplier</button> relation · {world.relations?.supplier??0}</p><button onClick={()=>open('Encyclopedia')}>Open encyclopedia</button></>}
    {page==='Quests'&&<><h2>Supplies for <button className="entity-link" onClick={()=>openEntry('site_saswad')}>Saswad</button></h2><p>{e?.quest?e.quest.status+' · '+Math.max(0,e.quest.due-world.tick)+' hours remaining':'Speak with the local supplier in Saswad.'}</p><p><ItemIcon kind="grain"/>20 grain · <ItemIcon kind="wood"/>50 wood · Reward 900 coin</p></>}
    {page==='Settlement'&&<><div className="settlement-heading"><small>{(site?.site_type??site?.fort_type??'Camp').replaceAll('_',' ')}</small><h2>{site?<button className="entity-link" onClick={()=>openEntry(site.id)}>{site.name}</button>:'Open country'}</h2>
      {site&&<p className="settlement-allegiance">Sovereignty · {power(site.ownership?.sovereign_polity_id)}<br/>Local control · {power(site.ownership?.controller_polity_id)}{site.confidence&&<><br/>Record confidence · {site.confidence}</>}</p>}</div>{!local?<p>Arrive before entering the settlement.</p>:<>
      <div className="settlement-actions">{p.node==='site_pune'&&<button onClick={()=>open('Workshop')}>Grain mill workshop</button>}
        {service&&<button onClick={()=>open('Recruitment')}>Recruit troops</button>}
        {service?.meetingHouse&&<button onClick={()=>open('Sarai')}>Visit the sarai</button>}
        {e?.markets[p.node]&&<button onClick={()=>open('Trade')}>Visit the market</button>}
        {p.node==='site_saswad'&&<button onClick={()=>open('Talk')}>Talk to the local supplier</button>}
        {p.node===raiderSite&&<button onClick={()=>open('Encounter')}>{world.encounter?.resolved?'Read the encounter report':'Investigate the raiders'}</button>}
        <button onClick={()=>{send({type:'wait',hours:6});setPage(null);}}>Wait here · 6 hours</button>
        <button onClick={()=>setPage(null)}>Leave</button>
      </div>{byId.has(p.node)&&<img className="settlement-illustration" src={byId.get(p.node).kind==='fort'?'/art/fort-token.webp':'/art/village-token.webp'} alt="Illustration of the settlement type"/>}</>}</>}
    {['Recruitment','Sarai'].includes(page)&&<SettlementServices key={page+':'+p.node} page={page} site={p.node} world={world} local={local} send={send} onBack={()=>open('Settlement')}/>}
    {page==='Talk'&&<div className="conversation"><div><img src="/art/saswad-supplier.webp" alt="Fictional local supplier"/><h2>Local supplier</h2><small>Saswad · Relation {world.relations?.supplier??0}</small></div><section><p className="eyebrow">A conversation in Saswad</p><blockquote>{e?.quest?.status==='completed'?'Your supplies have arrived. Here is your payment. You have our thanks.':e?.quest?.status==='failed'?'The deadline has passed. We had to seek help elsewhere.':topic==='greeting'?'Welcome, traveller. The settlement needs supplies. Can your company help?':'Bring 20 grain and 50 wood within 4 days. I can offer 900 coin when you deliver.'}</blockquote>
    <div className="dialogue-options"><button onClick={()=>setTopic('request')}>What supplies do you need?</button><button disabled={!local||p.node!=='site_saswad'||['completed','failed'].includes(e?.quest?.status)} onClick={()=>{send({type:'quest'});setTopic('request');}}>{e?.quest?'I brought the supplies.':'I will bring them.'}</button><button onClick={()=>open('Trade')}>Let me see your market.</button><button onClick={()=>open('Settlement')}>We will speak another time.</button></div><p role="status">{e?.notice}</p></section></div>}
    {page==='Encounter'&&world.encounter&&<div className="conversation encounter"><div><img src="/art/campaign-rider.webp" alt="Illustrated company rider"/><h2>Kondhana approaches</h2></div><section><p className="eyebrow">Fictional encounter</p>
      {world.encounter.result?<><h2>{world.encounter.result.outcome}</h2><p>{world.encounter.result.terrain} · {world.encounter.result.guardsLost} {world.encounter.result.guardsLost===1?'guard':'guards'} lost · {world.encounter.result.coin} coin recovered</p>
        <p>Company strength {world.encounter.result.strength} · Opposition {world.encounter.result.opposition}</p><button onClick={()=>setPage(null)}>Return to map</button></>:<>
        <blockquote>A raiding party watches the approach. Your company has {world.encounter.guards} guards.</blockquote>
        <p>{p.point?encounterTerrain(p.point).name:''}. Cover and elevation can favor the defenders.</p>
        <button disabled={!local||p.node!==raiderSite} onClick={()=>send({type:'resolve-encounter'})}>Send the company · Auto-resolve</button>
        <button onClick={()=>open('Settlement')}>Withdraw</button></>}
    </section></div>}
    {page==='Trade'&&e&&<TradeScreen key={p.node} world={world} site={p.node} local={local} send={send} onClose={()=>open('Settlement')}/>}



  </section></div>}</>;
}
