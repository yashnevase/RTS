import sites from '../../../data/world/sites/sites_region01.json';
import forts from '../../../data/world/forts/forts_region01.json';
import { districts } from '../../../packages/map/src/districts.ts';

const goa = {
  id: 'landmark_old_goa', name: 'Old Goa', kind: 'site', site_type: 'coastal city',
  coordinate: { latitude: 15.50222, longitude: 73.91167 }, status: 'reference landmark',
  notes: 'The churches and convents of Old Goa mark the former Portuguese capital. This locator uses the UNESCO property coordinates.',
  source: 'https://whc.unesco.org/en/list/234/', ownership: { sovereign_polity_id: 'polity_portuguese' }
};
const burhanpur = {
  id: 'landmark_burhanpur', name: 'Burhanpur', kind: 'site', site_type: 'northern frontier city',
  coordinate: { latitude: 21.3375, longitude: 76.18222 }, status: 'reference landmark',
  notes: 'The Mughal northern approach. The marker uses the location of the Burhanpur waterworks, dated to 1615 in India’s UNESCO submission. The exact 1622 city command requires review.',
  source: 'https://whc.unesco.org/en/tentativelists/6731/', ownership: { sovereign_polity_id: 'polity_mughal' }
};
export const records = [...sites.map(r => ({...r, kind:'site'})), ...forts.map(r => ({...r, kind:'fort'})), goa, burhanpur];
export const byId = new Map(records.map(r => [r.id, r]));
export const hubs = Object.keys(districts);
export function districtOf(id) {
  return hubs.find(hub => hub === id || Object.entries(districts[hub]).some(([fort, satellites]) => fort === id || satellites.includes(id)));
}
export function visibleIds(hub, register) {
  if (register) return new Set(records.map(r=>r.id));
  const ids = new Set(hubs);
  for (const [fort, satellites] of Object.entries(districts[hub] ?? {})) {
    ids.add(fort);
    satellites.forEach(id => ids.add(id));
  }
  return ids;
}
export { districts };
