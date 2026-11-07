import { createCampaign, advance, command, itinerary } from '../../../packages/sim/src/travel.ts';

import { createEconomy, trade, questAction, economyHour, merchantVisit } from '../../../packages/sim/src/economy.ts';
import { startMotion, position, move, anchor } from '../../../packages/sim/src/movement.ts';
const world = createCampaign();
world.identity={name:'Traveller',house:'',color:'#b74338',symbol:'Sun'};
world.started=false;
for(const p of world.parties){p.stops=[];p.point=anchor(p.node);p.motion=null;}
world.economy=createEconomy();
world.merchant={gold:1000,cargo:{grain:0,wood:0},destination:null,trades:0};
const caravan=world.parties.find(p=>p.id==='caravan');
caravan.stops=[];
function order(p,to,destination=null) {
 const motion=startMotion(p.point,to,destination);
 if(!motion){world.notice='That ground cannot be reached. Choose open terrain or a crossing.';return;}
 p.motion=motion;p.path=[];return true;
}
function commerce() {
 if(caravan.motion)return;
 merchantVisit(world.economy,world.merchant,caravan.node);
 if(world.merchant.destination) order(caravan,anchor(world.merchant.destination),world.merchant.destination);
}
function traffic() {
 for(const p of world.parties.slice(1)){
   if(p.id==='caravan'){commerce();continue;}
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
   if(!p.motion || p.id==='player'&&world.waitUntil!==null)continue;
   const done=move(p.motion,p.pace==='swift'?5000:4000);
   p.point=position(p.motion);
   if(done){p.node=p.motion.destination??'field';p.motion=null;if(p.id==='player')world.notice='Destination reached.';}
 }
 advance(world);
 economyHour(world.economy,world.tick);
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
  if(data.type==='start') {
    world.identity=data.identity;player.name=data.identity.name+' of '+data.identity.house;
    world.started=true;world.speed=1;traffic();
  } else if(data.type==='travel'||data.type==='move') {
    const to=data.type==='travel'?anchor(data.to):data.point;
    if(to&&order(player,to,data.type==='travel'?data.to:null)){
      world.waitUntil=null;world.notice='Travelling.';world.speed=world.speed||1;
    }
  } else if(data.type==='trade') {
    if(!player.motion) trade(world.economy,player.node,data.good,data.buy);
  } else if(data.type==='quest') {
    if(!player.motion && player.node==='site_saswad') questAction(world.economy,world.tick);
  } else if(data.type==='wait'){
    world.waitUntil=world.tick+data.hours;world.speed=world.speed||1;world.notice='Waiting.';
  } else if(data.type==='step') {world.speed=1;hourly();world.speed=0;}
  else if (data.type !== 'inspect') command(world, data);
  postMessage(world);
  schedule();
};
