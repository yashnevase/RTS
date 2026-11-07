import test from 'node:test';
import assert from 'node:assert/strict';
import {createEconomy,trade,questAction,economyHour,merchantVisit,price} from '../packages/sim/src/economy.ts';
test('trade transfers stock and money atomically and rejects unaffordable purchases',()=>{
 const e=createEconomy(),m=e.markets.site_pune,total=e.gold+m.money;
 trade(e,'site_pune','grain',true);
 assert.equal(e.inventory.grain,1);assert.equal(m.stock.grain,149);assert.equal(e.gold+m.money,total);
 e.gold=0;const before=JSON.stringify(m);trade(e,'site_pune','wood',true);assert.equal(JSON.stringify(m),before);
});
test('timed delivery rewards once and expires after its deadline',()=>{
 const e=createEconomy();questAction(e,0);e.inventory={grain:20,wood:50};
 questAction(e,96);const gold=e.gold;questAction(e,96);assert.equal(e.gold,gold);assert.equal(e.quest?.status,'completed');
 const late=createEconomy();questAction(late,0);economyHour(late,97);assert.equal(late.quest?.status,'failed');
});
test('merchant carries purchased cargo, conserves money and keeps stocks bounded across five years',()=>{
 const e=createEconomy(),m={gold:1000,cargo:{grain:0,wood:0},destination:null as string|null,trades:0};
 const funds=()=>m.gold+Object.values(e.markets).reduce((s,m)=>s+m.money,0);
 const initial=funds();let node='site_ahmadnagar';
 for(let day=0;day<365*5;day++){
   merchantVisit(e,m,node);node=m.destination??node;
   for(const market of Object.values(e.markets))for(const good of ['grain','wood'] as const){
     assert.ok(market.stock[good]>=0);assert.ok(price(market,good)>=2&&price(market,good)<=30);
   }
 }
 assert.equal(funds(),initial);assert.ok(m.trades>0);
});
