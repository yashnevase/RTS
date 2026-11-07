# M0 foundation report — 2026-11-07

Design gate satisfied by explicit user instruction “lock the dwsign agreed proceed”. First campaign is Region Pack 01 with a 50-year initial horizon and labelled fictional supporting NPCs permitted. Historical unknowns and other OPEN decisions still require resolution before affected systems.

## Implemented

- npm workspaces for data, sim, battle, map, UI and game composition; strict TypeScript with no DOM library in core type checking.
- Approved TypeScript development dependency and npm lockfile; Node 24 native TypeScript execution with built-in test runner.
- Existing Python JSON Schema/reference validator remains authoritative. Typed index clones inputs, rejects duplicates and allows scenario activation only for approved records. Nothing in the historical dataset has been automatically approved.
- Minimal versioned foundation state and defensive save loading; unknown versions and invalid ticks fail. No RNG exists yet because no stochastic simulation is implemented; RNG state becomes mandatory with the first such system.
- CLI inspection console shell, including current foundation state or one historical entity. It does not mutate history or grant cheats yet.
- Foundation tests for activation, input isolation, save validation, and source scanning for prohibited presentation/browser/nondeterministic APIs; existing 16 data tests retained.
- CI now installs locked npm dependencies and uses Node 24.

## Run

After existing Python virtual-environment setup: `npm ci`, then `npm test` and `npm run validate-data`.

`npm run inspect-data` validates data and prints index count plus foundation state. `npm run inspect-data -- site_ahmadnagar` prints that record. Historical data has 319 indexed entities; review documents are not entity declarations.

## Limits and acceptance

This is a headless foundation, not a playable campaign. No screenshot is applicable. Map/UI packages contain only contracts; no Vite/React/PixiJS dependencies are installed. Console editing, worker runtime, RNG, full replay/hash system, migrations and campaign simulation will arrive with their relevant milestones. The source boundary test is a basic guard, not a full import-graph analyzer.

Required checks: strict typecheck, foundation tests, 16 data tests and zero validator errors. Two known Panhala region warnings remain explicit; the ownership patch stays unapplied.

Next milestone is M1 map, only after user inspection and approval. Rendering dependencies require approval before installation.
