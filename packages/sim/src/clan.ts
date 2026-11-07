import {troops} from './company.ts';
export const clanRoles=['Scout','Quartermaster','Surgeon'] as const;
export function createClan(){
 return {roles:{} as Record<string,string>,detachments:[] as {
   id:string;leader:string;foot:number;mounted:number;task:'patrol'|'return';home:string;gold?:number;food?:number;allowance?:number;ambition?:number;generosity?:number;aggression?:number;relations?:Record<string,number>;decision?:string;decisionTick?:number;wageDebt?:number
 }[],arrears:0,lastPayTick:0};
}
export function monthlyWages(foot:number,mounted:number,companions:number){
 return foot+mounted*2+companions*5;
}
export function returnTroops(funds:{gold:number},roster:{guards:number},company:{mounted:number},foot:number,mounted:number){
 if(!Number.isSafeInteger(foot)||!Number.isSafeInteger(mounted)||foot<0||mounted<0||
   foot>roster.guards-company.mounted||mounted>company.mounted||foot+mounted===0)return false;
 roster.guards-=foot+mounted;company.mounted-=mounted;
 funds.gold+=foot*troops.foot.cost+mounted*troops.mounted.cost;
 return true;
}
