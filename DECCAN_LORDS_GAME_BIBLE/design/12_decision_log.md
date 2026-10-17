# 12 — Decision log

Use one entry per meaningful decision. When a decision changes, keep the old entry and add a new one with date, reason, and affected documents. Do not erase design history silently.

| ID | Date | Topic | Status | Current record | Next action |
|---|---|---|---|---|---|
| D-001 | 2026-10-15 | Product goal | PROPOSED | PC strategy sandbox combining approachable RTS loops, settlement development, political sandbox play, and reactive NPC lords | Refine player journey and audience priorities |
| D-002 | 2026-10-15 | Setting | OPEN | 17th-century India/deep Deccan focus; exact start year and launch map scale unresolved | Pick year and first playable region after user shares desired details |
| D-003 | 2026-10-15 | Starting story | PROPOSED | Young heir to a respected but politically constrained clan inherits modest villages/town/fortifications after father’s legacy; Sultan entrusts greater power to an experienced lord | Define event, holdings, allies, rivals and first dilemma |
| D-004 | 2026-10-15 | Main engine | PROPOSED | Godot 4.x stable for the main PC game; preserve Three.js prototype as reference and selectively reuse logic | Validate with one representative scene before full migration |
| D-005 | 2026-10-15 | React/HTML prototype | PROPOSED | Do not build the complete campaign in React first; use lightweight mockups only when useful | Proceed directly to a Godot vertical slice after requirements are clearer |
| D-006 | 2026-10-15 | Simulation model | PROPOSED | Separate rendering from simulation; use controlled update cadence and data-driven systems | Define state/time model later |
| D-007 | 2026-10-15 | NPC AI | PROPOSED | Start with utility scoring/planning/tactical state machines and explainable randomness; evaluate ML only for a measured benefit | Design a sample lord decision model after core gameplay loop is described |
| D-008 | 2026-10-15 | Population | PROPOSED | Inhabited settlements; housing/household growth, labor roles, demand fulfilment, taxes and safety affect prosperity/loyalty | Decide household versus person abstraction and growth rules |
| D-009 | 2026-10-15 | Logistics | PROPOSED | Separate supply convoy may travel slower than army and be raided/intercepted | Test whether this creates fun without excessive micromanagement |
| D-010 | 2026-10-15 | Multiplayer | DEFERRED | Long-term vision for session-based players taking lord roles, alliances, votes and wars; not first implementation target | Revisit after single-player campaign loop is proven |
| D-011 | 2026-10-15 | Geographic scale | OPEN | User's long-range vision extends Delhi to Kanyakumari; detailed launch footprint and per-location simulation are undecided | Compare full-map abstraction versus regional launch |
| D-012 | 2026-10-15 | Art style | OPEN | Existing prototype is a visual reference; target is polished stylized 3D with atmospheric audio and readable battles | Build Godot art/animation benchmark scene |
| D-013 | 2026-10-16 | Game identity | OPEN | Recent discussion leans toward a real-time settlement/kingdom sandbox with political simulation and tactical battles, rather than a pure short-match RTS | Decide the primary repeated activity and match/campaign relationship |
| D-014 | 2026-10-16 | AI-assisted development workflow | PROPOSED | Private Git repository + canonical Markdown + root `AGENTS.md` + Codex VS Code extension; optional ChatGPT GitHub read integration; optional Godot MCP after validation | Establish repository and baseline workflow before implementing the game |
| D-015 | 2026-10-16 | Audience and launch strategy | OPEN | Accessible surface, deep long-session play and polished PC release are goals; Steam/Epic reach and Stardew-like success are ambitions, not assumptions | Build vertical slice, playtest, then validate positioning and demand |
| D-016 | 2026-10-16 | World scale | OPEN | Large fixed-map coverage is the intended direction; what differs by distance is simulation detail/update cost, not whether places exist in the world | Define required geographic coverage and test simulation-detail levels without presuming the world should be shrunk |
| D-017 | 2026-10-16 | World representation | PROPOSED | A large fixed, researched map is the ambition; scale variety through reusable entity/system templates with different data (culture, geography, traits, resources, relationships, rank, goals and state), rather than unique code for each location or lord. Geographic size alone is not a reason to shrink the intended world. | Design data schemas and test update/detail levels on a representative slice; keep full-map ambition explicit |
| D-018 | 2026-10-16 | Jev decision model | RESEARCH / NOT ADOPTED | Keep Jev out of runtime simulation and current Codex workflow. Consider a narrow development-tool A/B test only if repeated routing/classification is a demonstrated bottleneck. | Revisit after the basic Codex/Godot/test pipeline exists and there is a measurable candidate task |
| D-019 | 2026-10-16 | Core mode and competitive potential | OPEN | User wants repeatable, understandable, strategically fair RTS-style competition and a persistent sandbox with culture/geography/politics-driven emergent history. Recommendation under discussion: shared data-driven simulation, campaign/sandbox as the first design target, possible separately balanced competitive skirmish ruleset later. | Define the ordinary 10–15-minute player loop and start-date premise before finalizing modes or balance rules |
| D-020 | 2026-10-16 | Household/workforce model | PROPOSED (hybrid baseline approved) | User approved a hybrid baseline: households, housing, needs and population growth matter, while labour is primarily assigned by role/category rather than each individual being manually controlled. Example household sizes and upgrade tiers remain illustrative; internal representation and formulas remain OPEN. | Design one settlement's housing, needs, labour, production, tax and migration loop with readable UI and edge cases |
| D-021 | 2026-10-16 | Rank-scaled holdings and noble service | PROPOSED | Noble holdings vary with rank and circumstances; a lord need not own a town, fort and villages all at once. Appointments may combine salary, authority to administer land or collect revenue, remittance to a superior, privileges and troop/service obligations. Specific institutions and rules await period research. | Define a concrete noble appointment, revenue flow, obligations, rewards and possible revocation |
| D-022 | 2026-10-16 | Merchant, credit and market network | PROPOSED | Merchants are persistent NPCs with capital, goods, routes, relationships, debts and rivalries. Loans, repayment/default, market trade, warehouses and social links can create opportunities and consequences. No loan or price formula is locked. | Design a sample loan-and-caravan scenario and research period-appropriate practices |
| D-023 | 2026-10-16 | Army parties and recovery | PROPOSED | Small parties may move independently, merge/split into larger armies and raid/escort/intercept moving groups. People and troops recover over time at suitable safe places such as homes, camps and barracks; rates, costs and command rules remain OPEN. | Define representative recovery and party merge/split scenarios |
| D-024 | 2026-10-16 | Historical examples for NPC behavior | PROPOSED | User will provide historical observations and tactical examples to shape reusable attributes, relationships and CPU decision rules. The technical direction is explainable rules/formulas first; machine learning is not presumed necessary. Examples must distinguish research from interpretation and fictional analogy. | Capture examples as structured scenarios with actors, context, information, options and consequences |
| D-025 | 2026-10-16 | Structure of noble service/revenue arrangements | LOCKED — high-level only | Arrangements vary by kingdom/institution, rank and circumstances. A noble's relationship with a superior may combine different components such as salary, authority to administer an area, revenue collection/retention/remittance, privileges and service obligations. This locks the mix-and-match structural principle only; historical institutions, titles, rights and formulas remain OPEN. | After historical scope is selected, research the relevant institutions and model their actual differences as data using the shared system |
| D-026 | 2026-10-17 | Initial historical narrative / pattern intake | RESEARCH — PRELIMINARY | The user supplied an initial story draft for c. 1500–1700 and intends to create a larger master history for c. 1500–1800. The draft suggests useful patterns around coalition armies, shifting elite support, strategic locations, trade security, fiscal pressure, local autonomy, intelligence and leader motivation. Several chronological and causal claims need verification; the draft is evidence of the user's current interpretation, not an approved final historical account. | Use the pattern-intake document as a review aid; reconcile sources and chronology against the future master history before making broad faction/system changes |
| D-027 | 2026-10-17 | Primary game format and flow | PROPOSED — awaiting user approval | Current recommendation: fixed, date-specific authored world that evolves as an alternate history; connected strategic-map, local settlement and real-time tactical battle views; settlement/economy inspired by Manor Lords/Anno, political/party simulation inspired by Bannerlord, and readable RTS combat inspired by AoE. A later balanced skirmish mode remains possible, not a v1 commitment. | User to confirm campaign format and scene flow; validate with a representative vertical slice before locking architecture |
| D-028 | 2026-10-17 | AI-assisted local production pipeline | PROPOSED | Use Godot stable + Blender LTS + Git/GitHub + a local Codex workflow as the base. Evaluate Ollama in Codex mode for selected low-risk tasks; consider a Godot MCP only after the project build/test loop works. Keep permissions scoped and changes reviewable. Re-check versions/integrations at setup. | Prove project import/export, headless tests, one asset pipeline and local-model workflow; then decide whether MCP is useful
| D-029 | 2026-10-17 | Primary game format | LOCKED — high-level format only | User accepted a fixed, date-specific kingdom campaign world that evolves through player/CPU decisions, with strategic-map play, local settlement management and real-time tactical battles writing to shared persistent state. The game's identity combines AoE-like readable RTS control, Manor Lords/Anno-like settlement/economic systems and Bannerlord-like lords/parties/political freedom. Exact date, roster, map boundaries, view implementation, detailed mechanics, art style and v1 scope remain OPEN/PROPOSED. | Implement a small technical/visual benchmark and phased vertical slice; do not lock detail architecture beyond what tests establish
| D-030 | 2026-10-17 | Codex specialist-skill workflow | PROPOSED | Create a Godot-native local skill suite with a director that routes a milestone to gameplay, art, UI, audio, debug/profiler and QA specialists. Borrow workflow/testing/evidence principles from the public Three.js Game Skills repository without its Vite/Three.js scaffold. Use project-local skills, one milestone per prompt and explicit quality evidence. | Install in the actual Godot game project after it exists; validate skill discovery and the full prompt/test loop with the first benchmark
| D-031 | 2026-10-17 | Full campaign progression and feature inventory | PROPOSED / OPEN | The intended career starts as a scenario-appropriate lord/clan heir and may grow through service, court influence, war leadership, allegiance change, kingdom founding and possible imperial power if the selected political rules support it. Long-term systems also include family/clans/companions, delegated holdings, settlement/economy/trade/credit, armies/RTS battles/sieges, logistics and intelligence. The dedicated feature register preserves the vision without committing all items to v1. | Use the feature register to scope milestones; use the master history and playable tests to decide priority and precise rules |
| D-033 | 2026-10-17 | Historical treatment | LOCKED — high-level direction | Fictional alternate-history game inspired by the Deccan and neighbouring powers, not a strict historical reenactment. There is no requirement to include Shivaji, Maratha history or real historical biographies. Fictional kingdoms, dynasties, clans and characters may coexist with broadly inspired empires such as a Mughal-style power. Names, faction count, date and map boundaries remain OPEN. Historical research is selective and supports plausibility/atmosphere rather than delaying the core RTS prototype. | Build a coherent fictional faction roster and regional map; label invention clearly and research only where it improves gameplay or visual credibility |
| D-034 | 2026-10-17 | Main campaign map generation | LOCKED — high-level direction | Main campaign uses an authored, persistent strategic world with named cities, villages, forts, roads, rivers, terrain, factions, characters and relationships represented as data. Begin with a compact fixed region and expand it over milestones. Fully random maps are not the campaign foundation; optional skirmish map generation may be explored later. Exact boundaries, locations and map scale remain OPEN. | Implement a small fixed-region data model and benchmark before populating the full intended world |
| D-035 | 2026-10-17 | M1 visual and control benchmark | PROPOSED — benchmark only | User chose a compact 3D benchmark combining historically grounded forms with stylized readability, original work and suitable licensed assets. The scene should test movement/selection, camera, basic light and restrained ambience; this exploration does not lock the final visual direction or asset pipeline. | Review the playable M1 scene before deciding whether to refine it or compare a different look |
| D-032 | 2026-10-17 | External Godot RTS references | RESEARCH — not adopted | User provided a Godot RTS genre skill, a 3D RTS tutorial thread and an open-source Godot RTS repo. Treat these as learning/audit sources; check current version, licence, maintenance, security and scope before reuse. Don't adopt dependencies or merge whole projects without review. | Inspect each reference against the active milestone and document any isolated, tested technique worth adapting |
| D-036 | 2026-10-17 | Gameplay-first production and world atmosphere | PROPOSED — sequencing preference | User wants the core game loops established before a broad cinematic/cosmetic art pass. Day/night, changing weather and varied terrain are desired later world features; their gameplay effects and implementation are still open. This preference does not lock a final art direction or system design. | Prove the next bounded gameplay loops; design weather, time-of-day and terrain effects with the world/campaign systems |
| D-037 | 2026-10-17 | M3 settlement/economy prototype | IMPLEMENTED PROTOTYPE — tuning not locked | Built a fictional single settlement with aggregate household groups, pooled labour, farm/woodcut/mill activities, finite storage and market inventories, grain consumption, taxes/upkeep, priority notices and versioned save/load. Every starting quantity, yield, price, tax/upkeep formula and the Keshavwadi name are temporary implementation tuning, not historical claims or approved final rules. | Review the playable M3 loop and decide which economy relationships need revision before a campaign map connects to it |
| D-038 | 2026-10-17 | M4 strategic campaign prototype | IMPLEMENTED PROTOTYPE — tuning not locked | Built a compact fictional authored region with four named locations, travel graph, a player party, superior obligation/standing, persistent merchant, explainable escorted-grain decision and versioned campaign save containing the same M3 settlement state. Contract amounts, route time and relationship effect remain temporary tuning. | Review the campaign slice; M5 should connect a campaign encounter to the existing tactical battle and return persistent consequences |

