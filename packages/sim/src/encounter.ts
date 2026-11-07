import {cell,terrain,type Point} from './navigation.ts';

export const raiderSite='fort_kondhana';
export interface EncounterResult {
  outcome:'Victory'|'Retreat'; terrain:string; guardsLost:number; coin:number; seed:number;
  strength:number; opposition:number;
}
export function encounterTerrain(point:Point) {
  const id=cell(point);
  if(terrain.woodland.includes(id))return {name:'Wooded ground',advantage:2};
  if(terrain.cost[id]>=12)return {name:'Hill approaches',advantage:3};
  return {name:'Open ground',advantage:0};
}
export function resolveEncounter(guards:number,point:Point,seed:number):EncounterResult {
  const ground=encounterTerrain(point);
  const next=(Math.imul(seed,1664525)+1013904223)>>>0;
  const strength=3+guards*2;
  const opposition=6+ground.advantage;
  const victory=strength+(next%5)>=opposition;
  return {outcome:victory?'Victory':'Retreat',terrain:ground.name,
    guardsLost:Math.min(guards,victory?(ground.advantage?1:0):2),
    coin:victory?75:0,seed:next,strength,opposition};
}

export function changeRelation(previous:number,delta:number) {
  return Math.min(100,Math.max(-100,previous+delta));
}
