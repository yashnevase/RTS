import { createCampaign, advance, command, itinerary } from '../../../packages/sim/src/travel.ts';

import { createEconomy, trade, questAction, economyHour, merchantVisit } from '../../../packages/sim/src/economy.ts';
const world = createCampaign();
world.economy=createEconomy();
world.merchant={gold:1000,cargo:{grain:0,wood:0},destination:null,trades:0};
const caravan=world.parties.find(p=>p.id==='caravan');
caravan.stops=[];
function commerce() {
  if(caravan.path.length)return;
  merchantVisit(world.economy,world.merchant,caravan.node);
  if(world.merchant.destination) caravan.path=itinerary(caravan.node,world.merchant.destination,caravan.pace,world.tick)??[];
}
commerce();
let timer;
function schedule() {
  clearInterval(timer);
  if (world.speed) timer = setInterval(() => {
    advance(world);
    economyHour(world.economy,world.tick);
    commerce();
    postMessage(world);
    if (!world.speed) clearInterval(timer);
  }, 900 / world.speed);
}
self.onmessage = ({data}) => {
  const player=world.parties[0];
  if(data.type==='trade') {
    if(!player.path.length) trade(world.economy,player.node,data.good,data.buy);
  } else if(data.type==='quest') {
    if(!player.path.length && player.node==='site_saswad') questAction(world.economy,world.tick);
  } else if (data.type !== 'inspect') command(world, data);
  postMessage(world);
  schedule();
};
