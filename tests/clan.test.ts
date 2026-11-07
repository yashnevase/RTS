import test from 'node:test';
import assert from 'node:assert/strict';
import {monthlyWages,returnTroops} from '../packages/sim/src/clan.ts';
test('returning troops refunds fees and rejects duplicate or impossible transfers',()=>{
 const funds={gold:0},roster={guards:3},company={mounted:1};
 assert.ok(returnTroops(funds,roster,company,2,1));
 assert.equal(funds.gold,155);
 assert.equal(roster.guards,0);
 assert.equal(returnTroops(funds,roster,company,2,1),false);
 assert.equal(funds.gold,155);
});
test('monthly payroll includes foot, mounted and loyal companions',()=>{
 assert.equal(monthlyWages(3,2,1),12);
});
