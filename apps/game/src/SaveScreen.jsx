import React,{useState} from 'react';
import {readSlot,writeSlot,deleteSlot,parseCampaign} from './campaign-save.js';
export function SaveScreen({world,send,onClose}){
 const [revision,refresh]=useState(0),[message,setMessage]=useState('');
 const [pending,setPending]=useState(null);
 const slots=Array.from({length:5},(_,i)=>({id:i+1,world:readSlot(i+1)}));
 function exportSlot(slot){
   const url=URL.createObjectURL(new Blob([JSON.stringify({version:1,world:slot.world},null,2)],{type:'application/json'}));
   const a=document.createElement('a');a.href=url;a.download='deccan-warlords-slot-'+slot.id+'.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
 }
 return <div className="save-manager">
 <p>5 local slots. Export JSON to keep a copy in your chosen download folder.</p>
 {slots.map(slot=><section key={slot.id}><strong>Slot {slot.id}</strong><span>{slot.world?slot.world.identity.name+' · Day '+(1+Math.floor(slot.world.tick/24)):'Empty'}</span>
 <button onClick={()=>{if(slot.world)setPending({type:'save',slot:slot.id});else{setMessage(writeSlot(slot.id,world)?'Saved':'Save failed');refresh(revision+1);}}}>Save here</button>
 <button disabled={!slot.world} onClick={()=>setPending({type:'load',slot:slot.id})}>Load</button>
 <button disabled={!slot.world} onClick={()=>exportSlot(slot)}>Export JSON</button>
 <button disabled={!slot.world} onClick={()=>setPending({type:'delete',slot:slot.id})}>Delete</button>
 </section>)}
 {pending&&<div><p>{pending.type==='load'?'Load this slot? Unsaved progress will be replaced.':pending.type==='save'?'Overwrite this slot?':'Delete this slot?'}</p><button onClick={()=>setPending(null)}>Cancel</button><button onClick={()=>{
   if(pending.type==='save')setMessage(writeSlot(pending.slot,world)?'Saved':'Save failed');
   if(pending.type==='delete')deleteSlot(pending.slot);
   if(pending.type==='load'){const saved=readSlot(pending.slot);if(saved){send({type:'restore',world:saved});onClose();}}
   setPending(null);refresh(revision+1);
 }}>Confirm</button></div>}
 <label>Import JSON into an empty slot <input type="file" accept=".json,application/json" onChange={async e=>{
   const file=e.target.files?.[0];if(!file)return;
   const saved=parseCampaign(await file.text()),empty=slots.find(s=>!s.world);
   setMessage(!saved?'Invalid campaign JSON':!empty?'All slots are occupied. Clear a slot first.':writeSlot(empty.id,saved)?'Imported into slot '+empty.id:'Import failed');
   refresh(revision+1);e.target.value='';
 }}/></label><p role="status">{message}</p>
 </div>;
}
