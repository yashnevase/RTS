import React from 'react';
import {ItemIcon} from './ItemIcon.jsx';
export function WorkshopScreen({world,send}){
 const w=world.workshop;
 if(!w)return null;
 const act=(action,extra={})=>send({type:'workshop',action,...extra});
 const local=world.parties[0].node==='site_pune'&&!world.parties[0].motion;
 if(!w.owned)return <><h2>Pune grain mill</h2><p>2 grain → 2 flour · 6 hours · 2 coin wages</p><button disabled={!local||world.economy.gold<300} onClick={()=>act('buy')}>Purchase mill · 300 coin</button><p>Visit Pune to purchase the mill.</p></>;
 return <div className="workshop-layout">
 <section><img src="/art/village-token.webp" alt="Mill type illustration"/><h2>Pune grain mill</h2><p>2 grain → 2 flour · 6 hours</p><strong>{w.status}</strong><progress value={w.progress} max="6"/><p><ItemIcon kind="grain"/>Inputs {w.grain}/40 · Output flour {w.flour}/40</p><button disabled={!local} onClick={()=>act('deposit')}>Deposit 2 grain</button><button disabled={!local||!w.flour} onClick={()=>act('withdraw')}>Collect flour</button></section>
 <section><h2>Operations</h2>{[['paused','Pause production'],['autoBuy','Buy grain automatically'],['autoSell','Sell flour automatically']].map(([key,label])=><label key={key}><input type="checkbox" checked={w[key]} onChange={e=>act('settings',{[key]:e.target.checked})}/>{label}</label>)}
 <label>Maximum grain price<input type="number" min="1" max="50" value={w.maxInput} onChange={e=>act('settings',{maxInput:Number(e.target.value)})}/></label>
 <label>Minimum flour sale price<input type="number" min="1" max="50" value={w.minOutput} onChange={e=>act('settings',{minOutput:Number(e.target.value)})}/></label>
 <p>Working capital · {w.cash} coin</p><button disabled={world.economy.gold<100} onClick={()=>act('capital',{amount:100})}>Fund 100 coin</button><button disabled={w.cash<100} onClick={()=>act('capital',{amount:-100})}>Withdraw 100 coin</button>
 <h3>Recent operating transactions</h3>{w.ledger.slice(0,8).map((e,i)=><p key={i}>Day {1+Math.floor(e.tick/24)} · {e.reason} <b className={e.amount<0?'quote-debit':'quote-credit'}>{e.amount>0?'+':''}{e.amount}</b></p>)}
 <p>Last 7 days net operations · {w.ledger.filter(e=>e.tick>world.tick-168).reduce((sum,e)=>sum+e.amount,0)} coin</p></section>
 </div>;
}
