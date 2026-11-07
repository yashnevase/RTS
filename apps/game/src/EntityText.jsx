import React from 'react';
import {records} from './places.js';
export function EntityText({text,onOpen}){
 const names=records.map(r=>({id:r.id,name:r.name})).sort((a,b)=>b.name.length-a.name.length);
 const pattern=new RegExp('('+names.map(r=>r.name.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')).join('|')+')','g');
 return String(text??'').split(pattern).map((part,i)=>{
   const record=names.find(r=>r.name===part);
   return record?<button className="entity-link" key={i} onClick={()=>onOpen(record.id)}>{part}</button>:part;
 });
}
