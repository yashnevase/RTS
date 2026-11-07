# Deccan Warlords — historical data

Current stage: M1 campaign atlas preview. Run `npm run dev` and open the local URL. Select a district to inspect its seat, nearby forts and support places. **Register** opens the full catalog. See [the M1 report](docs/progress/M1_report.md) for limitations and the verified browser view.

- [Design decisions and open questions](docs/DECISIONS.md)
- [Game design](docs/GAME_DESIGN.md)
- [Roadmap and acceptance tests](docs/ROADMAP.md)

- [Cleanup report and decisions](docs/data_cleanup_report.md)
- [Original input inventory and hashes](docs/data_audit.md)
- [Traceable data changelog](docs/data_changelog.md)
- [Validator setup and commands](tools/validate_data/README.md)
- [Untouched archived inputs](archive/original_packs/README.md)

Canonical data lives only in `/data`. Templates and archived originals are not runtime input. Run `npm test` and `npm run validate-data` after the documented Python virtual-environment setup.
