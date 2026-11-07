import { metres, route, travelEffort } from '../../../packages/sim/src/navigation.ts';
import { createCompany, feedCompany, marchBudget, recruit, settlementServices, troops } from '../../../packages/sim/src/company.ts';
import { createCampaign, advance, command } from '../../../packages/sim/src/travel.ts';

import { createEconomy, restoreMarkets, goods, salePrice, trade, previewTrade, caravanEconomy, caravanMarketId, questAction, deliverGrain, economyHour, merchantVisit } from '../../../packages/sim/src/economy.ts';
import { startMotion, position, advanceMotion, anchor } from '../../../packages/sim/src/movement.ts';
import {changeRelation, raiderSite, resolveEncounter} from '../../../packages/sim/src/encounter.ts';
import { campaignHourMs } from './campaign-clock.js';
const world = createCampaign();
world.identity={name:'Traveller',house:'',color:'#b74338',symbol:'Sun'};
world.started=false;
world.relations={supplier:0};
world.encounter={guards:3,seed:1622,resolved:false,result:null};
world.events=[];
world.company=createCompany();
let eventId=0;
let approach=null;
const merchantHours=new Map();
world.villageSupply={grain:0,gold:0};
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
 merchantVisit(world.economy,world.merchant,caravan.node,destination=>{
   const key=caravan.node+':'+destination;
   if(!merchantHours.has(key)){
     const end=anchor(destination),path=end&&route(caravan.point,end);
     merchantHours.set(key,path?path.slice(1).reduce((effort,point,i)=>effort+travelEffort(path[i],point),0)/4000:Infinity);
   }
   return merchantHours.get(key);
 });
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
     if(next!==p.node&&order(p,anchor(next),next)&&p.id==='villagers'&&p.node==='site_saswad'&&next==='site_pune'){
       const source=world.economy.markets.site_saswad;
       const loaded=Math.min(12-world.villageSupply.grain,Math.max(0,source.stock.grain-20));
       source.stock.grain-=loaded;world.villageSupply.grain+=loaded;
     }
   }
 }
}
function hourly(){
 for(const p of world.parties){
   p.trail=null;
   if(!p.motion || p.id==='player'&&world.waitUntil!==null)continue;
   const budget=p.id==='player'?marchBudget('steady',world.encounter.guards,world.company.mounted,world.economy.inventory,world.company.health).total:4000;
   const {arrived,trace}=advanceMotion(p.motion,budget);
   p.trail=trace;
   p.point=position(p.motion);
   if(arrived){
     const from=p.node;
     p.node=p.motion.destination??'field';p.motion=null;
     if(p.id==='villagers'&&from==='site_saswad'&&p.node==='site_pune'){
       const market=world.economy.markets[p.node];
       let delivered=0;
       while(world.villageSupply.grain>0&&market.stock.grain<market.target.grain){
         const coin=salePrice(market,'grain');
         if(market.money<coin)break;
         market.money-=coin;world.villageSupply.gold+=coin;world.villageSupply.grain--;
         delivered+=deliverGrain(world.economy,p.node,1);
       }
       if(delivered)event('The village train delivered '+delivered+' grain to Pune.');
     }
     event(p.name+' arrived.');
     if(p.id==='player')world.notice='Destination reached.';
   }
 }
 advance(world);
 const previous=world.economy.quest?.status;
 economyHour(world.economy,world.tick);
 if(world.tick%24===0&&!feedCompany(world.company,world.encounter.guards,world.economy.inventory)){
   event('Your company ran short of food. Health fell to '+world.company.health+'%.');
   if(world.company.health===0&&world.encounter.guards>0){
     world.encounter.guards--;
     world.company.mounted=Math.min(world.company.mounted,world.encounter.guards);
     event('A guard died from starvation.');
   }
 }
 updateApproach();
 if(previous==='active'&&world.economy.quest?.status==='failed'){
   world.relations[supplier]=changeRelation(world.relations[supplier],-5);
   event('The Saswad supply agreement expired. Supplier relation −5.');
 }
 traffic();
}
function updateApproach(){
 if(!approach)return;
 const player=world.parties[0], target=world.parties.find(p=>p.id===approach);
 if(metres(player.point,target.point)<=4000){
   if(player.motion)player.node='field';
   player.motion=null;world.waitUntil=null;world.speed=0;
   world.partyMeeting={party:approach,tick:world.tick};approach=null;
   return;
 }
 if(!player.motion||metres(player.motion.points.at(-1),target.point)>4000){
   if(!order(player,target.point))approach=null;
 }
}
let timer, startedAt, remaining = campaignHourMs;
function schedule(previousSpeed) {
  if (world.speed === previousSpeed) return;
  clearTimeout(timer);
  if (previousSpeed) remaining = Math.max(0, remaining - (performance.now() - startedAt) * previousSpeed);
  if (world.speed) nextHour();
}
function nextHour() {
  startedAt = performance.now();
  timer = setTimeout(() => {
    hourly();
    postMessage(world);
    remaining = campaignHourMs;
    if (world.speed) nextHour();
  }, remaining / world.speed);
}
self.onmessage = ({data}) => {
  const previousSpeed = world.speed;
  const player=world.parties[0];
  if(data.type==='restore'&&!world.started) {
    Object.assign(world,data.world,{speed:0,notice:'Campaign restored. Press Play to continue.'});
    world.company??=createCompany();
    world.company.health??=100;
    restoreMarkets(world.economy);
    world.partyMeeting=null;
    eventId=world.events[0]?.id??0;
  } else if(data.type==='resolve-encounter' && !player.motion && player.node===raiderSite && !world.encounter.resolved){
    const result=resolveEncounter(world.encounter.guards,player.point,world.encounter.seed);
    world.encounter={guards:world.encounter.guards-result.guardsLost,seed:result.seed,resolved:true,result};
    world.company.mounted=Math.min(world.company.mounted,world.encounter.guards);
    if(result.outcome==='Victory')world.company.prisoners++;
    world.economy.gold+=result.coin;
    event(result.outcome+' near Kondhana. '+result.guardsLost+(result.guardsLost===1?' guard lost.':' guards lost.'));
  } else if(data.type==='start'&&!world.started) {
    world.identity=data.identity;player.name=data.identity.name+' of '+data.identity.house;
    world.started=true;world.economy.inventory.grain=6;world.speed=1;traffic();
  } else if(data.type==='approach-party'&&world.started&&world.parties.some(p=>p.id===data.party&&p.id!=='player')){
    approach=data.party;
    world.partyMeeting=null;world.waitUntil=null;
    world.speed=world.speed||1;
    world.notice='Approaching party.';
    updateApproach();
  } else if(data.type==='travel'||data.type==='move') {
    approach=null;world.partyMeeting=null;
    const to=data.type==='travel'?anchor(data.to):data.point;
    if(to&&order(player,to,data.type==='travel'?data.to:null)){
      world.waitUntil=null;world.notice='Travelling.';world.speed=world.speed||1;
    }
  } else if(data.type==='recruit' && world.started && !player.motion) {
    if(recruit(world.company,world.economy,player.node,data.troop,data.count)){
      world.encounter.guards+=data.count;
      event('Recruited '+data.count+' · '+troops[data.troop].name);
    }
  } else if(data.type==='dismiss' && world.started) {
    const mounted=data.troop==='mounted';
    if((mounted && world.company.mounted>0) || (data.troop==='foot' && world.encounter.guards>world.company.mounted)){
      world.encounter.guards--;
      if(mounted)world.company.mounted--;
    }
  } else if(data.type==='hire-companion' && world.started && !player.motion) {
    const contact=settlementServices[player.node]?.meetingHouse;
    if(contact && !world.company.companions.includes(player.node) && world.economy.gold>=contact.fee){
      world.economy.gold-=contact.fee;
      world.company.companions.push(player.node);
      event(contact.name+' joined your company.');
    }
  } else if(data.type==='ransom' && world.started && !player.motion) {
    if(settlementServices[player.node]?.meetingHouse && world.company.prisoners>0){
      world.company.prisoners--;
      world.economy.gold+=40;
      event('Released a prisoner for 40 coin.');
    }
  } else if(data.type==='confirm-trade' && world.started) {
    if(world.tradeReply?.id===data.id){postMessage(world);return;}
    const caravan=world.parties.find(p=>p.id===caravanMarketId);
    const roadside=data.site===caravanMarketId;
    const permitted=roadside?metres(player.point,caravan.point)<=4000:!player.motion && player.node===data.site;
    const basis=roadside?caravanEconomy(world.economy,world.merchant):world.economy;
    const draft=permitted && Array.isArray(data.lines) && data.lines.length>0 && data.lines.length<=goods.length &&
      previewTrade(basis,data.site,data.lines,world.relations.supplier);
    const accepted=!!draft && draft.gold-world.economy.gold===data.change;
    if(accepted){
      if(roadside){
        const market=draft.markets[caravanMarketId];
        world.merchant.gold=market.money;
        world.merchant.cargo=market.stock;
        world.economy.gold=draft.gold;
        world.economy.inventory=draft.inventory;
      } else Object.assign(world.economy,draft);
      world.economy.notice='Trade completed.';
    } else world.economy.notice='Market conditions or position changed. Review the quote and try again.';
    world.tradeReply={id:data.id,accepted};
  } else if(data.type==='confirm-dismiss' && world.started) {
    const {foot,mounted}=data.counts;
    if(Number.isSafeInteger(foot) && Number.isSafeInteger(mounted) && foot>=0 && mounted>=0 &&
       mounted<=world.company.mounted && foot<=world.encounter.guards-world.company.mounted){
      world.company.mounted-=mounted;
      world.encounter.guards-=foot+mounted;
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
  schedule(previousSpeed);
};
