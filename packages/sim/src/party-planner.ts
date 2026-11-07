export interface PartyNeeds {
 food:number;gold:number;foot:number;mounted:number;ambition:number;aggression:number;
}
export interface Destination {id:string;hours:number;foodPrice:number;stock:number;relation:number}
export function choosePartyDestination(needs:PartyNeeds,current:string,home:string,choices:Destination[]){
 const daily=Math.max(1,Math.ceil((needs.foot+needs.mounted+1)/12));
 const hungry=needs.food<daily*4;
 const affordable=choices.filter(place=>Number.isFinite(place.hours)&&place.stock>0&&place.foodPrice<=needs.gold);
 if(hungry&&affordable.length){
   const ranked=affordable.map(place=>({...place,score:1000-place.hours*10-place.foodPrice*3+place.relation}));
   ranked.sort((a,b)=>b.score-a.score||a.id.localeCompare(b.id));
   return {destination:ranked[0].id,reason:'Resupply · low food, affordable market, travel time and local relations'};
 }
 const patrol=choices.filter(place=>place.id!==current&&Number.isFinite(place.hours));
 patrol.sort((a,b)=>(b.id===home?30:needs.ambition/5)+b.relation-b.hours-(a.id===home?30:needs.ambition/5)-a.relation+a.hours||a.id.localeCompare(b.id));
 return {destination:patrol[0]?.id??current,reason:hungry?'Food unaffordable · waiting for funds':'Patrol · home, ambition, relations and distance'};
}
