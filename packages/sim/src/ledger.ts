export interface LedgerEntry {tick:number;change:number;reason:string}
export function recordBalance(entries:LedgerEntry[],tick:number,before:number,after:number,reason:string){
 const change=after-before;
 if(change)entries.unshift({tick,change,reason});
 return entries.slice(0,60);
}
