const key='deccan-warlords-campaign-v1';

export function readCampaign() {
  try {
    const value=JSON.parse(localStorage.getItem(key)??'null');
    if(value?.version!==1 || value.world?.started!==true ||
      !Number.isSafeInteger(value.world.tick) || !Array.isArray(value.world.parties) ||
      value.world.parties.slice(0,4).map(p=>p.id).join(',')!=='player,villagers,caravan,patrol' ||
      !value.world.identity || !value.world.economy?.markets || !value.world.merchant ||
      !value.world.encounter || !value.world.relations || !Array.isArray(value.world.events)) return null;
    return value.world;
  } catch { return null; }
}

export function saveCampaign(world) {
  try {
    if(!world.started) return false;
    localStorage.setItem(key,JSON.stringify({version:1,world}));
    return true;
  } catch { return false; }
}

export function parseCampaign(text){
 try{
  const value=JSON.parse(text),w=value?.world;
  if(value?.version!==1||!w?.started||!Number.isSafeInteger(w.tick)||w.tick<0||
    !Array.isArray(w.parties)||w.parties.slice(0,4).map(p=>p.id).join(',')!=='player,villagers,caravan,patrol'||
    !w.economy?.markets||!w.identity||!w.encounter||!w.merchant||!w.relations||!Array.isArray(w.events))return null;
  if(w.parties.some(p=>!p.point||!Number.isFinite(p.point.latitude)||!Number.isFinite(p.point.longitude)))return null;
  const nonnegative=value=>Number.isFinite(value)&&value>=0;
  if(!nonnegative(w.economy.gold)||!nonnegative(w.encounter.guards)||!w.economy.inventory||
     !nonnegative(w.economy.inventory.grain)||!nonnegative(w.economy.inventory.wood))return null;
  if(w.parties.some(p=>!Array.isArray(p.path)||p.motion&&(!Array.isArray(p.motion.points)||!p.motion.points.length||
    !Number.isSafeInteger(p.motion.index)||p.motion.index<0||p.motion.index>=p.motion.points.length||
    !nonnegative(p.motion.progress)||p.motion.points.some(point=>!Number.isFinite(point.latitude)||!Number.isFinite(point.longitude)))))return null;
  return w;
 }catch{return null;}
}
export function readSlot(slot){
 try{return parseCampaign(localStorage.getItem(key+'-slot-'+slot)??'null');}catch{return null;}
}
export function writeSlot(slot,world){
 try{
  const text=JSON.stringify({version:1,world});
  if(!parseCampaign(text))return false;
  localStorage.setItem(key+'-slot-'+slot,text);return true;
 }catch{return false;}
}
export function deleteSlot(slot){localStorage.removeItem(key+'-slot-'+slot);}
