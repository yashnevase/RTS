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
