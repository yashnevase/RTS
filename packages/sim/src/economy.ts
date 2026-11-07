import {marketProfiles,production} from './market-profiles.ts';
import {monsoon} from './travel.ts';
export const goods = ['grain','wood','rice','fish'] as const;
export type Good = typeof goods[number];
type Goods = Partial<Record<Good,number>> & {grain:number;wood:number};
export interface Market { stock: Goods; target: Goods; money:number; referenceStock?:Goods }
export const units=(stock:Goods,good:Good)=>stock[good]??0;
export const stockTarget=(market:Market,good:Good)=>market.target[good]??30;
const basePrices={grain:6,wood:8,rice:10,fish:12};
export interface Economy {
  gold:number; inventory:Goods; markets:Record<string,Market>;
  quest: null | {due:number; status:'active'|'completed'|'failed'}; notice:string;
}
export function restoreMarkets(e:Economy) {
 for(const [id,profile] of Object.entries(marketProfiles)){
   const stock={grain:profile.grain[0],wood:profile.wood[0],rice:profile.rice[0],fish:profile.fish[0]};
   const target={grain:profile.grain[1],wood:profile.wood[1],rice:profile.rice[1],fish:profile.fish[1]};
   const market=e.markets[id]??={stock,target,money:20000};
   market.stock={...stock,...market.stock};
   market.target={...target,...market.target};
   market.referenceStock??={...market.stock};
 }
 return e;
}
export function createEconomy():Economy {
 return restoreMarkets({gold:600,inventory:{grain:0,wood:0},quest:null,notice:'',markets:{}});
}
export function price(market:Market,good:Good) {
 const base=basePrices[good], target=stockTarget(market,good);
 const live=units(market.stock,good);
 const reference=market.referenceStock?units(market.referenceStock,good):live;
 const tolerance=Math.ceil(target/5);
 const effective=Math.max(live-tolerance,Math.min(live+tolerance,reference));
 return Math.max(Math.ceil(base/2),Math.min(base*2,Math.round(base*2*target/(target+effective))));
}
export function purchasePrice(market:Market,good:Good,node:string,supplierRelation:number) {
  const base=price(market,good);
  return node==='site_saswad'&&supplierRelation>=15 ? Math.max(1,Math.floor(base*.9)) : base;
}
export function salePrice(market:Market,good:Good,node='',relation=0) {
 return purchasePrice({...market,stock:{...market.stock,[good]:units(market.stock,good)+1}},good,node,relation);
}

export interface TradeLine { good: Good; buy: boolean; quantity: number }

export function previewTrade(e:Economy,node:string,lines:TradeLine[],relation:number) {
 const market=e.markets[node];
 if(!market)return null;
 const draft={...e,inventory:{...e.inventory},markets:{...e.markets,[node]:{...market,stock:{...market.stock}}}};
 for(const line of [...lines].sort((a,b)=>Number(a.buy)-Number(b.buy))){
   if(!trade(draft,node,line.good,line.buy,line.quantity,relation))return null;
 }
 return draft;
}

export function profitableDestinations(e:Economy,source:string,good:Good,quantity:number,relation:number) {
 const bought=previewTrade(e,source,[{good,buy:true,quantity}],relation);
 if(!bought)return [];
 return Object.keys(e.markets).filter(id=>id!==source&&id!==caravanMarketId).flatMap(id=>{
   const sold=previewTrade(bought,id,[{good,buy:false,quantity}],relation);
   const profit=sold?sold.gold-e.gold:0;
   return profit>0?[{id,profit}]:[];
 }).sort((a,b)=>b.profit-a.profit).slice(0,3);
}

