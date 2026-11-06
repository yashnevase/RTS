# Data cleanup changelog

2026-11-06. Each heading corresponds to a separate concern / git commit; use git log for exact commit IDs.

## Restructure and audit

Initialized git and committed untouched inputs (`8b32e03`), then created `data-cleanup`. Moved authoritative master data to /data, starter templates to /templates, and the design reference to /docs. Archived loose packs, stubs and the untouched zip via git mv. Removed tracked .DS_Store. No historical values changed in this commit. See data_audit.md for original hashes and counts.

## Validator foundation

Selected Python + jsonschema because it checks portable JSON Schema without introducing the game stack. Dependency explicitly approved by the user. Added strict schemas derived from the supplied settlement/clan/family/region/polity templates and actual master shapes, with canonical coordinate and navigation names. Added cross-file ID/reference, ownership type, enum, coordinate and temporal checks. Review proposals are documents targeting existing entities, not duplicate entity declarations. They are checked without applying them. Archive/templates are never scanned. Baseline defects are expected to fail until the following repair commits.
