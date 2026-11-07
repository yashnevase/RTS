import assert from 'node:assert/strict';
import test from 'node:test';
import {advance, command, createCampaign, plan, edges} from '../packages/sim/src/travel.ts';
import {readFileSync} from 'node:fs';

test('travel edges use real catalog IDs and the Pune trip matches its quoted ETA',()=>{
  const ids=new Set(['sites','forts'].flatMap(k=>JSON.parse(readFileSync(`data/world/${k}/${k}_region01.json`,'utf8')).map(r=>r.id)));
  for(const edge of edges) assert.ok(ids.has(edge.a)&&ids.has(edge.b)&&edge.metres>0);
  for(const speed of [1,2,4] as const) {
    const state=createCampaign(), player=state.parties[0];
    const quote=plan(player,'site_ahmadnagar',0)!;
    command(state,{type:'travel',to:'site_ahmadnagar'});
    command(state,{type:'speed',value:speed});
    for(let n=0;n<quote.hours;n++) advance(state);
    assert.equal(player.node,'site_ahmadnagar');assert.equal(state.speed,speed);
    assert.equal(state.tick,quote.hours);
    assert.ok(quote.hours>=48 && quote.hours<=96);
  }
});
test('pause freezes the world and a finite wait advances NPCs while holding player position',()=>{
  const state=createCampaign(), player=state.parties[0];
  command(state,{type:'travel',to:'site_ahmadnagar'});advance(state);
  command(state,{type:'speed',value:0});const snapshot=JSON.stringify(state);
  advance(state);assert.equal(JSON.stringify(state),snapshot);
  command(state,{type:'wait',hours:6});
  const before=JSON.stringify(player), traffic=JSON.stringify(state.parties.slice(1));
  for(let i=0;i<6;i++)advance(state);
  assert.equal(state.tick,7);assert.equal(state.speed,1);assert.equal(JSON.stringify(player),before);
  assert.notEqual(JSON.stringify(state.parties.slice(1)),traffic);
});
test('rerouting preserves current edge progress; unreachable targets never teleport the party',()=>{
  const state=createCampaign(),p=state.parties[0];
  command(state,{type:'travel',to:'site_ahmadnagar'});advance(state);
  const progress=p.metres;
  command(state,{type:'travel',to:'site_solapur'});
  assert.deepEqual(p.path,['site_ahmadnagar','site_khirki','site_solapur']);assert.equal(p.metres,progress);
  const before=JSON.stringify(p);command(state,{type:'travel',to:'landmark_old_goa'});
  assert.equal(JSON.stringify(p),before);
});
test('seeded traffic replays, pace changes ETA, monsoon slows travel',()=>{
  const run=(seed:number)=>{
    const world=createCampaign(seed);command(world,{type:'speed',value:4});
    for(let i=0;i<100;i++)advance(world);return world;
  };
  assert.deepEqual(run(12),run(12));assert.notDeepEqual(run(12).parties.slice(1),run(28).parties.slice(1));
  const p=createCampaign().parties[0],dry=plan(p,'site_ahmadnagar',0)!.hours;
  assert.ok(plan(p,'site_ahmadnagar',151*24)!.hours>dry);
  p.pace='swift';assert.ok(plan(p,'site_ahmadnagar',0)!.hours<dry);
});
