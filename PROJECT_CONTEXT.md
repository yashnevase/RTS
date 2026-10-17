# DECCAN LORDS — Project Context for ChatGPT / Codex

**Last updated:** 2026-10-17 (campaign progression register, external RTS references and M0 setup instructions)
**Phase:** Vision discovery and technology validation. No full production implementation authorized yet.

## The user's end goal
Create a polished, atmospheric, stylized 3D PC strategy game set in historical/alternate-history India, with a strong Deccan focus. The dream is to recover the feeling of playing Age of Empires, Rise of Nations, Anno, Bannerlord, Stronghold/Manor Lords, and some accessible progression appeal observed in Clash of Clans—but not simply clone any one of them.

The user values:
- Beautiful, readable landscapes, settlements and battlefields; smooth unit animation, satisfying effects and combat feedback, atmospheric sound/music, and professional UI/controls.
- Peaceful long-session settlement and economic development.
- Tactical action, armies, raids, sieges, territory and military logistics.
- Political freedom: serve a superior ruler, expand local authority, become a mercenary or outlaw, create a kingdom, or pursue greater power.
- Reactive NPC lords whose different stats, personalities, goals, relationships, geography, resources and recent events produce credible but not completely predictable behavior.
- Accessible early gameplay with depth available gradually; avoid overwhelming newcomers.
- A single-player CPU campaign first. Cooperative/competitive multiplayer is a future ambition, not an approved v1 requirement.
- Development with AI coding tools, using one ChatGPT Plus subscription as a limited resource plus a local model for suitable low-risk tasks.
- Potential release as a downloadable Windows PC game, with Steam and Epic Games Store considered. Success is a goal, not a guarantee.

## Current product identity hypothesis — NOT LOCKED
Current descriptions lean more toward a **real-time kingdom/settlement sandbox with political simulation and tactical battles** than a pure short-match Age of Empires-style RTS. Anno/Manor Lords-like development and Bannerlord-like emergent politics appear central; AoE-like military clarity/action can be an important layer. Whether the game later has a separate balanced skirmish/competitive mode is open.

Do not market or code it as a pure RTS without revisiting this distinction with the user.

## Opening premise — proposed, not locked
The player is a young heir to a once-influential Deccan clan. Their father was a respected noble/warlord who served major rulers, built allies and rivals, and held greater responsibility. A succession or political transition leaves the player with a modest ancestral base—potentially several villages, a market town, fortifications, some clan properties and a small force—while the current Sultan entrusts a more experienced lord with the father's former authority. Old allies may help; rivals may try to erase the clan's influence. The player may prove worth, negotiate, change allegiance, become a mercenary/outlaw, rebel, build an independent kingdom or pursue sovereignty.

The exact year, father's fate, start location, holdings, cast, initial crisis and opening sequence remain open.

