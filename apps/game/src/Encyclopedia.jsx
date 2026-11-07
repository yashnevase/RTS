import {EntityText} from './EntityText.jsx';
import {locationOf} from './Campaign.jsx';
import {settlementServices} from '../../../packages/sim/src/company.ts';
import React,{useState} from 'react';
import {records,byId} from './places.js';
import people from '../../../data/people/characters_stub.json';
import {goods,price} from '../../../packages/sim/src/economy.ts';

const supplier={id:'supplier',name:'Saswad supplier',kind:'person',status:'Fictional supporting character',
  image:'/art/saswad-supplier.webp',notes:'A local supplier looking for grain and timber in Saswad.'};
const historicalPeople=people.map(person=>({...person,kind:'person',name:person.identity.primary_name}));
const title=id=>id?.replace(/^(polity_|region_)/,'').replaceAll('_',' ')??'Unknown';
const art=record=>record.image??(record.kind==='fort'?'/art/fort-token.webp':record.kind==='site'?'/art/village-token.webp':null);

export function Encyclopedia({world,onLocate,initialId}) {
  const [query,setQuery]=useState('');
  const [category,setCategory]=useState('All');
  const [selected,setSelected]=useState(initialId??'site_pune');
  const player={id:'player',name:world.identity?.name??'Traveller',kind:'person',image:'/art/envoy.webp',
    notes:'Leader of House '+(world.identity?.house||'Unknown'),status:'Player character'};
  const companions=world.company?.companions.map(id=>({id,name:settlementServices[id]?.meetingHouse?.name??id,kind:'person',status:'Fictional companion',image:'/art/foot-guard.webp',notes:'Member of your clan.'}))??[];
  const entries=[player,supplier,...companions,...historicalPeople,...records];
  const party=world.parties.find(p=>p.id===selected||p.id==='clan:'+selected);
  const location=party?locationOf(party):selected==='supplier'?byId.get('site_saswad').coordinate:companions.some(p=>p.id===selected)?locationOf(world.parties[0]):null;
  const record=entries.find(r=>r.id===selected)??entries[0];
  const matches=entries.filter(r=>(category==='All'||r.kind===category)&&
    [r.name,...(r.name_variants??r.identity?.name_variants??[])].join(' ').toLowerCase().includes(query.trim().toLowerCase()));
  const market=world.economy?.markets[record.id];
  const owner=record.ownership;
  const current=world.parties[0];
  return <div className="encyclopedia">
    <section className="ency-index" aria-label="Encyclopedia index">
      <input aria-label="Search encyclopedia" placeholder="Search names…" value={query} onChange={event=>setQuery(event.target.value)}/>
      <div className="ency-tabs">{[['All','All'],['person','People'],['site','Settlements'],['fort','Forts']].map(([id,label])=>
        <button key={id} aria-pressed={category===id} onClick={()=>setCategory(id)}>{label}</button>)}</div>
      <ul>{matches.map(entry=><li key={entry.id}><button aria-current={selected===entry.id} onClick={()=>setSelected(entry.id)}>{entry.name}</button></li>)}</ul>
      {!matches.length&&<p>No matching entries.</p>}
    </section>
    <article className="ency-entry" aria-live="polite">
      <header><div className="ency-art">{art(record)?<img src={art(record)} alt={record.kind==='person'?'Character illustration':'Illustration of the place type'}/>:<span aria-hidden="true">◇</span>}</div>
        <div><p className="eyebrow">{record.kind==='person'?'Person':record.fort_type??record.site_type}</p><h2>{record.name}</h2><p>{record.status}</p>
        {(record.coordinate||location)&&<button onClick={()=>onLocate(record.coordinate?record:{...record,id:party?.id??'player',partyId:party?.id??'player',coordinate:location})}>Locate on map</button>}</div></header>
      <div className="ency-body"><p><EntityText text={record.notes} onOpen={setSelected}/></p>
        {record.coordinate&&<dl>
          <dt>Region</dt><dd>{title(record.region_id)}</dd><dt>Sovereignty</dt><dd>{title(owner?.sovereign_polity_id)}</dd><dt>Control</dt><dd>{title(owner?.controller_polity_id)}</dd></dl>}
        {record.id==='supplier'&&<><h3>Campaign</h3><p>Relation with you <strong>{world.relations?.supplier??0}</strong></p><p>Supply contract · {world.economy?.quest?.status??'available'}</p>
          {world.relations?.supplier>=15&&<p>Supplier favor reduces your purchase prices at Saswad.</p>}
          <button onClick={()=>setSelected('site_saswad')}>Read about Saswad</button></>}
        {record.id==='player'&&<><h3>Campaign</h3><p>{current.motion?'Travelling':byId.get(current.node)?.name??'Open country'} · {world.encounter?.guards??3} guards · {world.economy?.gold??600} coin</p></>}
        {market&&<><h3>Market today</h3><table><thead><tr><th>Good</th><th>In stock</th><th>Coin per unit</th></tr></thead>
          <tbody>{goods.map(g=><tr key={g}><td>{g}</td><td>{market.stock[g]}</td><td>{price(market,g)}</td></tr>)}</tbody></table></>}
        {record.id==='site_saswad'&&<button onClick={()=>setSelected('supplier')}>Read about the supplier</button>}
        {record.id==='fort_janjira'&&<button onClick={()=>setSelected('character_siddi_ambar_sanak')}>Read about Siddi Ambar Sanak</button>}
        {record.confidence&&<p>Record confidence · {record.confidence}</p>}
        {record.source_ids?.length>0&&<details><summary>Catalog sources</summary><ul>{record.source_ids.map(id=><li key={id}>{id}</li>)}</ul></details>}
        {record.source&&<a href={record.source}>Reference record</a>}
      </div>
    </article>
  </div>;
}
