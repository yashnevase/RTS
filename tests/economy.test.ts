import test from 'node:test';
import assert from 'node:assert/strict';
import {createEconomy,trade,questAction,economyHour,merchantVisit,price,previewTrade,caravanEconomy,deliverGrain,profitableDestinations} from '../packages/sim/src/economy.ts';
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

test('buying and immediately returning the same batch restores purse and stock',()=>{
 for(const relation of [0,15]){
   const economy=createEconomy();
   const node='site_saswad', before=structuredClone(economy);
   assert.ok(trade(economy,node,'grain',true,10,relation));
   assert.ok(trade(economy,node,'grain',false,10,relation));
   assert.equal(economy.gold,before.gold);
   assert.deepEqual(economy.markets,before.markets);
 }
});

test('scarcity raises quotes, deliveries ease them and market storage is capped',()=>{
 const economy=createEconomy();
 const node='site_pune', market=economy.markets[node];
 const starting=price(market,'grain');
 assert.ok(trade(economy,node,'grain',true,60));
 assert.ok(price(market,'grain')>starting);
 const depleted=price(market,'grain');
 assert.equal(deliverGrain(economy,node,12),10);
 assert.ok(price(market,'grain')<=depleted);
 assert.equal(deliverGrain(economy,node,12),0);
 market.stock.grain=market.target.grain*3;
 assert.equal(trade(economy,node,'grain',false,1),undefined);
 assert.equal(price(market,'grain'),3);
});

test('weekly prices ignore small daily movements but react to a large stock shock',()=>{
 const e=createEconomy(), market=e.markets.site_pune;
 const initial=price(market,'grain');
 economyHour(e,24);economyHour(e,48);
 assert.equal(price(market,'grain'),initial);
 market.stock.grain=45;
 assert.ok(price(market,'grain')>initial);
 economyHour(e,168);
 assert.equal(market.referenceStock?.grain,market.stock.grain);
});

test('profitable routes exclude losses and use the full selected quantity',()=>{
 const e=createEconomy();
 assert.ok(profitableDestinations(e,'site_chaul','fish',10,0).some(route=>route.id==='site_ahmadnagar'));
 assert.deepEqual(profitableDestinations(e,'site_ahmadnagar','fish',3,0),[]);
 assert.ok(profitableDestinations(e,'site_chaul','fish',20,0).every(route=>route.profit>0));
});

test('markets recover from empty shelves and merchants leave a retail reserve',()=>{
 const economy=createEconomy();
 const pune=economy.markets.site_pune;
 pune.stock.grain=0;
 economyHour(economy,24);
 assert.ok(pune.stock.grain>0);
 pune.stock.grain=40;
 economy.markets.site_ahmadnagar.stock.grain=0;
 const merchant={gold:1000,cargo:{wood:0,grain:0},destination:null,trades:0};
 merchantVisit(economy,merchant,'site_pune');
 assert.ok(pune.stock.grain>=34);
});