## Change log

### v0.1 — 2026-10-15
Captured the user's expanded vision and key open questions. No detailed formulas, exact content counts, release scope or historical faction roster have been locked by this file.


### v0.2 discussion sync — 2026-10-16

- Added the current genre/audience hypothesis without locking the final label or modes.
- Recorded that the AI-assisted development story shared by the user is a workflow idea to evaluate, not a proven recipe for AAA quality or guaranteed commercial success.
- No release scope, mode list, exact region, formulas or sales targets are locked by this update.

### v0.4 — 2026-10-16 — Jev harness research

- Added a technical assessment of Jev as a structured decision model for narrow questions.
- Decided not to adopt it for runtime game AI or the current Codex workflow.
- Recorded a possible future A/B experiment if repeated classification/routing overhead becomes a measurable bottleneck.
- This is a provisional tooling decision based on currently available evidence; it does not reject Jev for all future use cases.

### v0.3 — 2026-10-16 — Fixed-world and reusable-system clarification

- Clarified the ambition for a large fixed map spanning major locations from Delhi toward Kanyakumari.
- Recorded the user's analogy: repeated underlying entities and logic can create variety through different data, culture, geography, resources, traits, relationships and circumstances.
- Reframed scale risk around simulation detail, content and performance validation rather than treating geographic breadth as an automatic reason to cut the map.
- Kept exact geography, historical roster, detail level and implementation details open; this clarification does not authorize inventing missing specifics.