## World and settlement concepts raised by the user — proposals/open
- **Large fixed-map intent:** the user's ambition is researched/hand-authored strategic geography spanning major locations from Delhi toward Kanyakumari, with historic cities, towns, villages, forts, ports, roads, rivers, passes and regional terrain. Do not assume the world must be shrunk merely because the geographic extent is large.
- **Shared engine, varied data:** the world is not intended to be procedurally randomized geography. Reusable entity types and systems represent lords, factions, households, settlements, armies, parties, forts and trade posts. Unique outcomes emerge from different combinations of culture, traits, resources, geography, population, relationships, rank, ambitions, army composition, supply and events. Avoid bespoke code for every named entity.
- The engineering question is how detailed and frequently updated each entity must be, not whether a wide fixed map is automatically impossible. Prototype and profile representative gameplay before choosing simulation-detail levels; do not use that decision as a pretext to shrink the world prematurely.
- Settlements already contain families/households. Housing may progress from huts to houses/wadas and raise population capacity and the kinds/number of families attracted.
- Households have escalating needs; satisfying needs, security and fair governance can improve prosperity/loyalty/migration, while neglect and excessive taxes may cause unrest or flight.
- Families/workforce can be assigned to farming, crafting, trade, military support and other roles. **The user has approved a hybrid household/workforce model as the working baseline**: households and housing matter, but the player assigns labour by role/category rather than manually controlling every individual. Exact housing capacities, needs and formulas remain open.
- Suitable production facilities should depend on local terrain, soil, water, weather/season, forest or mineral resources, labour, routes and market access. Production chains, warehouses, stock security, buying/selling and caravans should create connected goods flows with manageable detail inspired by Anno.
- Prosperity and suitable housing may attract new families, while existing households may request better housing or services. Growth increases labour and revenue but also raises consumption and other demands.
- Merchants/traders are persistent NPCs with capital, inventories, routes, friends, rivals, creditors/debtors and relationships with nobles. They may offer loans and contracts; trust, repayment/default and social connections affect opportunities and consequences. Exact finance rules remain open.
- Noble appointments may combine salary, authority to administer/collect revenue from assigned land, a remittance to a superior, privileges and military/service obligations. A ruler's policy may change the arrangement. These are candidate mechanics, not a finalized historical/legal model.
- Small parties, caravans and armies move on the strategic map. Parties may combine or split; raids can transfer goods and provoke informed or uncertain retaliation. Civilians and troops recover over time in suitable safe locations such as homes, camps or barracks; facility upgrades may improve recovery. Rates and exact rules remain open.
- Fortifications may be adapted to local geography; hill forts and walled towns offer different defensive strengths and supply limits.
- Siege play may involve food, weapons, gunpowder, artillery, encampments, relief forces, supply convoys, raids/interception and possible recovery/capture of supplies.
- Separate caravans/supply parties can carry goods, equipment, livestock or siege supplies. Carrying large loads can slow movement and increase risk; details remain open.
- Production, population, trade, treasury, manpower and military strength form connected flows. War loot transfers assets from the defeated party; casualties, damage, disrupted routes and lost goods can weaken the victim, while growth and recovery still follow explicit rules.
- Raids, captives, looting and civilian harm raise tone, historical, ethical, balance and age-rating questions that should be discussed explicitly. Do not implement these mechanics without a deliberate design decision.
- Lords, factions, nobles, companions, rulers and foreign powers need differentiated goals, relationships, resources and authority. Use historical research for the real context but leave room for alternate history.

## AI/algorithm direction — hypothesis
Start with explainable decision systems rather than adding ML for its own sake. Potential layers: utility scoring for selecting goals/actions; planner (e.g. GOAP/hierarchical tasks) for multi-step goals; tactical behavior trees/state machines/scoring for battles. Shared logic plus different data, personality, information, geography and opportunity should make lords feel distinct. Weighted or seeded randomness adds uncertainty without replacing causality. Evaluate ML only for a narrowly defined problem where it measurably improves play. Multiplayer fairness and reproducibility create extra constraints later.

## Jev / decision-model assessment — RESEARCH, NOT ADOPTED

The user shared LangChain's “Building a Harness with Jev” article. Jev is a hosted decision model for structured yes/no, choice and score outputs. It could be tested for narrow development tasks (routing, log/test-trace categorization or evaluation), but it is not a code-writing agent or a game-simulation engine.

Do not put Jev into runtime CPU AI. Use explicit, testable simulation algorithms for lords and armies. Do not add Jev to Codex workflow by default; its LangChain middleware does not plug directly into Codex without extra integration and a separate TypeSafe API key. Vendor speed/cost maxima are task-specific. One public coding-agent filter experiment showed an earlier promising result but its later 49-pair TB4 follow-up did not show an end-to-end benefit. Only reconsider Jev after a controlled A/B test proves net savings without lower task quality.

Full research note: `DECCAN_LORDS_GAME_BIBLE/references/15_jev_harness_research.md`.

## Technology direction — proposed
- Proposed primary engine: Godot stable 4.x, with GDScript; validate with a polished representative scene before full-scale production.
- Existing Three.js prototype is valuable reference material. Inspect and selectively reuse/port movement, combat, pathfinding, resource logic, visual references and UI ideas. Do not throw it away before review.
- Avoid building the full campaign in React/HTML and then rebuilding it in Godot.
- Likely tools: Git/GitHub, VS Code + Codex IDE extension signed into the user's ChatGPT account, Godot, Blender, one optional Godot MCP server after need/compatibility/safety checks, and a local LLM runtime for suitable repetitive work.
- User's dev machine plan: Mac M4, 16 GB unified memory. The intended release target is primarily Windows PC, with a possible macOS build later. Minimum game PC and performance targets are still open.
- Codex and ChatGPT Plus usage is limited and changes by plan/task/model. Use local models for suitable support work, but retain strong-model review for architecture and complex integration; no tool pipeline guarantees AAA quality.

## What the user wants from the collaboration
Have a long, iterative design conversation. The user will share game details in small pieces, including personal observations and historical/local knowledge. Assistant should listen, ask only useful questions, propose alternatives and trade-offs, challenge scope or technical assumptions respectfully, and then record agreed decisions in the living Game Bible. Do not rush to finalize the entire game or replace the user's ideas with a prebuilt design.

