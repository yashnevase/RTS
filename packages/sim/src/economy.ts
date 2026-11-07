export const goods = ['grain','wood'] as const;
type Good = typeof goods[number];
export interface Market { stock: Record<Good,number>; target: Record<Good,number>; money:number }
export interface Economy {
  gold:number; inventory:Record<Good,number>; markets:Record<string,Market>;
  quest: null | {due:number; status:'active'|'completed'|'failed'}; notice:string;
}
export function createEconomy():Economy {
  return {gold:600,inventory:{grain:0,wood:0},quest:null,notice:'',
    markets:{
      site_pune:{stock:{grain:150,wood:30},target:{grain:100,wood:80},money:20000},
      site_saswad:{stock:{grain:20,wood:100},target:{grain:100,wood:60},money:20000},
      site_ahmadnagar:{stock:{grain:40,wood:150},target:{grain:120,wood:80},money:20000}
    }};
}
export function price(market:Market,good:Good) {
  return Math.max(2,Math.min(30,Math.round((good==='grain'?6:8)*(market.target[good]+1)/(market.stock[good]+1))));
}
export function trade(e:Economy,node:string,good:Good,buy:boolean) {
  const m=e.markets[node];if(!m)return;
  const cost=price(m,good);
  if(buy && m.stock[good]>0 && e.gold>=cost) {
    m.stock[good]--;e.inventory[good]++;e.gold-=cost;m.money+=cost;
  } else if(!buy && e.inventory[good]>0 && m.money>=cost) {
    m.stock[good]++;e.inventory[good]--;e.gold+=cost;m.money-=cost;
  } else e.notice='Insufficient stock or funds.';
}
export function questAction(e:Economy,tick:number) {
  if(!e.quest) { e.quest={due:tick+96,status:'active'};e.notice='Bring 20 grain and 50 wood here within four days. Reward 900.'; }
  else if(e.quest.status==='active' && tick<=e.quest.due && e.inventory.grain>=20 && e.inventory.wood>=50) {
    e.inventory.grain-=20;e.inventory.wood-=50;e.gold+=900;e.quest.status='completed';e.notice='Supplies delivered. You earned 900.';
  } else e.notice='The requested supplies are not ready.';
}
export function economyHour(e:Economy,tick:number) {
  if(e.quest?.status==='active' && tick>e.quest.due) e.quest.status='failed';
}

export interface Merchant {gold:number; cargo:Record<Good,number>; destination:string|null; trades:number}
export function merchantVisit(e:Economy,merchant:Merchant,node:string) {
  const market=e.markets[node];if(!market)return;
  for(const good of goods) {
    while(merchant.cargo[good]>0 && market.money>=price(market,good)) {
      const cost=price(market,good);market.money-=cost;merchant.gold+=cost;
      merchant.cargo[good]--;market.stock[good]++;merchant.trades++;
    }
  }
  let best: {good:Good; destination:string; profit:number}|null=null;
  for(const [destination,other] of Object.entries(e.markets)) {
    if(destination===node)continue;
    for(const good of goods) {
      const profit=price(other,good)-price(market,good);
      if(profit>1 && (!best||profit>best.profit))best={good,destination,profit};
    }
  }
  if(!best){merchant.destination=null;return;}
  const other=e.markets[best.destination];
  let count=0;
  while(count<20 && market.stock[best.good]>0 && merchant.gold>=price(market,best.good) &&
    price(other,best.good)>price(market,best.good)+1) {
    const cost=price(market,best.good);market.stock[best.good]--;market.money+=cost;
    merchant.gold-=cost;merchant.cargo[best.good]++;merchant.trades++;count++;
  }
  merchant.destination=count?best.destination:null;
}