### v0.5 — 2026-10-16 — Core gameplay and competitive/sandbox fork

- Added a dedicated design note distinguishing a living kingdom campaign from a competitive RTS/skirmish ruleset.
- Recorded the working recommendation to use shared simulation foundations, but not assume identical pacing/progression/victory rules across modes.
- Added historically grounded date-window questions: the chosen start year affects which factions, political relationships and foreign presences are plausible.
- No mode, start date, full faction roster, map footprint, or release scope has been locked.

### v0.6 — 2026-10-16 — Connected economy and social simulation

- Recorded the user's approval of the hybrid household/workforce model as the working baseline, while leaving exact capacities and formulas open.
- Added rank-scaled noble holdings and candidate salary/revenue/remittance/service arrangements.
- Added a dedicated cross-system design document for merchants, loans, trade relationships, production investments, warehouses, markets, mobile parties, troop recovery and explainable NPC behavior.
- Added questions for credit, revenue rights, production, goods flows, recovery, party coordination and NPC information/retaliation.
- No specific formula, title, historical institution, resource roster, loan term or implementation scope has been locked.

### v0.7 — 2026-10-16 — Noble-service structure agreed at high level

- Recorded the user's choice that noble-service and revenue arrangements vary by kingdom, rank and circumstances and can combine multiple components.
- Marked only this structural principle as LOCKED. Specific historical titles, legal rights, percentages, obligations and formulas remain OPEN pending period selection and research.

