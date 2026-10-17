# 19 — External RTS references, code reuse, campaign progression and fun gates

**Status:** RESEARCHED GUIDANCE / DESIGN PROPOSALS  
**Reviewed:** 2026-10-17

## Executive conclusion

Use the three references as targeted learning and implementation guides, not as a ready-made finished game. The game remains a fixed, date-specific campaign world with settlement/economy, moving lords and parties, political choices and real-time tactical battles over shared state.

1. **TheDivergentAI's Godot genre RTS skill** is a catalogue of RTS concerns and performance anti-patterns: selection, commands, group movement/formations, pathfinding budgets, command queues and scaling rendering.
2. **The Godot Forum / gameidea tutorial series** is a step-by-step learning sequence for camera, raycasting, navigation, unit states, selection, formations, buildings, resources, building placement and a minimap.
3. **Lampe Games' Open RTS** is a real open-source Godot RTS codebase with sample match setup, reusable scenes/resources, unit logic, fog-of-war and manual-test examples. Its README describes a deliberately simple deathmatch-style RTS with a small unit/resource set, and it targets Godot 4.3; it is not a persistent kingdom campaign.

These sources support the Godot direction. They do not implement DECCAN LORDS' historical map, population/households, trade networks, lord appointments, political succession, independent kingdoms, companions or persistent campaign-to-battle consequences.

## 1. Reference review

### A. TheDivergentAI — Godot genre RTS skill

- Skill page: https://atskills.one/thedivergentai/godot-genre-rts
- Source file: https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/godot-genre-rts/SKILL.md
- Parent repository: https://github.com/thedivergentai/Game-Dev-Agentic-Skills
- The parent repository states that the skill library is licensed LGPL-3.0. We currently reference and summarise techniques rather than copying the upstream library into this project. Before copying skill files or scripts, review the licence and preserve required notices/terms.

**Ideas worth adapting:**
- Maintain an authoritative, typed selection set instead of relying only on which visible scene nodes happen to be selected.
- Treat inputs as explicit, validated commands: select, move, attack, hold, interact, gather, build or retreat. A serializable command representation can later support save/replay and diagnostics.
- Use clear unit states rather than contradictory booleans scattered across scripts.
- For group movement, compare a group-centre/leader path with per-unit formation slots against individual path queries.
- Prevent pathfinding jitter and endlessly stuck units; handle unreachable targets, timeouts, visible failure feedback and regression tests.
- Stagger expensive path requests and measure avoidance cost rather than recalculating every unit's route every frame.
- If profiling shows a large crowd is limited by node/render/path cost, investigate batching, MultiMesh and squad-level navigation.

**Adapt carefully:**
- The blueprint includes 2D-specific guidance such as NavigationAgent2D, TileMapLayer fog clearing and grid helpers. Those are not drop-in solutions for our 3D plateau/settlement world. Use 3D selection/raycasting and NavigationAgent3D/NavigationServer3D where appropriate, and follow the official docs for the pinned Godot release.
- Suggested unit-count thresholds are heuristics, not guarantees for our Mac. Measure DECCAN LORDS with its own models, animation, effects, navigation and AI.
- Threading and RenderingServer/NavigationServer operations have API and thread-safety constraints. Do not manipulate scene nodes on worker threads just because an external skill suggests threading; keep worker tasks data-only unless the official API explicitly permits more.
- Hard requirements such as fog of war, grid building placement or resource gathering apply only when the current milestone needs them. The player campaign should not inherit features merely because an RTS template includes them.

### B. Godot Forum / gameidea — 3D RTS tutorial series

- Forum introduction: https://forum.godotengine.org/t/3d-rts-tutorial-series-for-godot/94795
- Tutorial index: https://gameidea.org/2024/12/13/how-to-make-an-rts-game-in-godot/

The series covers camera, procedural terrain, raycast picking, built-in navigation, a custom AStar3D graph, unit movement and states, health/combat, selection boxes, marching formations, structures, resource storage, workers, building placement and a minimap.

**How to use it:** consult one article when a milestone needs that specific technique. Have Codex compare the article with the current Godot API, implement a small adaptation in our existing project, and test it in our real scene. The article is a learning reference, not a complete downloadable game.

**Important differences:** the tutorial includes procedural terrain, but DECCAN LORDS intends a fixed, researched/hand-authored strategic geography. Procedural scenery may be useful for experiments, but must not replace the historical map. The author also describes limitations with dynamic avoidance. Assets linked from tutorials have different licences and must be checked individually.

### C. Lampe Games — Open RTS

