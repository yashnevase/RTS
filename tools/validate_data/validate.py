"""Validate only /data. Review proposals are inspected, never applied."""
from __future__ import annotations
import argparse
import json
from collections import Counter
from pathlib import Path
from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[2]
SCHEMAS = Path(__file__).with_name('schemas')
CONFIDENCE = {'high', 'medium', 'low', 'contested', 'fictional', 'inferred'}
STATUS = {'draft', 'researched', 'reviewed', 'approved', 'fictional', 'deprecated', 'stub'}
TYPE_PATHS = {
    'world/sites': 'site', 'world/forts': 'fort', 'world/regions': 'region',
    'world/navigation/passes': 'pass', 'world/navigation/crossings': 'crossing',
    'world/navigation/road_corridor': 'route', 'world/navigation/nodes': 'node',
    'people/clans': 'clan', 'people/families': 'family', 'people/characters': 'character',
    'politics/polities': 'polity', 'sources/source_registry': 'source',
    'review/doubts.json': 'doubt',
}
REF_TYPES = {
    'region_id': ('region_',), 'parent_region_id': ('region_',),
    'home_region_id': ('region_',), 'home_region_ids': ('region_',),
    'macro_region_id': ('macro_',), 'route_node_id': ('node_',),
    'site_id': ('site_',), 'site_ids': ('site_',), 'protects_site_ids': ('site_',),
    'attached_village_ids': ('site_',), 'ancestral_seat_id': ('site_',),
    'ancestral_seat_ids': ('site_',), 'fort_ids': ('fort_',),
    'associated_fort_ids': ('fort_',), 'protecting_fort_ids': ('fort_',),
    'controlling_fort_id': ('fort_',), 'family_ids': ('family_',),
    'branch_ids': ('branch_',), 'member_character_ids': ('character_',),
    'leader_character_id': ('character_',), 'head_character_id': ('character_',),
    'founder_character_id': ('character_',), 'governor_character_id': ('character_',),
    'garrison_commander_id': ('character_',), 'source_ids': ('source_',),
    'polity_id': ('polity_',), 'sovereign_polity_id': ('polity_',),
    'controller_polity_id': ('polity_',), 'overlord_polity_id': ('polity_',),
    'owner_clan_id': ('clan_',), 'revenue_beneficiary_id': ('family_', 'clan_'),
    'waypoint_ids': ('site_', 'fort_', 'pass_', 'crossing_', 'node_'),
}