## Canonical files
- Main source of truth: `DECCAN_LORDS_GAME_BIBLE/design/*.md` and its `design/12_decision_log.md`.
- `DECCAN_LORDS_GAME_BIBLE/design/11_open_questions.md` keeps unresolved questions.
- `DECCAN_LORDS_GAME_BIBLE/README.md` explains labels and document structure.
- `DECCAN_LORDS_GAME_BIBLE/exports/` contains v0.1 snapshots, not authoritative if Markdown changes.
- `AGENTS.md` describes how coding agents must work.

## Current game-format direction — LOCKED at high level
The user approved a fixed, date-specific, researched strategic world that evolves through player/CPU decisions, connected settlement/economic simulation, moving parties/lords and real-time tactical battles. The high-level flow uses strategic-map, local-settlement and tactical-battle views over the same persistent state; details should be validated in a prototype rather than attempting a seamless continent at the start. A later competitive skirmish mode remains possible but is not a first-release commitment. Stylised readable 3D with a three-quarter/isometric-like camera remains an art-direction recommendation to test, not yet LOCKED. See `DECCAN_LORDS_GAME_BIBLE/design/18_game_format_and_ai_production_pipeline.md`.

## Codex skills and stepwise execution

The `skills/` folder contains a Godot-native project-local suite: director, gameplay simulation, visual assets, UI/UX, audio feedback, debugging/profiling and QA/release. `scripts/install_deccan_lords_skills.sh` copies them into `.agents/skills/` once an actual Godot project exists. The suite adapts workflow/evidence patterns from the Three.js Game Skills reference without its browser scaffold. The production pipeline document defines model/effort tiers, a one-milestone prompt template and QA evidence expectations. The actual Godot project has not yet been initialized, and the installer has not yet been run against a real project.

## Historical analysis and next design step
The user supplied a preliminary historical story draft (mostly c. 1500–1700). `DECCAN_LORDS_GAME_BIBLE/design/17_historical_pattern_intake_story_draft_01.md` records the source-based reading, initial chronology checks, design opportunities and claims needing further research. The user intends to prepare a broader master history around c. 1500–1800. Read that master document fully when supplied, then reconcile its timeline and actor relationships against credible sources before making a broad history-driven rewrite of faction profiles, NPC attributes, political institutions or system formulas. In parallel, use the game-format document to guide a small visual/technical benchmark; do not begin a huge content build. Keep the start date, map, art direction and specific formulas open until discussed. Do not turn the user's interpretations into verified history or final game rules without discussion.

## Next local execution step

The user will open this repository in a dedicated local Codex workspace with suitable permissions. Start with [M0_BOOTSTRAP_PROMPT.md](M0_BOOTSTRAP_PROMPT.md): inspect current files and tools; install official stable Godot and Blender only if missing; treat Ollama as optional until the engine/asset smoke test works; create/validate `project.godot` at repository root; install the project skills; run the headless/import checks; stop and report M0 before starting M1. Do not assume browser ChatGPT itself can install software or access the Mac.

The expanded progression inventory is in `DECCAN_LORDS_GAME_BIBLE/design/19_feature_register_and_campaign_progression.md`. The user’s long-term vision includes a lord-to-king/empire career, family/clan/companions and delegated administration, settlement development, production/warehouse/trade/credit, political relations, parties/armies, wages/patrols/fortifications, RTS battles/sieges, and intelligence/events. These are preserved as proposed long-term features, not all promised for the first playable slice.


## Historical direction and campaign-map decision (2026-10-17)

DECCAN LORDS is a fictional alternate-history game inspired by the Deccan and neighbouring powers, not a strict reenactment. No real historical hero or specific Maratha/Shivaji storyline is required. Fictional Deccan kingdoms, clans, rulers and characters may be paired with broadly inspired imperial powers, including a Mughal-style empire. Historical research should be selective—used for geography, architecture, economy, logistics and plausibility when it helps the game—not a prerequisite to starting the RTS prototype.

The main campaign should use an authored persistent strategic map, with cities, villages, forts, terrain, roads, rivers, factions, characters and relationships stored as data. Start with one compact fixed region, then expand it in stages. This is more aligned with the campaign/political sandbox than designing the game around random maps. Random maps may be considered later for a separate skirmish mode. Exact region size, settlement count, faction count and roster remain open.
