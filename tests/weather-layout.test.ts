import test from 'node:test';
import assert from 'node:assert/strict';
import {campaignWeather} from '../packages/sim/src/weather.ts';
import {separateMarker} from '../packages/map/src/marker-layout.ts';
test('weather repeats from campaign time and slows night travel',()=>{
 assert.deepEqual(campaignWeather(5000),campaignWeather(5000));
 assert.equal(campaignWeather(14).night,true);
 assert.ok(campaignWeather(14).movementPercent<100);
});
test('nearby fort and village markers separate while isolated markers retain position',()=>{
 const fort={x:100,y:100,width:76,height:42};
 const village=separateMarker({x:101,y:101,width:52,height:32},[fort]);
 assert.ok(Math.abs(village.x-fort.x)>50||Math.abs(village.y-fort.y)>50);
 assert.deepEqual(separateMarker(fort,[]),fort);
});
