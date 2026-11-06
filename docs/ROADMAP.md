# Roadmap — review draft

Design approval first. Each milestone gets a short plan, implementation, tests, report under docs/progress/Mx_report.md and user inspection; then stop. No next milestone without approval. Scope additions enter backlog.md.

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

Reports include how to run, evidence, known issues, changed assumptions, and screenshots for visual work. Do not claim timing plausibility from determinism alone: travel needs explicit distance/speed review. Scope of original M1 terrain coverage follows the still-OPEN v1 extent decision.
