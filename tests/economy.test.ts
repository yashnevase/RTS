import test from 'node:test';
import assert from 'node:assert/strict';
import {createEconomy,trade,questAction,economyHour,merchantVisit,price,previewTrade,caravanEconomy} from '../packages/sim/src/economy.ts';
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

test('batch prices reflect each unit and an unaffordable batch commits nothing',()=>{
 const e=createEconomy(),m=e.markets.site_pune;
 trade(e,'site_pune','wood',true,5);
 assert.equal(e.inventory.wood,5);
 assert.equal(m.stock.wood,25);
 assert.equal(e.gold+m.money,20600);
 const before=JSON.stringify([e.gold,e.inventory,m]);
 trade(e,'site_pune','wood',true,50);
 assert.equal(JSON.stringify([e.gold,e.inventory,m]),before);
 trade(e,'site_pune','wood',false,5);
 assert.equal(e.inventory.wood,0);
 assert.equal(m.stock.wood,30);
 assert.equal(e.gold+m.money,20600);
});

test('trade preview leaves the original market untouched and rejects a partially affordable basket',()=>{
 const economy=createEconomy();
 const original=structuredClone(economy);
 const grain={good:'grain',buy:true,quantity:2} as const;
 const draft=previewTrade(economy,'site_pune',[grain],0);
 assert.equal(draft?.inventory.grain,2);
 assert.deepEqual(economy,original);
 assert.equal(previewTrade(economy,'site_pune',[grain,{good:'wood',buy:true,quantity:100}],0),null);
 assert.deepEqual(economy,original);
});

test('caravan quotes use carried cargo and preserve combined money',()=>{
 const economy=createEconomy();
 const merchant={gold:50,cargo:{wood:3,grain:0},destination:null,trades:0};
 const draft=previewTrade(caravanEconomy(economy,merchant),'caravan',[{good:'wood',buy:true,quantity:1}],0);
 assert.ok(draft);
 assert.equal(draft.markets.caravan.stock.wood,2);
 assert.equal(draft.markets.caravan.money+draft.gold,650);
 assert.equal(merchant.cargo.wood,3);
});
