import test from 'node:test';
import assert from 'node:assert/strict';
import {anchor,route,accessible,clearSegment,coordinate,travelEffort} from '../packages/sim/src/navigation.ts';
import {startMotion,move,position} from '../packages/sim/src/movement.ts';
test('terrain route reaches Saswad, avoids blocked cells and rejects sea',()=>{
 const from=anchor('site_pune'),to=anchor('site_saswad'),points=route(from,to,true);
 assert.ok(points);assert.ok(points.length>=2);
 for(let i=1;i<points.length;i++)assert.ok(clearSegment(points[i-1],points[i]));
 for(const point of points.slice(1,-1))assert.ok(accessible(point));
 assert.equal(route(from,{longitude:72.1,latitude:17}),null);
});
test('movement progresses continuously and arrives without jumping back to a settlement',()=>{
 const motion=startMotion(anchor('site_pune'),anchor('site_saswad'),'site_saswad')!;
 assert.ok(motion);const before=position(motion);let done=false;
 for(let i=0;i<200&&!done;i++)done=move(motion,4000);
 assert.ok(done);assert.deepEqual(position(motion),anchor('site_saswad'));assert.notDeepEqual(position(motion),before);
});


test('open ground produces a direct diagonal route with no grid staircase',()=>{
 const a=anchor('site_pune'),b=anchor('site_saswad');
 assert.ok(clearSegment(a,b));
 const points=route(a,b,true)!;
 assert.equal(points.length,2);
 assert.deepEqual(points[0],a);assert.deepEqual(points[1],b);
});

test('a blocked settlement pin has a walkable gameplay approach',()=>{
 const from=anchor('site_pune')!, approach=anchor('site_daund')!;
 assert.ok(accessible(approach));
 const points=route(from,approach,true)!;
 assert.deepEqual(points.at(-1),approach);
 for(let i=1;i<points.length;i++)assert.ok(clearSegment(points[i-1],points[i]));
});

test('smoothing keeps a cheaper bend when the direct line crosses slower terrain',()=>{
 const start=coordinate(21003),end=coordinate(23412);
 assert.ok(clearSegment(start,end));
 const points=route(start,end)!;
 assert.ok(points.length>2);
 const routedEffort=points.slice(1).reduce((total,point,i)=>total+travelEffort(points[i],point),0);
 assert.ok(routedEffort<travelEffort(start,end));
});
