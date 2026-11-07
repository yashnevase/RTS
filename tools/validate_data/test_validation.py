"""Behavior tests: reject corrupt data at the actual validator boundary."""
import copy
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

from validate import ROOT, validate


class DataValidationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.data = Path(self.temp.name) / 'data'
        shutil.copytree(ROOT / 'data', self.data)

    def mutate(self, path, change):
        file = self.data / path
        records = json.loads(file.read_text())
        change(records)
        file.write_text(json.dumps(records))

    def reject(self, expected):
        errors = validate(self.data)['errors']
        self.assertTrue(any(expected in issue for issue in errors), errors)

    def test_authoritative_data_passes(self):
        result = validate()
        self.assertEqual(result['errors'], [])
        self.assertEqual(result['record_counts']['site'], 65)
        self.assertEqual(result['record_counts']['fort'], 23)
        self.assertEqual(result['proposal_count'], 15)

    def test_broken_references_across_all_entity_types(self):
        mutations = [
            ('world/sites/sites_region01.json', lambda r: r.__setitem__('region_id', 'region_missing')),
            ('world/sites/sites_region01.json', lambda r: r['security'].__setitem__('protecting_fort_ids', ['fort_missing'])),
            ('world/forts/forts_region01.json', lambda r: r.__setitem__('protects_site_ids', ['site_missing'])),
            ('world/sites/sites_region01.json', lambda r: r['ownership'].__setitem__('owner_clan_id', 'clan_missing')),
            ('people/clans_region01.json', lambda r: r.__setitem__('family_ids', ['family_missing'])),
            ('world/sites/sites_region01.json', lambda r: r['ownership'].__setitem__('controller_polity_id', 'polity_missing')),
            ('world/sites/sites_region01.json', lambda r: r.__setitem__('source_ids', ['source_missing'])),
            ('world/sites/sites_region01.json', lambda r: r.__setitem__('route_node_id', 'node_missing')),
            ('world/sites/sites_region01.json', lambda r: r['ownership'].__setitem__('governor_character_id', 'character_missing')),
        ]
        for path, mutate in mutations:
            with self.subTest(path=path):
                original = (self.data / path).read_text()
                self.mutate(path, lambda rs: mutate(rs[0]))
                self.reject('unresolved reference')
                (self.data / path).write_text(original)

    def test_unique_ids_across_files(self):
        records = json.loads((self.data / 'world/sites/sites_region01.json').read_text())
        (self.data / 'world/sites/duplicate_pack.json').write_text(json.dumps([records[0]]))
        self.reject('duplicate ID')

    def test_wrong_existing_entity_type(self):
        self.mutate('world/sites/sites_region01.json', lambda rs: rs[0].__setitem__('region_id', 'polity_nizam_shahi'))
        self.reject('wrong ID type')

    def test_beneficiary_cannot_be_polity(self):
        self.mutate('world/sites/sites_region01.json', lambda rs: rs[0]['ownership'].__setitem__('revenue_beneficiary_id', 'polity_portuguese'))
        self.reject('wrong ID type')

    def test_coordinate_limits(self):
        for key, value in [('latitude', 7.99), ('latitude', 24.51), ('longitude', 70.49), ('longitude', 87.51)]:
            with self.subTest(key=key, value=value):
                self.mutate('world/sites/sites_region01.json', lambda rs: rs[0]['coordinate'].__setitem__(key, value))
                self.reject('outside')

    def test_reversed_record_dates(self):
        self.mutate('world/sites/sites_region01.json', lambda rs: rs[0].update(valid_from=1622, valid_to=1621))
        self.reject('valid_from > valid_to')

    def test_reversed_nested_service_dates(self):
        self.mutate('people/clans_region01.json', lambda rs: rs[1]['patronage_relationships'][0].update(from_year=1630, to_year=1620))
        self.reject('from_year > to_year')

    def test_invalid_confidence_and_status(self):
        self.mutate('world/sites/sites_region01.json', lambda rs: rs[0].update(confidence='certain', status='ready'))
        self.reject('certain')
        self.reject('ready')

    def test_missing_required_metadata(self):
        self.mutate('sources/source_registry.json', lambda rs: rs[0].pop('record_version'))
        self.reject('record_version')

    def test_broken_review_target_and_source(self):
        self.mutate('review/item04_ownership_patch_NOT_APPLIED.json', lambda rs: rs[0]['content'][0].__setitem__('source_ids', ['source_missing']))
        self.reject('source_missing')
        self.mutate('review/item04_ownership_patch_NOT_APPLIED.json', lambda rs: rs[0]['content'][0].__setitem__('id', 'fort_missing'))
        self.reject('unknown proposal target')

    def test_review_assessments_are_not_entity_references(self):
        self.assertEqual(validate(self.data)['errors'], [])
        self.mutate('review/item04_ownership_patch_NOT_APPLIED.json', lambda rs: rs[0]['content'][0]['field_assessment'].__setitem__('sovereign_polity_id', 'certain'))
        self.reject('invalid field assessment')

    def test_cli_fails_on_broken_reference(self):
        self.mutate('world/forts/forts_region01.json', lambda rs: rs[0].__setitem__('region_id', 'region_missing'))
        run = subprocess.run([sys.executable, str(Path(__file__).with_name('validate.py')), '--data-root', str(self.data)], capture_output=True, text=True)
        self.assertNotEqual(run.returncode, 0)
        self.assertIn('region_missing', run.stdout)

    def test_new_data_files_cannot_bypass_schema(self):
        (self.data / 'unregistered.json').write_text('[]')
        self.reject('unregistered dataset')

    def test_invalid_json(self):
        (self.data / 'world/sites/sites_region01.json').write_text('{broken')
        self.reject('invalid JSON')

    def test_validation_never_applies_proposals(self):
        before = {p: p.read_bytes() for p in self.data.rglob('*.json')}
        validate(self.data)
        self.assertEqual(before, {p: p.read_bytes() for p in self.data.rglob('*.json')})

if __name__ == '__main__':
    unittest.main()
