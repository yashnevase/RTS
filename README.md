# Deccan Warlords — historical data

Current stage: data cleanup complete, awaiting review. Design and game implementation are not locked or started.

- [Cleanup report and decisions](docs/data_cleanup_report.md)
- [Original input inventory and hashes](docs/data_audit.md)
- [Traceable data changelog](docs/data_changelog.md)
- [Validator setup and commands](tools/validate_data/README.md)
- [Untouched archived inputs](archive/original_packs/README.md)

Canonical data lives only in `/data`. Templates and archived originals are not runtime input. Run `npm test` and `npm run validate-data` after the documented Python virtual-environment setup.
