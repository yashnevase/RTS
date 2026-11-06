# Architecture — review draft

TypeScript strict, Vite/npm workspaces, PixiJS canvas and React panels. Python remains the approved historical-data validator and offline terrain tool. No new dependencies installed during Phase A.

| Package | Owns | May depend on |
|---|---|---|
| packages/data | Schemas, typed indexes, pack manifests | Pure schema utilities |
| packages/sim | Tick engine, state, commands, AI, economy, politics | data, battle |
| packages/battle | Pure auto-resolver and shared battle contracts | data |
| packages/map | PixiJS renderer, camera, selection | Snapshot contracts, data |
| packages/ui | React menus, dialogue, HUD | Snapshot/command contracts |
| apps/game | Worker, persistence, UI/map composition | All presentation packages |

Sim/battle never import map, UI, DOM, browser storage or wall-clock APIs. Dependency checks enforce this boundary. Presentation animation may use wall time; authoritative simulation cannot.

UI sends CommandEnvelope {commandId, requestedTick, sequence, issuerId, type, payload}. Worker checks permissions, legality and resources, then returns Accepted or Rejected(reason). Accepted commands produce ordered domain events and versioned snapshots. UI cannot treat optimistic previews as authoritative outcomes. Commands arriving after a closed tick are assigned the next tick and recorded. Read snapshots at most 10 times/second (TUNABLE); derive interpolation only for display.

Worker owns world and RNG. Main thread owns rendering, inputs and IndexedDB. Pause stops tick advancement, not UI. Speed controls change scheduling, never tick formulas. Long catch-up batches yield between bounded groups while preserving order. Save requests pause at a tick boundary and serialize atomically; write new IndexedDB record before replacing latest pointer. Save/load restores all RNG and command ordering state. Developer console submits privileged typed commands and records modified-save provenance.

Tests: schema/references; unit tests of conservation and legal transitions; property tests of nonnegative inventory and valid succession; command replay with canonical sorted state hash; save/load continuation equivalence; package dependency checks; headless multi-seed soak; UI interaction tests; renderer profiling and screenshots. Golden hashes are versioned and reviewed, never silently refreshed. Worker and headless runner consume the same engine.

RTS later loads BattleInput in its own screen, returns BattleOutcome, and resumes the paused campaign through one validated resolution command. No duplicate rewards or simultaneous campaign progression during manual battle.
