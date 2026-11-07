# Historical data validation

Python + jsonschema checks portable JSON Schema without choosing a game stack. The user approved this dependency. Requires Python 3.9+ and npm; npm is a script runner only, with no JavaScript dependencies.

From the repository root:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r tools/validate_data/requirements.lock
npm test
npm run validate-data
```

Use `.venv/bin/python tools/validate_data/validate.py --json` for machine-readable results. A failed check returns exit code 1. CI runs both commands on every push/PR; remote CI has not been executed locally.

Only `/data` is loaded. `/archive` and `/templates` are excluded. Adding a supported regional pack under an existing data path automatically includes it; a new entity type requires schema routing in `validate.py`. Unknown JSON files fail rather than silently escaping checks.

Schemas derive from the original templates and real master fields. Unknown historical values remain nullable. Unused fictional template entities are not instantiated. JSON Schema enforces record shapes and metadata; the second pass checks global IDs, reference existence/types, coordinates, temporal order, and nested confidence. Ownership beneficiaries currently accept family/clan only; the Chaul polity case is awaiting review.

The six confidence values come from design §16.3. Workflow status uses §16.2 plus `stub`, required by this cleanup prompt and the existing registry. Draft/inferred metadata added to source records denotes unreviewed cataloguing, not independent verification of their historical claims. Stub is not approval to activate an entity in a scenario.

All actual entity/doubt records have standard metadata. The unchanged Item 04 file is a review proposal document, not a second entity registry: its `id` values are validated targets. Proposal references and assessment enums are checked but never applied. The metadata rule does not rewrite this frozen document. `field_assessment` values are assessments, not foreign keys. Original doubt records under `legacy_entries` are preserved evidence, not live records or live references.

Doubts with colliding legacy IDs are grouped without renaming IDs. Their individual questions and full originals remain under `legacy_entries`. Resolve every constituent before closing a grouped doubt. The two unknown Panhala regions are explicitly warned; zero structural errors does not mean all history is known.

The 16 behavior tests deliberately corrupt copied datasets to exercise broken foreign keys for every populated entity kind, ID collisions, ownership types, coordinates, temporal order, enums, metadata, proposals, unknown files, invalid JSON, CLI failure, and read-only validation.
