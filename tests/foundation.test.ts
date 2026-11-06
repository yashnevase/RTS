import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { buildIndex, activate } from '../packages/data/src/index.ts';
import { createState, loadState } from '../packages/sim/src/index.ts';

test('activation rejects placeholders, duplicates and unknown IDs', () => {
  const stub = { id:'site_test',record_version:1,source_ids:[],confidence:'inferred',status:'stub' };
  const index = buildIndex([stub]);
  assert.throws(() => activate(index, [stub.id]), /Unapproved/);
  assert.throws(() => activate(index, ['missing']), /Unknown/);
  assert.throws(() => buildIndex([stub, stub]), /Duplicate/);
  stub.status = 'approved';
  assert.throws(() => activate(index, [stub.id]), /Unapproved/);
});
test('foundation save round trip and version rejection', () => {
  assert.deepEqual(loadState(JSON.stringify(createState())), createState());
  assert.throws(() => loadState('{"schemaVersion":2}'), /unsupported/);
  assert.throws(() => loadState(JSON.stringify({...createState(), tick:-1})), /unsupported/);
});
test('pure packages have no presentation imports or nondeterministic/browser APIs', () => {
  function scan(dir: string) {
    for (const entry of readdirSync(dir, {withFileTypes:true})) {
      const path = join(dir, entry.name);
      if (entry.isDirectory()) scan(path);
      else if (path.endsWith('.ts')) {
        const code = readFileSync(path,'utf8');
        assert.doesNotMatch(code, /(?:Math\.random|Date\.now|\bwindow\b|\bdocument\b|\blocalStorage\b|\bindexedDB\b)/);
        assert.doesNotMatch(code, /(?:from\s*|import\s*\()["'][^"']*(?:\/map\/|\/ui\/|react|pixi)/);
      }
    }
  }
  scan('packages/sim/src'); scan('packages/battle/src');
});