- Repository: https://github.com/lampe-games/godot-open-rts
- README: https://github.com/lampe-games/godot-open-rts/blob/main/README.md
- Source structure: https://github.com/lampe-games/godot-open-rts/tree/main/source
- Manual tests: https://github.com/lampe-games/godot-open-rts/tree/main/tests/manual
- Makefile checks/exports: https://github.com/lampe-games/godot-open-rts/blob/main/makefile
- License: https://github.com/lampe-games/godot-open-rts/blob/main/LICENSE

**What inspection found:** its code is divided into data-model, generic scene/node, menu, match, resource, shader and utility areas. It includes match settings, players, units/structures, map/navigation, visibility and manual test examples. The Makefile documents formatting, linting, complexity checks and platform export targets. This is useful evidence for code organization and repeatable developer commands.

The software LICENSE is MIT. The README credits Kenney's 3D Space Kit. LOGO_LICENSES.md states that the Godot logo is CC-BY-4.0 and that the Lampe Games logo is all rights reserved and must not be reused in derived projects. Code and bundled assets have separate rights; check each asset before using it.

**Recommendation:** do not wholesale fork Open RTS as our product foundation. It is a compact deathmatch RTS, not a world/settlement/political simulation, and its documented baseline is Godot 4.3. Instead, inspect a specific subsystem only when our milestone needs it, and port or rewrite the smallest appropriate part after:
1. reading its implementation and available tests;
2. checking compatibility with our pinned Godot version;
3. identifying assumptions tied to its sample architecture;
4. preserving applicable MIT notices and checking bundled-asset licences;
5. adding our own tests and credit/license records; and
6. verifying that it fits our data model without adding unnecessary dependencies.

## 2. Apply references by milestone

| Milestone | Reference material | DECCAN LORDS outcome and gate |
|---|---|---|
| M0 — setup | Godot official docs; Open RTS project/Makefile conventions | Pin stable Godot, Git setup, project import/headless smoke test and readable folder rules |
| M1 — camera and input | Tutorial camera/raycast articles; RTS skill selection guidance | Camera, picking the terrain, selection box, select/deselect, visible selection feedback and basic movement |
| M2 — units and battle | Tutorial movement/state/health/combat/formations; RTS command queue and navigation guidance | Responsive move/attack/hold commands, formation spacing, valid targets, no stuck loops, basic CPU opponent and repeatable battles |
| M3 — settlement | Tutorial buildings/resources/stockpile/placement; Open RTS data/resource conventions | Household/workforce aggregate, 2–3 suitable production activities, warehouse, accounting, build validation and save/load |
| M4 — campaign | The canonical Game Bible | Fixed-map locations, moving parties, one merchant and lord relationship, obligations, goals and imperfect information |
| M5 — integration | Our Game Bible plus individually tested components | Campaign encounter enters tactical combat; losses/rewards update the same persistent campaign state |
| M6+ — scale/polish | RTS skill performance concepts, official Godot docs, Open RTS checks as examples | Stress scenes, measured navigation/render/simulation cost, multi-unit responsiveness, UI/audio/visual polish and regressions |

Do not add fog-of-war, minimap, grid building placement, custom navigation graphs or a new framework unless the approved design or a measured prototype needs it.

## 3. Campaign growth fantasy to preserve

The following records the user's intended long-term player progression. It does not yet lock historical names, start date, formulas, quest lists, money amounts or a first-release promise for every branch.

1. **Start as an inherited local lord.** The opening baseline is one modest inherited fortress/stronghold and one or more villages. A town/market centre and additional forts vary by starting scenario and rank; the exact count remains open until the date/state is selected.
2. **Choose a political posture.** Serve the current/native superior, negotiate terms, or eventually seek service under another power. Small favours, protection, trade, military aid or court tasks can build trust/reputation where they make sense in the chosen context.
3. **Grow into a more influential lord.** Competence, relationships, resources, military contribution and recognition may open greater responsibilities, revenue rights, privileges or court influence. This is not one universal XP ladder that overrides faction institutions.
4. **Choose different endgames.** Stay an effective vassal/general; become a regional power or kingmaker; support a claimant or another ruler; change allegiance; claim or found a kingdom; or pursue higher imperial authority where the campaign institutions permit it. Mercenary/outlaw paths are alternatives when scoped and designed.
5. **Delegate instead of micro-managing every holding.** Skilled companions or trusted nobles may administer a settlement/region, lead a patrol or party, protect caravans, recruit/train forces, or command troops. Skills, wages, goals, loyalty, relationships and granted authority change results. Delegation automates routine work while the player retains control of priorities and policy.
6. **Build a durable organisation.** Longer-term features include companion-led parties, family/clan networks, retinues, garrisons, patrols, field armies, recruitment/training, wages/supply, recovery at safe locations, construction/repair of villages, towns, walls and forts, trade/caravans, merchant credit, treaties and rivalries. Deliver these in tested slices.
7. **Let success create new responsibilities.** More territory and people mean more protection, logistics, administration, political obligations and rivals. More income alone should not make a realm permanently stable.

