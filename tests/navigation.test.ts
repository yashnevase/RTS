import test from 'node:test';
import assert from 'node:assert/strict';
import {anchor,route,accessible} from '../packages/sim/src/navigation.ts';
import {startMotion,move,position} from '../packages/sim/src/movement.ts';
test('terrain route reaches Saswad, avoids blocked cells and rejects sea',()=>{
 const from=anchor('site_pune'),to=anchor('site_saswad'),points=route(from,to,true);
 assert.ok(points);assert.ok(points.length>2);
 for(const point of points.slice(1,-1))assert.ok(accessible(point));
 assert.equal(route(from,{longitude:72.1,latitude:17}),null);
});
test('movement progresses continuously and arrives without jumping back to a settlement',()=>{
 const motion=startMotion(anchor('site_pune'),anchor('site_saswad'),'site_saswad')!;
 assert.ok(motion);const before=position(motion);let done=false;
 for(let i=0;i<200&&!done;i++)done=move(motion,4000);
 assert.ok(done);assert.deepEqual(position(motion),anchor('site_saswad'));assert.notDeepEqual(position(motion),before);
});
