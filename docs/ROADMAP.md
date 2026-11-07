# Roadmap — review draft

Design approval first. Each milestone gets a short plan, implementation, tests, report under docs/progress/Mx_report.md and user inspection; then stop. No next milestone without approval. Scope additions enter backlog.md.

## Pack 01 completion target — user decision 2026-11-07

M0–M7 build one complete, polished Region Pack 01 campaign before expansion. M0–M2 remain the foundation, not the finished small game. Complete travel, markets, contracts, recruitment, relationships, political service, raids, auto-battles, sieges and the approved household/holding career loops inside this geography. RTS remains a later separate milestone; audio remains deferred.

Completion requires a coherent onboarding path, consistent approved art, usable dialogue and menus, save/load recovery, developer console, readable consequences, multiple viable careers and a three-hour user playtest without progression blockers. Validate trading, security/mercenary service and coercive/raiding paths through the same living economy; each must have costs, opponents and failure recovery. Succession and generated-character implementation wait for their OPEN decisions.

Expansion reuses schemas, systems and asset conventions, but each new pack needs historical research, authored/reviewed characters and places, navigation, regional economics, art review and regression balancing. More entities can expose AI/performance problems and cross-region political effects. Do not promise expansion is only adding stories or increasing counts. Prove modular loading with a synthetic test fixture before adding researched region packs; never present synthetic fixtures as history.

| Milestone | Tasks | Acceptance | Main risk |
|---|---|---|---|
| M0 Foundation | Workspaces, pure contracts, loader, CI, console shell, save version scaffold | npm test and validate-data pass; package boundaries enforced; stubs cannot activate silently | Unresolved schemas and actor scope |
| M1 Map | Terrain prototype, camera, coordinate transform, site/fort inspection, label layout, art placeholders | All 65 sites and 23 forts locatable from canonical coordinates; inspect unknowns; measured 60fps target | GIS permissions, tile seams, art readability |
| M2 Movement | Reviewed graph subset, party, pause/speed, supply preview, seasons, console time/teleport | Pune–Ahmadnagar repeatable travel on explicit approved route assumptions; seed replay equal | Historical corridors are not finished edges |
| M3 Economy | Market screens, goods/recipes, production, taxes, caravan AI, contracts | Five-year headless run: bounded prices, nonnegative stock and conserved transfers | Economic feedback loops |
| M4 People | Biography/assumptions, families, ties/memories, aging, approved succession | 100-year multi-seed run with no orphan IDs and stable viable noble population | Missing genealogy/NPC permission |
| M5 War | Troops/recruitment, resolver, sieges, utility AI, battle report | AI fights/captures/recovers; golden replay and save continuation match | Positive feedback and conquest snowball |
| M6 Career | Service, trade/security contracts, raids, companions, holdings, kingdom formation | Scripted scenarios demonstrate every approved career and failure recovery | UI/content scope |
| M7 Polish | Consistent art, onboarding, accessibility, performance, migrations, balance | 200-year multi-seed soak and three-hour user playtest; no crashes/orphans; review domination distribution | Polish and balance need iteration; audio deferred |
| M8 RTS | Separate encounter screen, terrain battlefield, regiments, formations/orders/retreat | 500 seeded comparable battles; compare win rate, loss ratio and duration distributions; tolerance proposal ±10 percentage points win rate (TUNABLE) | Large additional control/animation workload |

Reports include how to run, evidence, known issues, changed assumptions, and screenshots for visual work. Do not claim timing plausibility from determinism alone: travel needs explicit distance/speed review. M1 terrain coverage targets Region Pack 01; final playable boundary and historical activation require review.
