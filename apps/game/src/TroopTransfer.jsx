import React from 'react';
import {troops} from '../../../packages/sim/src/company.ts';

export function TroopTransfer({type,count,max,onChange,verb='Transfer'}){
 const troop=troops[type],value=Math.min(count,max);
 return <div className="troop-transfer-card">
  <img src={type==='foot'?'/art/foot-guard.webp':'/art/campaign-rider.webp'} alt={troop.name}/>
  <div><strong>{troop.name}</strong><small>{max} available · {troop.cost} coin enlistment</small>
   <div className="troop-transfer-control">
    <button aria-label={'Decrease '+troop.name} disabled={!value} onClick={()=>onChange(value-1)}>−</button>
    <input type="range" aria-label={verb+' '+troop.name} min="0" max={max} value={value} onChange={e=>onChange(Number(e.target.value))}/>
    <button aria-label={'Increase '+troop.name} disabled={value>=max} onClick={()=>onChange(value+1)}>+</button>
    <output>{value} / {max}</output>
   </div>
  </div>
 </div>;
}
