export interface Entity {
  id: string;
  record_version: number;
  source_ids: string[];
  confidence: string;
  status: string;
  [field: string]: unknown;
}

// Full schema/reference validation is mandatory before this typed indexing layer.
export function buildIndex(records: readonly Entity[]): ReadonlyMap<string, Entity> {
  const index = new Map<string, Entity>();
  for (const record of records) {
    if (index.has(record.id)) throw new Error(`Duplicate ID: ${record.id}`);
    index.set(record.id, JSON.parse(JSON.stringify(record)) as Entity);
  }
  return index;
}

export function activate(index: ReadonlyMap<string, Entity>, ids: readonly string[]): Entity[] {
  return ids.map(id => {
    const record = index.get(id);
    if (!record) throw new Error(`Unknown activation: ${id}`);
    if (record.status !== 'approved') throw new Error(`Unapproved activation: ${id}`);
    return JSON.parse(JSON.stringify(record)) as Entity;
  });
}
