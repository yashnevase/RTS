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
  return { mounted: 0, health:100, prisoners: 0, companions: [] as string[], recruits: {} as Record<string, number> };
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

export function foodPerDay(guards:number,companions:number) {
 return Math.max(1,Math.ceil((guards+companions+1)/4));
}

export function feedCompany(company:Company,guards:number,stock:{grain:number;rice?:number;fish?:number}) {
 let needed=foodPerDay(guards,company.companions.length);
 for(const good of ['grain','rice','fish'] as const){
   const taken=Math.min(stock[good]??0,needed);
   if(taken)stock[good]=(stock[good]??0)-taken;
   needed-=taken;
 }
 company.health=needed?Math.max(0,company.health-20):Math.min(100,company.health+15);
 return needed===0;
}
