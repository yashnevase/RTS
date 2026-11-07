import test from 'node:test';
import assert from 'node:assert/strict';
import {choosePartyDestination} from '../packages/sim/src/party-planner.ts';
const needs={food:0,gold:20,foot:3,mounted:0,ambition:50,aggression:35};
test('hungry parties choose affordable reachable food and avoid empty or unreachable markets',()=>{
 const result=choosePartyDestination(needs,'field','home',[
 {id:'empty',hours:1,foodPrice:2,stock:0,relation:0},
 {id:'blocked',hours:Infinity,foodPrice:1,stock:30,relation:0},
 {id:'near',hours:2,foodPrice:5,stock:30,relation:0},
 {id:'far',hours:20,foodPrice:3,stock:30,relation:0}]);
 assert.equal(result.destination,'near');
 assert.match(result.reason,/Resupply/);
});
test('party choices replay consistently and do not spend imaginary money',()=>{
 const choices=[{id:'town',hours:2,foodPrice:5,stock:30,relation:0}];
 assert.deepEqual(choosePartyDestination(needs,'home','home',choices),choosePartyDestination(needs,'home','home',choices));
 assert.match(choosePartyDestination({...needs,gold:0},'town','home',choices).reason,/unaffordable/);
});