### v0.8 — 2026-10-17 — Preliminary history-pattern intake

- Added an analysis companion for the user's first central Deccan/South/North India history draft.
- Separated user observations, design hypotheses and factual claims needing verification; added preliminary chronological corrections and source starting points.
- Preserved the master-history workflow: defer broad historical-specific redesign until the user's longer c. 1500–1800 document is available.

### v0.9 — 2026-10-17 — Game-format and production-pipeline proposal

- Added a recommended hybrid format: fixed, date-specific world; connected strategic, settlement and tactical views; emergent campaign with RTS battles.
- Added a proposed stylised 3D benchmark and staged vertical slice, with competitive skirmish and other high-cost features not assumed in the first release.
- Documented a Godot/Blender/Codex/local-model workflow, optional MCP evaluation, quality gates and the difference between browser ChatGPT and a locally authorised coding agent.
- Recorded the game-format/flow as PROPOSED pending user approval; art direction and exact view transitions remain open. Historical start date and faction roster remain open pending the master history.

### v1.0 — 2026-10-17 — Local Codex/Ollama workflow clarified

- Added the documented option to use compatible local Ollama models in ChatGPT Desktop's Codex mode, distinct from ordinary ChatGPT chat and Codex native models.
- Recommended a stable Godot/Blender LTS baseline, a minimal import/test loop first, and one optional Godot MCP only after the first project runs.
- Kept toolchain and integration choices PROPOSED pending setup and measurement; no MCP server is assumed installed or mandatory.

