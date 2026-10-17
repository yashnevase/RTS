# Change log

## v0.1 — 2026-10-15 — Vision capture

- Captured the expanded vision: an accessible, atmospheric, stylized PC strategy sandbox grounded in early-modern India/Deccan.
- Added the proposed inherited-clan opening, political ambitions, populated settlements, household growth, supply convoys, deeper sieges, companions/delegation and future player-as-lord multiplayer concept.
- Recorded the major scale question: full subcontinent aspiration versus practical first playable region and simulation detail.
- Proposed Godot 4.x stable for the primary game build; retained Three.js prototype as reference and possible source of reusable logic.
- Added AI direction: explainable utility/planning/tactical AI first; ML remains an optional later experiment requiring a specific measurable benefit.
- Created decision/system/question/roadmap trackers.
- No new mechanics, formulas, exact start assets, content counts, or release scope have been locked by this version.


## v0.2 — 2026-10-16 — ChatGPT/VS Code bridge and audience discussion

- Added `AGENTS.md`, `PROJECT_CONTEXT.md`, `CHATGPT_VSCODE_WORKFLOW.md`, and `README_IMPORT.md` to bridge the design discussion to a local repository/Codex workflow.
- Added product identity/audience hypotheses: real-time settlement/kingdom sandbox with politics and tactical battles may be a closer working description than pure RTS. Not locked.
- Added open tension between long-session sandbox play and short competitive modes.
- Preserved the India-wide aspiration while explicitly recording launch map scope as open.
- Updated decision log with workflow, game identity and launch questions. Markdown remains canonical; exported DOCX/PDF/XLSX are historical v0.1 snapshots.


## v0.3 — 2026-10-16 — Large fixed world and reusable simulation model

- Clarified that the desired world is a large fixed/researched strategic map, with major locations from Delhi toward Kanyakumari; it is not a randomly generated geography.
- Added the shared-engine model: entities reuse common rules while different data for culture, traits, geography, population, resources, rank, ambitions, relationships, armies and circumstances creates varied behavior.
- Clarified that map scale and simulation detail are separate questions. Performance/detail levels should be tested, not used as a pretext to automatically shrink the intended world.
- Kept exact location roster, historical date, detail tiers and technical implementation OPEN.


## v0.4 — 2026-10-16 — Jev harness research

- Added a research note on Jev's typed decision primitives and LangChain's model-routing/tool-risk middleware.
- Recorded the current recommendation: do not use Jev for the game's runtime lord/army AI and do not add it to the Codex workflow yet.
- Preserved it as a candidate for a narrow, measurable A/B test if repeated development-time classification or routing becomes a bottleneck.
- Included mixed public coding-agent experiment results to emphasize that classifier speed is not the same as end-to-end task success or savings.
- No game mechanic or engine decision changed because of this research.


## v0.5 — 2026-10-16 — Core gameplay and competitive sandbox direction

- Added a design note distinguishing a long-running kingdom campaign from a balanced competitive skirmish ruleset.
- Captured the user's design principle: common systems and entity types create variety through culture, geography, stats, relationships, resources and circumstances.
- Added a starting-date research note: a 1500–1800 umbrella cannot be treated as one unchanged faction roster; the date affects which powers and relationships exist.
- Recommended discussing the minute-to-minute player loop before locking mode architecture, exact factions, start holdings or technical build scope.
- No gameplay mode, start year or release scope is locked.

## v0.6 — 2026-10-17 — Historical-pattern intake and game-format/AI pipeline proposal

- Added a preliminary historical-pattern review of the user's c. 1500–1700 story draft, with initial timeline checks, design opportunities and claims needing verification.
- Added a proposed fixed-world kingdom sandbox format: Bannerlord-like strategic map and political/party layer, Manor Lords/Anno-inspired settlement/economic simulation, and AoE-style real-time tactical battles.
- Recommended testing connected strategic, settlement and tactical views against a shared campaign state, rather than building a seamless continent or an empty skirmish map as the entire game.
- Added a stylised 3D visual benchmark proposal, staged vertical slice, current Godot/Blender baseline, Codex/Ollama local-model option, and optional MCP evaluation with safety and quality gates.
- Recorded the product format and production pipeline as PROPOSED; exact art direction, scene transitions, start date, map/faction roster and most gameplay formulas remain open.

## v0.7 — 2026-10-17 — Format confirmation and Godot skill workflow

- Recorded the high-level format as agreed: fixed date-specific campaign world, strategic map, local settlement management and real-time tactical battles sharing campaign state.
- Added Godot-native project-local Codex skills for orchestration, gameplay simulation, 3D assets, UI/UX, audio, debugging/profiling and QA/release, plus a safe installer.
- Added a validator for the seven skill manifests and safe project-local installer, with a GitHub Actions gate covering shell syntax, fresh install and no-overwrite behavior.
- Adapted the Three.js Game Skills reference's specialist routing, seeded testing, visual evidence and release-gate methodology without importing its Vite/Three.js scaffold.
- Documented model/effort selection, staged implementation, asset licence hygiene and a reusable one-milestone prompt. Corrected the stable Godot reference to 4.7.1; Blender 5.2.2 LTS was also checked on 2026-10-17.
- Exact start date, world roster, art benchmark, detailed mechanics, MCP choice and final release scope remain open.

## v0.8 — 2026-10-17 — M0 bootstrap and feature register

- Added a campaign progression/feature register covering the user's intended lord-to-king/empire path and the connected settlement, economy, political, social, military, trade, intelligence and long-session systems.
- Added M0 local setup instructions for an assigned repository folder, official tool installation checks, a Godot-root directory convention and explicit quality gates.
- Added a reference evaluation guide for the supplied Godot RTS skill/tutorial/open-source repo and guardrails for selective, licensed reuse.
- Confirmed that the entire vision is preserved while the first playable slice is deliberately smaller; new features must pass evidence-based gates before scope expands.
