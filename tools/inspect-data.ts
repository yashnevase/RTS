import { readFileSync, readdirSync } from 'node:fs';
import { resolve, join } from 'node:path';
import { buildIndex } from '../packages/data/src/index.ts';
import { createState, inspect } from '../packages/sim/src/index.ts';
const root = resolve(import.meta.dirname, '../data');
function readRecords(path: string): unknown[] {
  return readdirSync(path, { withFileTypes: true }).flatMap(entry => {
    if (entry.name === 'review') return [];
    const file = join(path, entry.name);
    return entry.isDirectory() ? readRecords(file) : entry.name.endsWith('.json') ? JSON.parse(readFileSync(file, 'utf8')) : [];
  });
}
const index = buildIndex(readRecords(root) as Parameters<typeof buildIndex>[0]);
const id = process.argv[2];
if (id && !index.has(id)) throw new Error(`Unknown entity: ${id}`);
console.log(JSON.stringify(id ? index.get(id) : { indexedEntities: index.size, state: inspect(createState()) }, null, 2));
