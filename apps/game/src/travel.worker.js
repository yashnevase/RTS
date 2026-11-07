import { createCampaign, advance, command } from '../../../packages/sim/src/travel.ts';

import { createEconomy, trade, questAction, economyHour, merchantVisit } from '../../../packages/sim/src/economy.ts';
import { startMotion, position, advanceMotion, anchor } from '../../../packages/sim/src/movement.ts';
import {changeRelation, raiderSite, resolveEncounter} from '../../../packages/sim/src/encounter.ts';
const world = createCampaign();
world.identity={name:'Traveller',house:'',color:'#b74338',symbol:'Sun'};
world.started=false;
world.relations={supplier:0};
world.encounter={guards:3,seed:1622,resolved:false,result:null};
world.events=[];
let eventId=0;
const supplier='supplier';
function event(text) {
 world.events.unshift({id:++eventId,tick:world.tick,text});
 world.events=world.events.slice(0,30);
}
for(const p of world.parties){p.stops=[];p.point=anchor(p.node);p.motion=null;}
world.economy=createEconomy();
world.merchant={gold:1000,cargo:{grain:0,wood:0},destination:null,trades:0};

function order(p,to,destination=null) {
 const motion=startMotion(p.point,to,destination);
 if(!motion){world.notice='That ground cannot be reached. Choose open terrain or a crossing.';return;}
 p.motion=motion;p.path=[];return true;
}
function commerce(caravan) {
 if(caravan.motion)return;
 const before=world.merchant.trades;
 merchantVisit(world.economy,world.merchant,caravan.node);
 if(world.merchant.trades>before)event('A caravan traded '+(world.merchant.trades-before)+' units at '+caravan.node.replace('site_','').replaceAll('_',' ')+'.');
 if(world.merchant.destination) order(caravan,anchor(world.merchant.destination),world.merchant.destination);
}
function traffic() {
 for(const p of world.parties.slice(1)){
   if(p.id==='caravan'){commerce(p);continue;}
   if(!p.motion){
     p.stream=(Math.imul(1664525,p.stream)+1013904223)>>>0;
     const choices=p.id==='patrol'?['site_pune','fort_kondhana','site_donaje']:['site_pune','site_saswad','fort_purandar'];
     const next=choices[p.stream%choices.length];
     if(next!==p.node)order(p,anchor(next),next);
   }
 }
}
function hourly(){
 for(const p of world.parties){
   p.trail=null;
   if(!p.motion || p.id==='player'&&world.waitUntil!==null)continue;
   const {arrived,trace}=advanceMotion(p.motion,p.pace==='swift'?5000:4000);
   p.trail=trace;
   p.point=position(p.motion);
   if(arrived){event(p.name+' arrived.');p.node=p.motion.destination??'field';p.motion=null;if(p.id==='player')world.notice='Destination reached.';}
 }
 advance(world);
 const previous=world.economy.quest?.status;
 economyHour(world.economy,world.tick);
 if(previous==='active'&&world.economy.quest?.status==='failed'){
   world.relations[supplier]=changeRelation(world.relations[supplier],-5);
   event('The Saswad supply agreement expired. Supplier relation −5.');
 }
 traffic();
}
let timer;
function schedule() {
  clearInterval(timer);
  if (world.speed) timer = setInterval(() => {
    hourly();
    postMessage(world);
    if (!world.speed) clearInterval(timer);
  }, 900 / world.speed);
}
self.onmessage = ({data}) => {
  const player=world.parties[0];
  if(data.type==='restore'&&!world.started) {
    Object.assign(world,data.world,{speed:0,notice:'Campaign restored. Press Play to continue.'});
    eventId=world.events[0]?.id??0;
  } else if(data.type==='resolve-encounter' && !player.motion && player.node===raiderSite && !world.encounter.resolved){
    const result=resolveEncounter(world.encounter.guards,player.point,world.encounter.seed);
    world.encounter={guards:world.encounter.guards-result.guardsLost,seed:result.seed,resolved:true,result};
    world.economy.gold+=result.coin;
    event(result.outcome+' near Kondhana. '+result.guardsLost+(result.guardsLost===1?' guard lost.':' guards lost.'));
  } else if(data.type==='start'&&!world.started) {
    world.identity=data.identity;player.name=data.identity.name+' of '+data.identity.house;
    world.started=true;world.speed=1;traffic();
  } else if(data.type==='travel'||data.type==='move') {
    const to=data.type==='travel'?anchor(data.to):data.point;
    if(to&&order(player,to,data.type==='travel'?data.to:null)){
      world.waitUntil=null;world.notice='Travelling.';world.speed=world.speed||1;
    }
  } else if(data.type==='trade') {
    if(!player.motion) {trade(world.economy,player.node,data.good,data.buy,data.quantity??1,world.relations.supplier);event(world.economy.notice);}
  } else if(data.type==='quest') {
    if(!player.motion && player.node==='site_saswad') {
      const before=world.economy.quest?.status;
      questAction(world.economy,world.tick);
      if(before!=='completed' && world.economy.quest?.status==='completed'){
        world.relations[supplier]=changeRelation(world.relations[supplier],15);
        event('The Saswad supplier received your delivery. Supplier relation +15.');
      } else event(world.economy.notice);
    }
  } else if(data.type==='relocate'){
    const point=anchor(data.to);
    if(point){
      Object.assign(player,{node:data.to,point,motion:null,trail:null,path:[],metres:0});
      world.modified=true;world.waitUntil=null;world.speed=0;world.notice='Developer relocation.';
    }
  } else if(data.type==='wait'){
    world.waitUntil=world.tick+data.hours;world.speed=world.speed||1;world.notice='Waiting.';
  } else if(data.type==='step') {world.speed=1;hourly();world.speed=0;}
  else if (data.type !== 'inspect') command(world, data);
  postMessage(world);
  schedule();
};
