import type { Coordinate } from './index.ts';

export interface MapRecord {
  id: string;
  name: string;
  kind: 'site' | 'fort';
  type: string;
  coordinate: Coordinate;
  region_id: string | null;
  confidence: string;
  status: string;
  notes: string;
}

type InputRecord = Omit<MapRecord, 'kind' | 'type'> & { site_type?: string; fort_type?: string };

export function mapRecords(sites: readonly InputRecord[], forts: readonly InputRecord[]): MapRecord[] {
  return [...sites.map(record => ({ ...record, kind: 'site' as const, type: record.site_type ?? 'unknown' })),
    ...forts.map(record => ({ ...record, kind: 'fort' as const, type: record.fort_type ?? 'unknown' }))];
}