def validate(data_root: Path = ROOT / 'data') -> dict:
    errors, warnings, records, proposals = [], [], [], []
    schemas = {p.name.removesuffix('.schema.json'): json.loads(p.read_text())
               for p in SCHEMAS.glob('*.schema.json')}
    for schema in schemas.values():
        Draft202012Validator.check_schema(schema)
    for path in sorted(data_root.rglob('*.json')):
        relative = path.relative_to(data_root).as_posix()
        try:
            content = json.loads(path.read_text())
        except (ValueError, OSError) as exc:
            errors.append(f'{relative}: invalid JSON: {exc}')
            continue
        if relative == 'review/item04_ownership_patch_NOT_APPLIED.json':
            if not isinstance(content, list):
                errors.append(f'{relative}: expected proposal document list')
                continue
            for section in content:
                if not isinstance(section, dict) or not isinstance(section.get('content'), list):
                    errors.append(f'{relative}: invalid proposal section')
                    continue
                for proposal in section['content']:
                    proposals.append((relative, proposal))
            continue
        kind = next((kind for prefix, kind in TYPE_PATHS.items()
                     if relative.startswith(prefix)), None)
        if kind is None:
            errors.append(f'{relative}: unregistered dataset; add explicit schema routing')
            continue
        if not isinstance(content, list):
            errors.append(f'{relative}: expected record array')
            continue
        for i, record in enumerate(content):
            location = f'{relative}[{i}]'
            for err in Draft202012Validator(schemas[kind]).iter_errors(record):
                errors.append(f'{location}/{"/".join(map(str, err.path))}: {err.message}')
            if isinstance(record, dict):
                records.append((location, kind, record))
    index = {}
    for location, kind, record in records:
        rid = record.get('id')
        if not isinstance(rid, str):
            continue
        if rid in index:
            errors.append(f'{location}: duplicate ID {rid}, first at {index[rid][0]}')
        else:
            index[rid] = (location, kind)

    def walk(value, location):
        if isinstance(value, dict):
            for lo, hi in [('valid_from', 'valid_to'), ('from_year', 'to_year'),
                           ('birth_year', 'death_year')]:
                a, b = value.get(lo), value.get(hi)
                if a is not None and b is not None:
                    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
                        errors.append(f'{location}: {lo}/{hi} must be numeric years or null')
                    elif a > b:
                        errors.append(f'{location}: {lo} > {hi}')
            if 'latitude' in value or 'longitude' in value:
                for key, low, high in [('latitude', 8, 24.5), ('longitude', 70.5, 87.5)]:
                    n = value.get(key)
                    if n is not None and (type(n) not in (int, float) or not low <= n <= high):
                        errors.append(f'{location}/{key}: outside {low}..{high}')
            for key, item in value.items():
                # Raw original doubt entries are preserved evidence, not live references.
                if key in {'legacy_entries', 'field_assessment'}:
                    continue
                here = f'{location}/{key}'
                if key == 'confidence' and item not in CONFIDENCE:
                    errors.append(f'{here}: invalid confidence {item}')
                is_ref = key.endswith('_id') or key.endswith('_ids') or key in {'waypoints'}
                if is_ref and item is not None:
                    targets = item if isinstance(item, list) else [item]
                    for target in targets:
                        if not isinstance(target, str):
                            errors.append(f'{here}: ID must be a string')
                        elif target not in index:
                            errors.append(f'{here}: unresolved reference {target}')
                        elif key in REF_TYPES and not target.startswith(REF_TYPES[key]):
                            errors.append(f'{here}: wrong ID type {target}; expected {REF_TYPES[key]}')
                if key == 'region_id' and item is None:
                    warnings.append(f'{here}: unknown region (must remain in review)')
                walk(item, here)
        elif isinstance(value, list):
            for i, item in enumerate(value):
                walk(item, f'{location}[{i}]')

    for location, kind, record in records:
        walk(record, location)
    for location, proposal in proposals:
        if not isinstance(proposal, dict) or proposal.get('id') not in index:
            errors.append(f'{location}: unknown proposal target')
            continue
        target = proposal['id']
        if index[target][1] not in {'site', 'fort'}:
            errors.append(f'{location}: proposal target must be site or fort')
        if proposal.get('confidence') not in CONFIDENCE:
            errors.append(f'{location}/{target}: invalid proposal confidence')
        patch = proposal.get('ownership_patch')
        if not isinstance(patch, dict):
            errors.append(f'{location}/{target}: ownership_patch must be an object')
        else:
            ownership = schemas['site']['properties']['ownership']['properties']
            for key, value in patch.items():
                if key not in ownership:
                    errors.append(f'{location}/{target}: unknown ownership field {key}')
                else:
                    for err in Draft202012Validator(ownership[key]).iter_errors(value):
                        errors.append(f'{location}/{target}/{key}: {err.message}')
        assessment = proposal.get('field_assessment')
        if not isinstance(assessment, dict):
            errors.append(f'{location}/{target}: field_assessment must be an object')
        else:
            for key, value in assessment.items():
                if key not in schemas['site']['properties']['ownership']['properties'] or value not in {'unknown', 'proposed'}:
                    errors.append(f'{location}/{target}: invalid field assessment {key}={value}')
        walk(proposal, f'{location}/{target}')
    counts = Counter(kind for _, kind, _ in records)
    return {'errors': errors, 'warnings': warnings, 'record_counts': dict(sorted(counts.items())),
            'total_records': len(records), 'proposal_count': len(proposals),
            'stub_records': sum(r.get('status') == 'stub' for _, _, r in records)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--data-root', type=Path, default=ROOT / 'data')
    parser.add_argument('--json', action='store_true')
    args = parser.parse_args()
    result = validate(args.data_root)
    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print(f"Data validation: {len(result['errors'])} errors, {len(result['warnings'])} warnings")
        print(f"{result['total_records']} records; {result['proposal_count']} unapplied proposals; "
              f"{result['stub_records']} explicit stubs")
        print('Counts: ' + ', '.join(f'{k}={v}' for k, v in result['record_counts'].items()))
        for severity in ['errors', 'warnings']:
            for issue in result[severity]:
                print(f'{severity.upper()}: {issue}')
    raise SystemExit(bool(result['errors']))

if __name__ == '__main__':
    main()
