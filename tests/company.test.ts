import test from 'node:test';
import assert from 'node:assert/strict';
import {createCompany,feedCompany,marchBudget,recruit,recruitsAvailable} from '../packages/sim/src/company.ts';

test('recruitment is limited by the local pool and charges only on success',()=>{
 const company=createCompany(), funds={gold:200};
 assert.equal(recruit(company,funds,'site_donaje','mounted',1),false);
 assert.equal(recruit(company,funds,'site_pune','mounted',2),true);
 assert.equal(company.mounted,2);
 assert.equal(recruitsAvailable(company,'site_pune','mounted'),0);
 assert.equal(recruit(company,funds,'site_pune','mounted',1),false);
 assert.equal(funds.gold,30);
});

test('mounted scouts improve pace and overloaded wood slows the company',()=>{
 const empty={grain:0,wood:0};
 assert.equal(marchBudget('steady',3,0,empty).total,4000);
 assert.ok(marchBudget('steady',4,1,empty).total>4000);
 assert.ok(marchBudget('steady',3,0,{grain:0,wood:70}).total<4000);
});

test('healthy parties stretch rations while recovery uses food faster',()=>{
 const company=createCompany(), stock={grain:0,wood:0,fish:2};
 for(let day=0;day<2;day++)assert.ok(feedCompany(company,3,stock));
 assert.equal(stock.fish,2);
 assert.ok(feedCompany(company,3,stock));
 assert.equal(stock.fish,1);
 company.health=70;
 assert.ok(feedCompany(company,3,stock));
 assert.equal(stock.fish,0);
 assert.equal(company.health,90);
 assert.ok(feedCompany(company,3,stock));
 assert.equal(feedCompany(company,3,stock),false);
 assert.equal(company.health,82);
 assert.ok(marchBudget('steady',3,0,stock,company.health).total<4000);
});