### v1.1 — 2026-10-17 — High-level game format confirmed; specialist workflow added

- Recorded the user's approval of the fixed-world kingdom campaign with strategic map, local settlement management and real-time tactical battle views sharing persistent campaign state.
- Kept campaign date, faction roster, detailed mechanics, visual benchmark and first-release scope open.
- Added a Godot-native director/specialist skill suite and project-local installer inspired by the workflow/evidence practices of the Three.js Game Skills reference, without importing its browser scaffold.
- Added model/effort tiers, token-saving habits, a one-milestone prompt template and evidence-based QA guidance.
- Corrected the setup baseline to Godot 4.7.1 stable and Blender 5.2.2 LTS as checked on 2026-10-17; recheck releases at install time.

### v1.2 — 2026-10-17 — Campaign progression register and local bootstrap

- Added a dedicated long-term feature register for lord-to-king/empire progression, delegation, clan/companions, economic systems, military, politics, intelligence and long-session playability.
- Added a local M0 bootstrap prompt and industry-style project organisation/data/simulation boundaries.
- Added an evaluation guide for the user's external Godot RTS skill, tutorial series and open-source repository; reuse remains conditional on licence, maintenance, compatibility and tests.
- Clarified that the full vision is preserved but only a tested, bounded vertical slice enters the early milestones.

### v1.3 — 2026-10-17 — Fictional alternate-history and fixed campaign map

- Clarified that the world is a fictional alternate-history Deccan setting rather than a strict historical reenactment; real historical figures and the Maratha/Shivaji story are not required.
- Confirmed an authored, persistent strategic campaign map as the high-level direction, starting from a compact region and expanding through data-driven locations/factions/relationships. Random map generation remains a possible later skirmish option.
- Kept faction count/names, chronology, exact map boundaries and the detailed historical roster open for later design.

### v1.4 — 2026-10-17 — Gameplay-first sequence and M2 battle prototype

- Recorded the user's current preference to prove core loops before a broad cinematic/cosmetic pass.
- Preserved day/night, changing weather and varied terrain as desired future world features, with exact rules/effects still open.
- Marked the M2 unit-role values and match setup as prototype tuning rather than final balance or historical rules.

### v1.5 — 2026-10-17 — M3 settlement/economy prototype

- Added a playable one-settlement loop for pooled labour, three production activities, goods storage, finite market exchange, household grain consumption, taxes/upkeep and priority notices.
- Recorded every prototype name, initial holding, formula and price in a separate implementation note; none is promoted to a locked historical or design rule.
- Added versioned JSON save/load and checks for accounting, constraints, malformed data and the actual scene interaction at two window sizes.
- Kept weather, day/night, varied terrain, household welfare, dynamic prices and campaign/battle integration in later design scope.

### v1.6 — 2026-10-17 — M4 strategic campaign prototype

- Added a compact authored route map with four fictional locations, a moving player party, one superior obligation, persistent merchant and escorted grain delivery.
- Campaign time now advances the same M3 settlement instance; a single versioned save stores campaign and settlement state together.
- Logged the merchant's choice from information available at Nandipur and made goods, treasury and standing consequences observable.
- Documented all M4 names, figures, timing and outcome as temporary prototype content; the M5 tactical-battle connection remains next.
