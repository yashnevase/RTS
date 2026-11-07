import test from 'node:test';
import assert from 'node:assert/strict';
import {createWorkshop,workshopHour} from '../packages/sim/src/workshop.ts';
import {createEconomy} from '../packages/sim/src/economy.ts';
test('mill consumes grain and wages before output, and pause freezes production',()=>{
 const w=createWorkshop(),e=createEconomy();
 w.owned=true;w.autoBuy=false;w.autoSell=false;w.grain=2;w.cash=10;
 for(let hour=1;hour<=6;hour++)workshopHour(w,e,hour);
 assert.equal(w.grain,0);assert.equal(w.flour,2);assert.equal(w.cash,8);
 w.paused=true;const saved=structuredClone(w);workshopHour(w,e,7);assert.equal(w.cash,saved.cash);assert.equal(w.flour,saved.flour);
});
test('unsold output earns no cash and storage blocks more production',()=>{
 const w=createWorkshop(),e=createEconomy();
 w.owned=true;w.autoBuy=false;w.flour=40;w.grain=20;w.cash=10;w.minOutput=50;
 workshopHour(w,e,1);assert.equal(w.cash,10);assert.equal(w.grain,20);assert.equal(w.status,'Output storage full');
});
