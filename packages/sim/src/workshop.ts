import {purchasePrice,salePrice,stockTarget,units,type Economy} from './economy.ts';
export function createWorkshop(){
 return {owned:false,cash:0,grain:0,flour:0,progress:0,paused:false,autoBuy:true,autoSell:true,maxInput:8,minOutput:10,status:'Available for purchase',ledger:[] as {tick:number;amount:number;reason:string}[]};
}
export function workshopHour(w:ReturnType<typeof createWorkshop>,e:Economy,tick:number){
 if(!w.owned)return;
 const market=e.markets.site_pune;
 const log=(amount:number,reason:string)=>{w.ledger.unshift({tick,amount,reason});w.ledger=w.ledger.slice(0,40);};
 if(w.paused){w.status='Paused by owner';return;}
 if(w.autoSell&&w.flour>0&&units(market.stock,'flour')<stockTarget(market,'flour')*3){
   const cost=salePrice(market,'flour');
   if(cost>=w.minOutput&&market.money>=cost){
     market.money-=cost;market.stock.flour=units(market.stock,'flour')+1;w.cash+=cost;w.flour--;log(cost,'Flour sale');
   }
 }
 if(w.flour>=40){w.status='Output storage full';return;}
 if(w.grain<2&&w.autoBuy&&market.stock.grain>0){
   const cost=purchasePrice(market,'grain','site_pune',0);
   if(cost>w.maxInput){w.status='Input grain above price limit';return;}
   if(w.cash<cost){w.status='Insufficient working capital';return;}
   market.stock.grain--;market.money+=cost;w.grain++;w.cash-=cost;log(-cost,'Grain purchase');
 }
 if(w.grain<2){w.status='Waiting for 2 grain';return;}
 if(w.cash<2){w.status='Insufficient wages';return;}
 w.progress++;w.status='Milling · '+w.progress+'/6 hours';
 if(w.progress===6){w.grain-=2;w.flour+=2;w.cash-=2;w.progress=0;log(-2,'Mill wages');w.status='Batch completed';}
}