The goal is not to script every life path. Reusable actors, appointments, holdings, relationships and event rules should allow different histories to emerge.

## 4. Protect moment-to-moment RTS feel and long-term fun

A deep simulation becomes tedious if every action feels like admin work. Every milestone must protect the feel of play as well as technical correctness.

### Immediate control
- Selection and commands feel responsive; the player sees acknowledgement for move, attack, hold, retreat and formation orders.
- Units move intentionally, keep useful formation spacing and do not twitch endlessly at corners. Invalid/unreachable orders resolve visibly.
- Combat communicates impact through animation, sound, effects, morale/rout feedback and clear outcomes. Polish is part of the product, not a final cosmetic afterthought.

### Meaningful short loops
- Every few minutes, the player should see a result or decision: resolve a shortage, finish construction, secure a route, intercept a threat, improve housing, fulfil an obligation, train troops, get a trade opportunity, or change a battle's outcome.
- Notifications are prioritised and actionable; routine ticks are grouped rather than spamming the player.
- Show costs, risks and likely consequences. NPCs can surprise the player, but should not seem to use invisible rules.

### Long campaign retention
- Mix peaceful planning with credible threats and opportunities, not constant forced war or constant chores.
- Maintain short-term needs, medium-term projects and long-term political ambitions. Allow the player to delegate routine work when safe.
- Let geography, traits, relationships, resources, timing and imperfect information create new situations using common rules.
- Wars, debts, promises, losses and recovery leave memories in the world. A raid can change route safety and relations; a fort may secure multiple villages; a successful commander can gain influence and become harder to control.
- Test economic exploits and runaway loops. Clever strategies are welcome, but no single repeatable trick should make every other choice irrelevant.

### Evidence of fun
Automated tests prove correctness, not that humans enjoy the game. At each playable gate require repeatable scenario/bot tests, a running scene and captured evidence. After M2 and again after integrated M5, conduct real human play sessions and note confusion, slow feedback, pointless chores, unfair surprises and satisfying decisions. Perform at least one tuning iteration before expanding scope.

## 5. Access, assets and code safety

- The user wants the agent to install needed tools and work in an assigned folder. Provide project-folder and necessary app access; do not grant unrelated access to personal files, credentials, browser profiles or system settings.
- Install free prerequisites from official sources when needed for the approved milestone. Ask before paid services, API accounts, purchases, destructive actions outside the project, security/privacy changes, credential handling or uploading private files to third parties.
- Do not add MCP before the baseline project imports, runs and tests reliably. Add one only if it measurably improves the workflow.
- Do not rip art/music/models from commercial games. Prefer CC0 or clearly licensed assets and maintain CREDITS_AND_LICENSES.md with source, creator, licence, attribution, download date and modifications.
- A private repository does not remove licence obligations if the game later ships.

## 6. Sources

- TheDivergentAI RTS skill: https://atskills.one/thedivergentai/godot-genre-rts
- Parent skill repository/license: https://github.com/thedivergentai/Game-Dev-Agentic-Skills and https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/LICENSE
- Godot Forum tutorial thread: https://forum.godotengine.org/t/3d-rts-tutorial-series-for-godot/94795
- gameidea tutorial index: https://gameidea.org/2024/12/13/how-to-make-an-rts-game-in-godot/
- Open RTS: https://github.com/lampe-games/godot-open-rts
- Open RTS license: https://github.com/lampe-games/godot-open-rts/blob/main/LICENSE
- Godot stable release archive: https://godotengine.org/download/archive/
- Godot navigation documentation: https://docs.godotengine.org/en/stable/tutorials/navigation/
- Godot NavigationServer docs: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html
- Godot performance docs: https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
- Blender LTS: https://www.blender.org/download/lts/
- Ollama Codex CLI integration: https://docs.ollama.com/integrations/codex

**Version note:** the official Godot archive lists 4.7.2-stable (18 August 2026); Blender's official LTS page lists 5.2.2 LTS (15 September 2026). Re-check official sources during setup and pin tested versions in the project.
