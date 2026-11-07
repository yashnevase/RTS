import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { mapSize, project, unproject } from '../packages/map/src/index.ts';
import { mapRecords } from '../packages/map/src/records.ts';
import { homeCamera, zoomAt } from '../packages/map/src/camera.ts';

test('zoom keeps the map point under the pointer at the same screen position', () => {
  const home = homeCamera(1000, 700);
  const x = 390, y = 220;
  const next = zoomAt(home, x, y, 2, home.zoom);
  assert.ok(Math.abs((x - home.x) / home.zoom - (x - next.x) / next.zoom) < 1e-10);
  assert.ok(Math.abs((y - home.y) / home.zoom - (y - next.y) / next.zoom) < 1e-10);
  assert.equal(zoomAt(home, x, y, 0.01, home.zoom).zoom, home.zoom);
});

test('all canonical Pack 01 markers project inside the terrain and preserve coordinates', () => {
  const read = (kind: string) => JSON.parse(readFileSync(`data/world/${kind}/${kind}_region01.json`, 'utf8'));
  const records = mapRecords(read('sites'), read('forts'));
  assert.equal(records.filter(record => record.kind === 'site').length, 65);
  assert.equal(records.filter(record => record.kind === 'fort').length, 23);
  assert.equal(new Set(records.map(record => record.id)).size, 88);
  for (const { id, coordinate } of records) {
    const { x, y } = project(coordinate);
    assert.ok(x >= 0 && x <= mapSize.width && y >= 0 && y <= mapSize.height, id);
    const inverse = unproject(x, y);
    assert.ok(Math.abs(inverse.latitude - coordinate.latitude) < 1e-10, id);
    assert.ok(Math.abs(inverse.longitude - coordinate.longitude) < 1e-10, id);
  }
});

import { districts } from '../packages/map/src/districts.ts';

test('campaign hierarchy keeps the existing fort links and the small satellite limit', () => {
  const read = (kind: string) => JSON.parse(readFileSync(`data/world/${kind}/${kind}_region01.json`, 'utf8'));
  const sites = read('sites'), forts = read('forts');
  for (const [hub, branches] of Object.entries(districts)) {
    if (hub.startsWith('landmark_')) continue;
    const seat = sites.find((r: {id: string}) => r.id === hub);
    assert.ok(seat, hub);
    assert.ok(Object.keys(branches).length <= 2);
    for (const [fort, satellites] of Object.entries(branches)) {
      assert.ok(seat.security.protecting_fort_ids.includes(fort), fort);
      assert.ok(forts.some((r: {id: string}) => r.id === fort));
      assert.ok(satellites.length <= 2);
      for (const id of satellites) assert.ok(sites.some((r: {id: string}) => r.id === id), id);
    }
  }
});
