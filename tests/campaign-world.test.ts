import test from 'node:test';
import assert from 'node:assert/strict';
import {advanceMotion,type Motion} from '../packages/sim/src/movement.ts';
import {CampaignPlayback,sampleTrail} from '../packages/map/src/party-animation.ts';
import {anchor,coordinate,terrain} from '../packages/sim/src/navigation.ts';
import {changeRelation,resolveEncounter} from '../packages/sim/src/encounter.ts';
import {createEconomy,price,purchasePrice,trade} from '../packages/sim/src/economy.ts';

test('a travelled bend survives worker snapshots and display interpolation',()=>{
  const motion:Motion={points:[
    {latitude:18.5,longitude:73.8},{latitude:18.5,longitude:73.805},
    {latitude:18.505,longitude:73.805}
  ],index:0,progress:0,destination:null};
  const {arrived,trace}=advanceMotion(motion,4000);
  assert.ok(arrived);
  assert.deepEqual(trace[1],motion.points[1]);
  const result=sampleTrail([{x:0,y:0},{x:10,y:0},{x:10,y:10}],.75);
  assert.deepEqual(result,{x:10,y:5,heading:Math.PI/2});
});
test('playback preserves progress through pause and speed changes and consumes queued hours in order',()=>{
  const playback=new CampaignPlayback(900);
  playback.enqueue(1);
  playback.enqueue(2);
  assert.deepEqual(playback.advance(225,1),[]);
  assert.equal(playback.progress,.25);
  assert.deepEqual(playback.advance(500,0),[]);
  assert.equal(playback.progress,.25);
  assert.deepEqual(playback.advance(225,2),[]);
  assert.equal(playback.progress,.75);
  assert.deepEqual(playback.advance(112.5,4),[1]);
  assert.equal(playback.hour,2);
  assert.equal(playback.progress,.25);
  assert.deepEqual(playback.advance(900,1),[2]);
  assert.equal(playback.progress,0);
});
test('same encounter seed repeats and hill terrain improves defender strength',()=>{
  const hill=anchor('fort_kondhana');
  const open=coordinate(terrain.cost.findIndex(cost=>cost===10));
  const first=resolveEncounter(3,hill,1622);
  assert.deepEqual(first,resolveEncounter(3,hill,1622));
  assert.ok(first.opposition>resolveEncounter(3,open,1622).opposition);
  assert.equal(resolveEncounter(0,hill,1622).guardsLost,0);
});
test('supplier favor gives a local price benefit without creating coin',()=>{
  const e=createEconomy();
  const relation=changeRelation(0,15);
  const market=e.markets.site_saswad;
  const normal=price(market,'grain');
  const quote=purchasePrice(market,'grain','site_saswad',relation);
  assert.ok(quote<normal);
  const combined=e.gold+market.money;
  trade(e,'site_saswad','grain',true,1,relation);
  assert.equal(e.inventory.grain,1);
  assert.equal(e.gold,600-quote);
  assert.equal(e.gold+market.money,combined);
  trade(e,'site_saswad','grain',false,1,relation);
  assert.ok(e.gold<=600);
  assert.equal(e.gold+market.money,combined);
});
