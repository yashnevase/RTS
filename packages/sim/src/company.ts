export const troops = {
  foot: { name: 'Foot guard', cost: 35 },
  mounted: { name: 'Mounted scout', cost: 85 }
} as const;

type Troop = keyof typeof troops;
export const settlementServices: Partial<Record<string, {
  recruits: Partial<Record<Troop, number>>;
  meetingHouse?: { name: string; role: string; fee: number };
}>> = {
  site_donaje: { recruits: { foot: 2 } },
  site_saswad: { recruits: { foot: 4 } },
  site_bhor: { recruits: { foot: 2 } },
  site_pune: { recruits: { foot: 3, mounted: 2 }, meetingHouse: { name: 'Keso', role: 'Road guide', fee: 120 } },
  site_ahmadnagar: { recruits: { foot: 2, mounted: 3 }, meetingHouse: { name: 'Yusuf', role: 'Caravan guard', fee: 140 } }
};

export function createCompany() {
  return { mounted: 0, health:100, rationProgress:0, starvingDays:0, prisoners: 0, companions: [] as string[], recruits: {} as Record<string, number> };
}
type Company = ReturnType<typeof createCompany>;

export function recruitsAvailable(company: Company, site: string, troop: Troop) {
  return (settlementServices[site]?.recruits[troop] ?? 0) - (company.recruits[site + ':' + troop] ?? 0);
}

export function recruit(company: Company, funds: {gold:number}, site: string, troop: Troop, count: number) {
  if (!Object.hasOwn(troops, troop) || !Number.isSafeInteger(count) || count<1 ||
      count>recruitsAvailable(company,site,troop) || funds.gold<count*troops[troop].cost) return false;
  const key=site+':'+troop;
  funds.gold-=count*troops[troop].cost;
  company.recruits[key]=(company.recruits[key]??0)+count;
  if (troop==='mounted') company.mounted+=count;
  return true;
}

export function marchBudget(pace:string, guards:number, mounted:number, inventory:{grain:number;wood:number;rice?:number;fish?:number},health=100) {
  const base=pace==='swift'?5000:4000;
  const cavalry=Math.floor(900*mounted/Math.max(1,guards+1));
  const load=inventory.grain+inventory.wood*2+(inventory.rice??0)+(inventory.fish??0);
  const capacity=30+guards*7+mounted*6;
  const penalty=Math.min(1500,Math.max(0,load-capacity)*20);
  const fatigue=Math.floor((100-health)*15);
  return {base,cavalry,load,capacity,penalty,fatigue,total:base+cavalry-penalty-fatigue};
}

const personDaysPerRation=12;

export function foodPerDay(guards:number,companions:number) {
 return (guards+companions+1)/personDaysPerRation;
}

export function feedCompany(company:Company,guards:number,stock:{grain:number;rice?:number;fish?:number}) {
 const recovery=company.health<100;
 company.rationProgress=(company.rationProgress??0)+guards+company.companions.length+1;
 const upkeep=Math.floor(company.rationProgress/personDaysPerRation);
 company.rationProgress%=personDaysPerRation;
 let needed=upkeep;
 const food=['grain','rice','fish'] as const;
 const available=food.reduce((sum,good)=>sum+(stock[good]??0),0);
 const recoveryMeal=recovery&&available>upkeep;
 if(recoveryMeal)needed++;
 for(const good of food){
   const taken=Math.min(stock[good]??0,needed);
   if(taken)stock[good]=(stock[good]??0)-taken;
   needed-=taken;
 }
 if(needed)company.health=Math.max(0,company.health-8);
 else if(recoveryMeal)company.health=Math.min(100,company.health+20);
 company.starvingDays=company.health===0&&available===0?(company.starvingDays??0)+1:0;
 return needed===0;
}