export function trade(e:Economy,node:string,good:Good,buy:boolean,quantity=1,supplierRelation=0) {
 if(!goods.includes(good)||!Number.isSafeInteger(quantity)||quantity<1||quantity>100){e.notice='Choose a quantity between 1 and 100.';return;}
 const market=e.markets[node];if(!market){e.notice='No market is available here.';return;}
 const m={...market,stock:{...market.stock,[good]:units(market.stock,good)}},inventory={...e.inventory,[good]:units(e.inventory,good)};
 let gold=e.gold,total=0;
 for(let i=0;i<quantity;i++){
   const cost=buy ? purchasePrice(m,good,node,supplierRelation) :
     salePrice(m,good,node,supplierRelation);
   if(buy && m.stock[good]!>0 && gold>=cost){m.stock[good]!--;inventory[good]!++;gold-=cost;m.money+=cost;}
   else if(!buy && inventory[good]!>0 && m.money>=cost && m.stock[good]!<stockTarget(m,good)*3){m.stock[good]!++;inventory[good]!--;gold+=cost;m.money-=cost;}
   else {e.notice='Insufficient stock or funds for this quantity.';return;}
   total+=cost;
 }
 Object.assign(market,m);e.inventory=inventory;e.gold=gold;
 e.notice=(buy?'Bought ':'Sold ')+quantity+' '+good+' for '+total+' coin.';
 return true;
}
export function questAction(e:Economy,tick:number) {
  if(!e.quest) { e.quest={due:tick+96,status:'active'};e.notice='Bring 20 grain and 50 wood here within four days. Reward 900.'; }
  else if(e.quest.status==='active' && tick<=e.quest.due && e.inventory.grain>=20 && e.inventory.wood>=50) {
    e.inventory.grain-=20;e.inventory.wood-=50;e.gold+=900;e.quest.status='completed';e.notice='Supplies delivered. You earned 900.';
  } else e.notice='The requested supplies are not ready.';
}
export function deliverGrain(e:Economy,node:string,amount:number) {
 const market=e.markets[node];
 if(!market)return 0;
 const delivered=Math.min(amount,Math.max(0,market.target.grain-market.stock.grain));
 market.stock.grain+=delivered;
 return delivered;
}

export function economyHour(e:Economy,tick:number) {
  if(tick>0&&tick%24===0)for(const market of Object.values(e.markets)){
    for(const good of ['grain','rice','fish'] as const)market.stock[good]=Math.max(0,units(market.stock,good)-Math.ceil(stockTarget(market,good)/20));
    if(tick%168===0)market.referenceStock={...market.stock};
  }
  if(tick>0&&tick%24===0)for(const profile of production){
    const market=e.markets[profile.market];
    if(!market)continue;
    const stock=units(market.stock,profile.good);
    if(stock<stockTarget(market,profile.good)*2)market.stock[profile.good]=stock+(monsoon(tick)?profile.monsoon:profile.daily);
  }
  if(e.quest?.status==='active' && tick>e.quest.due) e.quest.status='failed';
}

export interface Merchant {gold:number; cargo:Goods; destination:string|null; trades:number}
export function merchantVisit(e:Economy,merchant:Merchant,node:string,travelHours:(to:string)=>number=()=>1) {
  const market=e.markets[node];if(!market)return;
  for(const good of goods) {
    while(units(merchant.cargo,good)>0 && units(market.stock,good)<stockTarget(market,good)*3 && market.money>=salePrice(market,good)) {
      const cost=salePrice(market,good);market.money-=cost;merchant.gold+=cost;
      merchant.cargo[good]=units(merchant.cargo,good)-1;market.stock[good]=units(market.stock,good)+1;merchant.trades++;
    }
  }
  let best: {good:Good; destination:string; count:number; score:number}|null=null;
  for(const [destination,other] of Object.entries(e.markets)) {
    if(destination===node)continue;
    const hours=travelHours(destination);
    if(!Number.isFinite(hours))continue;
    for(const good of goods) {
      const limit=Math.min(20,units(market.stock,good),stockTarget(other,good)*3-units(other.stock,good));
      let cost=0,revenue=0;
      const origin={...market,stock:{...market.stock}};
      const target={...other,stock:{...other.stock}};
      for(let count=1;count<=limit;count++){
        cost+=price(origin,good);
        revenue+=salePrice(target,good);
        if(cost>merchant.gold||revenue>other.money)break;
        origin.stock[good]=units(origin.stock,good)-1;
        target.stock[good]=units(target.stock,good)+1;
        const score=(revenue-cost)/Math.max(1,hours);
        if(score>0&&(!best||score>best.score))best={good,destination,count,score};
      }
    }
  }
  if(!best){merchant.destination=null;return;}
  for(let i=0;i<best.count;i++){
    const cost=price(market,best.good);
    market.stock[best.good]=units(market.stock,best.good)-1;market.money+=cost;
    merchant.gold-=cost;merchant.cargo[best.good]=units(merchant.cargo,best.good)+1;merchant.trades++;
  }
  merchant.destination=best.destination;
}

export const caravanMarketId='caravan';

export function caravanEconomy(e:Economy,merchant:Merchant):Economy {
 return {...e,markets:{...e.markets,[caravanMarketId]:{
   stock:{...merchant.cargo},target:{grain:15,wood:15},money:merchant.gold
 }}};
}
