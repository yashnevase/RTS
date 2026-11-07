import profile from './travel-profile.json' with { type: 'json' };

export type Pace = keyof typeof profile.pacePercent;
export interface Party {
  id: string; name: string; node: string; path: string[]; metres: number;
  pace: Pace; stream: number; stops: string[];
}
export interface TravelState {
  modified: boolean; tick: number; speed: 0 | 1 | 2 | 4; waitUntil: number | null; parties: Party[]; notice: string;
}
export type Command = {type:'travel'; to:string} | {type:'speed'; value:TravelState['speed']} |
  {type:'pace'; value:Pace} | {type:'wait'; hours:number} | {type:'step'} | {type:'relocate'; to:string};

export const edges = profile.edges;
export function monsoon(tick: number) {
  const day = Math.floor(tick / 24) % 365;
  return day >= 151 && day < 273;
}
function speed(edge: typeof edges[number], pace: Pace, tick: number) {
  const rates: Record<string, number> = profile.metresPerHour;
  return Math.floor(rates[edge.terrain] * profile.pacePercent[pace] *
    (monsoon(tick) ? profile.monsoonPercent : 100) / 10000);
}
// Tick zero starts at dawn. Camps rest overnight on the preview timetable.
export function clockHour(tick:number) { return (tick+6)%24; }
function marching(tick:number) { const hour=clockHour(tick); return hour>=6 && hour<18; }
function connection(a:string, b:string) {
  const edge = edges.find(e => (e.a===a && e.b===b) || (e.a===b && e.b===a));
  if (!edge) throw new Error('Missing travel edge');
  return edge;
}
// Least travel hours. Iterate stable authored edge order for equal cost routes.
export function itinerary(start:string, end:string, pace:Pace, tick:number): string[] | null {
  const queue = [{node:start, cost:0, path:[] as string[]}];
  const visited = new Set<string>();
  while (queue.length) {
    queue.sort((a,b) => a.cost-b.cost);
    const current = queue.shift()!;
    if (current.node===end) return current.path;
    if (visited.has(current.node)) continue;
    visited.add(current.node);
    for (const edge of edges) {
      const next = edge.a===current.node ? edge.b : edge.b===current.node ? edge.a : null;
      if (next && !visited.has(next)) queue.push({node:next,
        cost:current.cost+Math.ceil(edge.metres/speed(edge,pace,tick)),path:[...current.path,next]});
    }
  }
  return null;
}
export function plan(party:Party, to:string, tick:number) {
  const inTransit = party.metres>0;
  const origin = inTransit ? party.path[0] : party.node;
  const rest = itinerary(origin,to,party.pace,tick);
  if (!rest) return null;
  const path = inTransit ? [origin,...rest] : rest;
  let hours=0, metres=0, from=party.node;
  for (const [i,next] of path.entries()) {
    const edge=connection(from,next);
    const length=edge.metres-(i===0?party.metres:0);
    metres+=length;
    // Same discrete arrival semantics as advance(), including season boundaries.
    let remaining=length;
    while(remaining>0) { if(marching(tick+hours)) remaining-=speed(edge,party.pace,tick+hours); hours++; }
    from=next;
  }
  return {path,hours,metres};
}
export function fraction(party:Party) {
  return party.path.length ? party.metres/connection(party.node,party.path[0]).metres : 0;
}
export function createCampaign(seed=1622):TravelState {
  function party(id:string,name:string,node:string,stops:string[],salt:number):Party {
    return {id,name,node,stops,stream:((seed^salt)>>>0)||1,pace:'steady',metres:0,path:[]};
  }
  return {modified:false,tick:0,speed:0,waitUntil:null,notice:'Camped at Pune.',parties:[
    party('player','Your company','site_pune',[],0),
    party('villagers','Village train','site_saswad',['site_pune','site_saswad','fort_purandar'],17),
    party('caravan','Pack caravan','site_ahmadnagar',['site_ahmadnagar','site_pune','site_junnar'],61),
    party('patrol','Hill patrol','fort_kondhana',['fort_kondhana','site_pune','site_donaje'],107)
  ]};
}
export function command(state:TravelState, cmd:Command) {
  const player=state.parties[0];
  if(cmd.type==='step') {
    state.modified=true; state.speed=1; advance(state); state.speed=0; return;
  }
  if(cmd.type==='relocate') {
    if(!edges.some(edge=>edge.a===cmd.to||edge.b===cmd.to)) return;
    Object.assign(player,{node:cmd.to,path:[],metres:0});
    state.modified=true; state.waitUntil=null; state.speed=0; state.notice='Developer relocation.'; return;
  }
  if(cmd.type==='speed') { state.speed=cmd.value; return; }
  if(cmd.type==='pace') { player.pace=cmd.value; return; }
  if(cmd.type==='wait') {
    if(!Number.isSafeInteger(cmd.hours)||cmd.hours<1||cmd.hours>24) return;
    state.waitUntil=state.tick+cmd.hours;
    state.speed=state.speed||1; state.notice='Your company is waiting.'; return;
  }
  const route=plan(player,cmd.to,state.tick);
  if(!route || !route.path.length) { state.notice=route?'Already here.':'No preview route reaches this place.'; return; }
  player.path=route.path; state.waitUntil=null; state.speed=state.speed||1;
  state.notice='Travel order accepted.';
}
function chooseDestination(party:Party,tick:number) {
  const choices=party.stops.filter(id=>id!==party.node);
  party.stream=(Math.imul(1664525,party.stream)+1013904223)>>>0;
  party.path=itinerary(party.node,choices[party.stream%choices.length],party.pace,tick)??[];
}
export function advance(state:TravelState) {
  if(!state.speed) return;
  for(const party of state.parties) {
    if(party.id==='player' && state.waitUntil!==null) continue;
    if(!party.path.length && party.stops.length) chooseDestination(party,state.tick);
    if(!party.path.length || !marching(state.tick)) continue;
    const edge=connection(party.node,party.path[0]);
    party.metres+=speed(edge,party.pace,state.tick);
    if(party.metres>=edge.metres) {
      party.node=party.path.shift()!; party.metres=0;
      if(party.id==='player' && !party.path.length) { state.notice='Destination reached.'; }
    }
  }
  state.tick++;
  if(state.tick===state.waitUntil) { state.waitUntil=null; state.notice='Wait complete.'; }
}
