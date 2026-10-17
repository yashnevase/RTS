# 18 — Recommended game format, player flow and AI-assisted production pipeline

**Status: HIGH-LEVEL FORMAT LOCKED; detailed scope and implementation PROPOSED**  
**Date:** 2026-10-17  
**Purpose:** Turn the user's game references, current historical observations and solo/AI-assisted development constraints into one practical direction. This recommendation should guide the first prototype without pretending that all content, formulas or historical institutions have been finalised.

## Executive recommendation

Build **a fixed-world kingdom strategy sandbox with real-time tactical battles, settlement development and emergent political/economic simulation**. The user approved this high-level product direction and flow. The exact historical start date, faction roster, camera/art benchmark, detailed rules and first-release feature boundary remain open.

The strategic world starts from a researched, hand-authored historical/alternate-history state. It is not an empty random map that every player fills from zero. The world then evolves through shared simulation rules: rulers make decisions, parties travel, trade and war change holdings, households grow or leave, relationships change, and new kingdoms may rise.

- **Age of Empires:** take responsive RTS control, selection, commands, formations, battlefield clarity, readable counters and satisfying combat feedback.
- **Manor Lords:** take inhabited settlements, household and labour management, development, land suitability, local security and the connection between prosperity and population.
- **Anno 1800:** take production chains, warehouses, markets, goods flows, trade routes, household demand and economic trade-offs, simplified to fit the chosen historical period.
- **Mount & Blade: Bannerlord:** take a persistent strategic map, moving parties, independent lords, companions, relationships, changing allegiance, political opportunity and freedom to rise from local lord to ruler.

The result should feel like one game rather than four separate games joined together. The shared simulation should drive all layers, while each layer exposes only the controls and details useful to the player.

## 1. Recommended world format

### A fixed, researched world with a seeded political starting state

Use authored geography and meaningful settlement/route locations. At a chosen campaign start date, define which powers, lords, towns, forts, villages, ports, resources, roads and relationships exist. The campaign may then diverge from history through player and CPU decisions.

Do not combine every polity from 1500–1800 in the same starting state as if they all existed at once. A campaign start date determines the initial roster, while the simulation can produce an alternate future after that date.

The long-term geographic ambition from Delhi toward Kanyakumari remains a world-design ambition. Prove shared schemas, movement and simulation on a smaller representative region first; this is a vertical slice, not permission to discard the wider map.

### One world, with different views/detail levels

The recommendation is **not** a huge seamless 3D continent that simulates every villager and battle at full detail at once. Use distinct but connected views/scenes over the same persistent campaign state:

1. **Strategic campaign map:** see territory, settlement/fort icons or representations, roads, routes, parties, armies, caravans, known threats and political borders. Issue strategic movement, settlement, diplomacy, trade, patrol, raid and campaign orders.
2. **Local settlement view:** enter a player-owned or important contested settlement to inspect buildings, households, production, stores, security and construction. It remains linked to the same settlement state; leaving and returning should not reset inventories or people.
3. **Tactical battlefield or siege view:** when an encounter is chosen for manual battle, load a focused battlefield using the relevant region's terrain and context. Player and CPU control actual units in real time. Casualties, captured goods, morale, prisoners when included, commander outcomes, settlement damage and political consequences return to the campaign state after the battle.
4. **Interface panels and alerts:** many political, trade, household and administrative decisions should be available without forcing constant scene changes.

These can be separate Godot scenes that pass references/IDs to the same simulation state. Scene transitions are preferable to a first attempt at a seamless continent/local town/battlefield world. True seamless streaming can be researched later if it demonstrably improves the game.

### Campaign flow

A typical loop:

1. Inspect what the player's people need, what the treasury can afford, and what neighbouring lords or rulers are doing.
2. Improve a settlement, adjust labour/tax/security, establish production, buy or sell goods, or arrange trade/credit.
3. Receive a request, opportunity or threat grounded in the world state.
4. Decide whether to negotiate, honour an obligation, recruit, train, patrol, escort, spy, raid, move an army or prepare a defence.
5. Travel and interact with terrain, supply routes, forts, caravans and other parties.
6. Fight a tactical battle or siege when appropriate—or avoid it, negotiate, retreat or use logistics/intelligence to change the situation.
7. Apply casualties, recovery time, captured/lost inventories, treasury changes, damaged buildings, reputation, loyalty and political responses.
8. Let the world respond; recover and make the next decision.

The core pleasure is seeing a decision create consequences in several systems, not clicking through disconnected menus.

## 2. The player's identity and long-term progression

The player begins as a lord/clan leader in a specific historical situation, with holdings appropriate to that scenario. A town, fortress and several villages are not mandatory holdings for every noble. Rank, grants, territory, wealth, recognition, troops, relationships and historical circumstances shape the start.

The player should be free to pursue political growth: remain a lord, gain a larger appointment, support another claimant, change allegiance, become a mercenary/outlaw where supported, form a new kingdom or pursue imperial authority. These are campaign ambitions, not all guaranteed first-release features. The simulation should not invent rank advancement through one universal checklist until the historical system is researched.

## 3. Recommended art and camera direction

**Recommendation to test:** stylised, readable 3D with a three-quarter/isometric-like camera, grounded in Deccan/Indian architecture and landscape. Use modular, low-to-moderate-detail models, a coherent material/colour palette, warm atmospheric light, good silhouettes, readable team/faction colours, strong animations and layered sound. The aim is a polished, inviting strategy-game presentation—not high-poly photorealism.

Why not choose 2D pixel art immediately? It can be beautiful and may simplify some rendering, but this game needs armies moving in formations, terrain and fortifications viewed from several useful distances, distinctive Indian buildings, readable combat animation and potentially camera rotation/zoom. Pixel art still requires a large amount of unique directional sprite work. Reusable 3D models and rigs may be a better long-term fit for the chosen combination of systems.

This is a **recommendation, not a final art lock**. Build one small visual benchmark in Godot before deciding. It should include plateau/rock terrain, vegetation, one village, a small fort or wall, a market/building, a few animated people and soldiers, selection/movement, day/weather lighting treatment, UI and combat feedback. Compare quality, performance, iteration effort and the user's preferred look. Do not create hundreds of assets before approving the benchmark.

A solo developer with AI can make strong, polished work, but AI does not eliminate art direction, asset cleanup, rigging, animation consistency, testing or iteration. "AAA feel" should mean polish, cohesion and satisfying feedback—not an unsupported promise of AAA content volume or quality at zero cost.

## 4. Simulation complexity: realistic underneath, legible on top

The user has approved the hybrid household/workforce baseline. Continue with:
- Households and housing needs, population growth/migration, labour categories and job allocation.
- Local production choices shaped by terrain, water, climate/season, deposits, roads, security and market access.
- Actual inventories for important goods, warehouses, markets, prices at an appropriate level of abstraction and transport by caravans.
- Persistent merchants with capital, stock, routes, trust, debts, allies, rivals and contracts.
- Noble arrangements that vary by polity/rank/circumstances; political authority, revenue rights, remittance, salary, privileges and service duties remain distinct data.
- Lords, companions and parties with goals, traits, skills, relationships, knowledge, memory and constraints.
- Armies, temporary levies, professional troops, wages, supplies, rest/recovery, training, casualties and tactical battles.
- Forts, roads, patrols, intelligence and sieges whose location and logistics matter.
- Consequences that propagate between economy, people, war and politics.

Do not simulate every person as an elaborate autonomous agent. Use household/workforce groups for ordinary population; individual characters get greater detail when they have meaningful personal agency. Do not run every distant lord, household or navigation request every rendered frame. Use event-driven changes, controlled simulation ticks and cheaper aggregate updates at distance, while preserving causal consistency.

The player-facing interface should present consequences simply: clear alerts, priorities, short explanations, inspectable numbers and optional detail. Notifications inspired by Anno should be useful and prioritised, not an endless interruption stream.

## 5. Feature boundaries and delivery order

The idea list is the long-term vision, not a requirement to implement every feature before the game can be played. Features involving loans, court/succession rules, espionage, assassination, captivity, slavery/forced labour, religious policy, marriage/dynasty, custom fort building, complex siege machinery, or competitive multiplayer need separate design, research, ethical/tone decisions and acceptance tests.

### First vertical slice — recommendation

Build the smallest experience that proves the game identity:
- A small, representative strategic area with a few connected villages, one meaningful town/fort, roads and geography.
- One player lord, one neighbouring/overlord lord and a small set of relationships.
- One settlement with household/workforce assignment, a few meaningful needs and 2–3 geography-appropriate production activities.
- Inventory/warehouse and a simple market/trade interaction.
- One moving party/army and one caravan or patrol, with movement and a simple threat/escort/raid case.
- One tactical battle that can be controlled in real time and whose outcome updates the campaign.
- One meaningful political choice with a visible economic or military consequence.
- Save/load, a short onboarding flow, clear notifications, useful debugging and automated tests.
- A representative polished art/audio scene, not placeholder-only grey boxes as the final proof of direction.

Leave advanced contracts, full continent content, every historical faction, deep dynasty, all siege systems, multiplayer, and the complete historical roster out of this first proof unless one is essential to test the core.

### Suggested delivery sequence — one tested milestone at a time

Keep the end goal ambitious, but never ask Codex to build the entire game in one run. Each milestone should leave the project in a runnable, reviewable state.

**M0 — Repository and engine smoke test**
- Keep the canonical Game Bible, skills and the eventual `project.godot` in one repository so docs and code do not drift. The current repository can host the game source; consider renaming it from `RTS-Docs` to `DECCAN-LORDS` only when desired, not as a blocker.
- Open the repository locally in Codex; verify Git status, Godot executable and version.
- Create/import the smallest Godot project and run a headless editor/project check.
- Install the local project skills only after `project.godot` exists.
- Gate: clean import/run, no unexplained errors, commit made.

**M1 — Visual and control benchmark**
- Build a small Deccan-inspired plateau scene with ground/rocks, foliage, one house/market asset, a wall or small fort, and two or three animated units.
- Add the chosen three-quarter camera, zoom/pan/rotate only if needed, unit selection, movement orders and one simple interaction.
- Add basic lighting, shadows, restrained ambient sound, cursor/selection feedback and a small readable HUD.
- Gate: run the actual scene, capture at least one screenshot during interaction, inspect asset consistency and performance. Review the look before asset volume expands.

**M2 — RTS battle prototype**
- Add a small set of unit roles, formations/spacing, attack/target rules, health/damage, basic CPU opponent and an end condition. Keep the battlefield bounded.
- Use deterministic test seeds for reproducible cases and a few variable seeds for robustness.
- Gate: player can select, move, attack, reposition, retreat/lose a unit and finish/restart a battle. Automated checks cover core state transitions; capture actual gameplay evidence.

**M3 — Settlement/economy prototype**
- Add one settlement with household groups, job categories, two or three land-suitable production activities, inventory/storehouse, a simple buying/selling or market exchange, taxes/upkeep and prioritised notifications.
- Prosperity/housing may affect family attraction in later iterations; do not add every household need and a full Anno-like production web at once.
- Gate: production consumes correct inputs/labour; goods move to/from storage correctly; insufficient inputs stop production; money/goods accounting is consistent; save/load preserves state.

**M4 — Strategic campaign prototype**
- Add a strategic-map representation, travel between a handful of named locations, one player lord, one superior/rival, one merchant and one mobile party/caravan.
- Use explainable AI decisions and log why an actor chose an action. Test one trade/escort/raid or diplomacy event.
- Gate: time passes; the same actor/settlement state persists between views; movement, transfers and relationship consequences are observable; NPCs don't know hidden information without a plausible source.

**M5 — Connect campaign and battle**
- Enter a tactical fight from a campaign encounter; write casualties, recovery, loot/lost goods, treasury effects, damaged holdings and relationship consequences back into persistent campaign state.
- Add save/load and basic persistence before adding more entity types.
- Gate: one complete loop works repeatedly: prepare → move → encounter → fight or avoid → resolve losses/rewards → recover → save/reload with no duplicated or lost state.

**M6 — Polish and content growth**
- Improve animation timing, formation readability, selection/order feedback, particles/VFX, soundscape, notification hierarchy, camera feel, lighting, materials, onboarding and accessibility.
- Add historical factions, more settlements/production, deeper politics, merchants, sieges and other systems only after their inputs, outputs and tests are designed.
- Gate: fresh-eyes review with active-play screenshots, repeatable scenario/bot tests, performance measurements, asset-license audit and explicit known-issues list.

**M7 — Release hardening**
- Validate clean-machine imports/builds and exports for the selected platform, save migration/backup, input/display edge cases, performance under stress, credits/licences, logs, packaging and recovery.
- Gate: evidence-backed release checklist and a playable, repeatable loop—not merely a successful compile.

Do not commit to a delivery date until M1/M2 have been built and measured. M0 through M2 should produce a visible playable result before expanding the simulation.

## 6. Recommended development stack, checked on 17 October 2026

- **Main engine:** Godot 4.7.1 was the latest stable release listed in the official archive on 17 October 2026; Godot 4.8 was still a development build. Re-check the official archive during setup and pin the stable patch selected for the project; upgrade only through a tested change. Official archive: https://godotengine.org/download/archive/ and release policy: https://docs.godotengine.org/en/stable/about/release_policy.html
- **Gameplay language:** GDScript first, because the project is primarily a Godot gameplay/simulation project. Avoid adding C# or extra frameworks until a measured need justifies it.
- **3D creation:** Blender 5.2.2 LTS was available from the official Blender site on the check date: https://www.blender.org/download/lts/. Keep reusable source assets organised. Godot recommends glTF 2.0 (.glb/.gltf) as a strong interchange format; direct Blender-source import calls Blender during import and adds a dependency to the project workflow. Reference: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
- **Editor/AI coding:** VS Code plus the Codex IDE extension, signed in to the user's ChatGPT account, or Codex CLI running in the project directory. Codex usage limits depend on the plan and model; a Plus account should not be treated as unlimited. Official guide: https://help.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan
- **Version control:** Git and GitHub. Markdown Game Bible remains the canonical design source. Use small branches/commits, clear change summaries and rollback ability.
- **Optional local models:** Ollama can connect compatible local/cloud models to ChatGPT Desktop's **Codex mode**, and can also be used with Codex CLI. Current Ollama documentation says Ollama v0.34.0+ is required for ChatGPT Desktop integration; requests using an Ollama-selected model route through Ollama, while ordinary Chat and voice retain the normal ChatGPT connection. Setup: https://docs.ollama.com/integrations/chatgpt. For CLI, use `ollama launch codex`: https://docs.ollama.com/integrations/codex. On a 16 GB Mac, start with a modest quantised model and measure latency, context reliability and test-pass rate. Use local models for repetitive drafts, sample data, small scaffolding and first-pass tests; reserve the strongest available subscribed model for architecture and difficult integration when usage allows. Local inference can reduce model usage costs for selected tasks, but does not make the entire pipeline cost-free or make local models equal in capability.

- **Optional Godot MCP:** Do not make MCP a prerequisite for the first prototype. Codex can already edit project files and run approved shell/CLI tests when given local project access. After the first project launches reliably, evaluate one Godot MCP only if it materially improves scene inspection, editor interaction, test execution or debugging. Candidates include https://github.com/Coding-Solo/godot-mcp (MIT-licensed, with project launch/debug-output and scene tools) and https://github.com/blentz/godot-mcp (a newer, broader toolset that documents path-jailing, dry-run mutations and headless/editor/display tiers; it requires Node.js 20+ and Godot 4.7+). Re-check maintenance, issues, licence and tool permissions before selecting. Start with read/inspect/run tools, review diffs, and require approval for destructive operations. MCP is a tool bridge, not an autonomous quality guarantee.

- **Documentation retrieval:** OpenAI's public docs MCP at https://developers.openai.com/mcp is read-only developer-documentation search. It may be useful inside Codex but it is optional, not needed to launch the game.

Current references were checked on 2026-10-17. Re-check releases when actually setting up the machine; never use a beta merely because it is newest.

### Project-local Codex skills and department workflow

The repository includes a Godot-native skill suite under `skills/`, inspired by the director/specialist/evidence pattern in [threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills). It is **not** the upstream Three.js scaffold and does not require paid asset APIs.

Install it into an actual Godot project after `project.godot` exists:

```bash
bash scripts/install_deccan_lords_skills.sh /absolute/path/to/the/game-project
```

The script copies only the project skills to `.agents/skills/` and refuses to overwrite existing skill folders. See [skills/README.md](../../skills/README.md). The director skill routes work to gameplay, visual assets, UI/UX, audio, debugging/profiling and QA/release specialists as needed. It loads only relevant skills for the current task, not all references every time.

**Per-prompt rule:** one milestone or one coherent feature at a time. Each prompt should state the user-visible outcome, files/systems in scope, acceptance checks, explicit non-goals and required evidence. The agent may involve specialists automatically, but must not advance to the next milestone until the current one is tested and reported.

The upstream reference's useful ideas are department-based prompts, seeded deterministic testing, running the actual game, screenshots, playtest/visual evidence and a residual-risk report. Its bundled Vite/Three.js scaffold, Playwright/canvas inspection scripts and browser release steps are not used for this Godot game. We adapt those principles to Godot import/headless checks, GDScript simulation tests, actual scene interaction, screenshots and platform exports.

### Model and reasoning-effort policy

Use the **lightest model/effort that reliably meets the acceptance bar**, and only escalate when evidence shows the task needs it. Model names and access differ between ChatGPT and Codex interfaces, so select by tier from the models actually offered. OpenAI's current guidance distinguishes top-tier models for complex reasoning from balanced models for cost-sensitive engineering and efficient models for simpler tasks. Codex use also varies with model, context, task complexity and tools. References: [model selection](https://developers.openai.com/api/docs/guides/model-selection), [reasoning effort](https://developers.openai.com/api/docs/guides/reasoning), [Codex plan usage](https://help.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan).

| Task | Model/effort starting point | Why |
|---|---|---|
| Cross-system architecture, data boundaries, first project plan | Strongest available reasoning/coding model, **High**; use **Extra High/xhigh once** for a major architecture/security review | Mistakes here cause expensive rework; invest reasoning once, then preserve decisions in docs |
| Implement a clearly scoped feature with acceptance criteria | Balanced/strong coding model at **Medium** | Good everyday quality; avoid high reasoning when the task is already specified |
| Small docs edit, data fixture, repetitive conversion or isolated utility | Efficient model at **Low/Medium**, or a modest local Ollama model if already configured | Cheap, easy to verify; escalate only if it struggles |
| Complex bug with reproducible logs, or an integrated milestone review | Strongest available coding/reasoning model at **High**; **Extra High/xhigh** only for an unusually hard issue | Use measured evidence and the smallest reproducer; do not ask a high model to guess without logs |
| QA | Deterministic scripts/tests first; balanced model to interpret failures; strongest model for high-risk review | Automated pass/fail evidence is more repeatable than repeatedly asking an LLM whether code looks right |

Use a GPT-6/Codex-tier model if available for architecture and difficult debugging; use a GPT-5.6/5.5 or other balanced coding model at Medium for routine implementation when listed in your UI; use a cost-efficient or local model for mechanical work. This is a tier recommendation, not a promise that every client exposes those exact names. Do not use Extra High for every phase.

**Token-saving habits:** let the director skill read the relevant docs; do not paste the whole Game Bible into every prompt; do not ask one run to build the whole game; avoid parallel agents editing the same files; give a compact acceptance checklist; run a reusable test command instead of re-explaining checks. When limits are near, check the Codex usage/status dashboard before deciding whether to switch to local inference or use the plan's reset.

### One-prompt milestone template

Copy and edit this when the game project exists:

```text
Use deccan-lords-director. Read AGENTS.md, PROJECT_CONTEXT.md, the Game Bible README, decision log, and the relevant system spec. Use only the installed DECCAN LORDS skills this task needs.

Proceed with MILESTONE [number/name] only: [specific visible outcome].
Acceptance criteria:
- [observable behaviour]
- [test or reproducible scenario]
- [visual/build/save check where relevant]

Do not implement later milestones or add unapproved dependencies, services or assets. Preserve GDScript-first and data-driven simulation/render/UI separation. Run the relevant tests, launch/inspect the actual Godot scene when possible, capture a screenshot for visual work, inspect the diff, and fix failures before reporting. End with exact checks/results, evidence paths, remaining gaps/risks and the next single milestone. Do not claim anything was tested if it was not run.
```

## 7. Important boundary: what "controlled from ChatGPT" means

An ordinary browser ChatGPT conversation does not automatically gain access to local Mac files, Godot, Blender or terminal processes. To execute project work locally, the user must open the local repository in a tool that has those permissions, such as Codex IDE/CLI, and approve its access. A configured local MCP server can provide additional engine tools to that agent; the tools still operate within their permissions and need testing.

Use ChatGPT conversations for design, history analysis, plans and reviews; use Codex on the Mac for repository edits, scripts, engine launches and tests. Keep the shared GitHub repository as the hand-off point for canonical documentation and code. Do not assume that a change made in this browser conversation has automatically appeared in a local working tree until Git has fetched/pulled it.

## 8. Automated production loop and quality gates

Each feature should go through the same small loop:

1. Write a short feature contract: player problem, scope, data/state transitions, edge cases, acceptance criteria and what is explicitly out of scope.
2. Have Codex inspect the relevant Game Bible and existing code before editing.
3. Implement one coherent feature, keeping simulation logic separate from scene visuals and UI.
4. Run Godot headless project/import checks, automated unit/simulation tests and the relevant export/build check.
5. Run the game in the editor, inspect logs and screenshots/video, and manually evaluate the visual/gameplay result.
6. Test failure/edge cases and performance against a defined scene/entity count; check save/load and unintended side effects.
7. Review the diff and dependency/license impact. Fix failures before adding more features.
8. Update the Game Bible and decision log only when the implementation or design has changed; commit a small, reversible change.

Automate the checks that machines can reliably verify. Keep human approval for visual quality, game feel, historical interpretation, destructive operations and major scope decisions. A green build alone is not evidence that a strategy game is fun or polished.

## 9. Performance and art pipeline

Use data-driven building/unit/resource definitions and reusable asset kits. Prefer instancing for repeated scenery, level of detail/visibility ranges for distant models, and lower detail/update rates for distant simulation entities where profiling justifies them. Godot's official performance docs discuss culling, LOD, instancing and large-world considerations: https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html

Profile representative stress scenes containing a plausible count of moving troops, trees/buildings, path queries, effects and active NPCs. Do not set an arbitrary army-size or map-size limit before measuring, but do not promise unlimited armies or full-detail simulation everywhere before tests.

Use one coherent asset pipeline: consistent scale/origin/pivot, naming, material palette, collision/LOD policy, animation conventions, file formats and licences. Record third-party assets and their licence in a manifest. Never rely on scraped or unlicensed game art as final assets.

## 10. Main risks and guardrails

- **Scope sprawl:** keep long-term ideas in the Bible but limit the first slice to an integrated subset.
- **Mode mismatch:** do not promise both a deep persistent sandbox and a fully balanced competitive RTS on day one.
- **Simulation exploits:** test whether players can break the economy through loans, taxation, trade loops, loot or army wages; let clever strategies be possible without unbounded money exploits destroying every other system.
- **CPU omniscience:** NPCs should act on information they plausibly know; log major decisions and allow mistakes.
- **Performance:** measure navigation, animation, rendering, world updates and memory separately.
- **Historical compression:** keep one time-specific initial faction state; don't blend 300 years into an ahistorical opening.
- **Art consistency:** a small polished asset kit is preferable to many inconsistent AI-generated models.
- **AI overconfidence:** every generated change must be tested, reviewed and reversible. Do not grant a model unrestricted access to credentials or destructive commands.
- **Scope/quality trade-off:** the goal is a polished game. Feature counts and an elaborate architecture are not substitutes for a fun vertical slice.

## 11. Reference projects, tutorials and reuse policy

The user supplied these resources for technical learning:

- [ATS Skills — Godot RTS genre skill](https://atskills.one/thedivergentai/godot-genre-rts): evaluate it for useful genre checklists and task decomposition. Inspect exact instructions/tools before adopting them; do not let a third-party skill override the Game Bible.
- [Godot forum — 3D RTS tutorial series](https://forum.godotengine.org/t/3d-rts-tutorial-series-for-godot/94795): use selectively to understand common RTS implementation subjects such as camera, selection/orders, movement, navigation and unit control. Verify every tutorial against the pinned Godot version and current project architecture.
- [lampe-games/godot-open-rts](https://github.com/lampe-games/godot-open-rts): inspect as an example project only after checking its default branch, activity, engine version, source layout, dependencies, licence, tests and known issues. Do not wholesale merge it; borrow or port one isolated technique only if it is understood, licensed, compatible and tested.
- [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills): the specialist-routing/director and evidence-based QA pattern is useful. Its Three.js/Vite/browser scaffold is not the DECCAN LORDS technology stack.

These resources have not been accepted as project dependencies. Before adding any source code, model, texture, animation, audio, MCP or skill: check relevance to the active milestone; source/licence/attribution; maintenance and version compatibility; security/permissions; and whether the dependency is smaller than implementing the needed behaviour ourselves. Use suitable free assets if the exact asset licence allows the planned use and distribution, record them in `CREDITS_AND_LICENSES.md`, and never rip assets from commercial games.

## 12. Industry-style project organisation and code boundaries

The repository root is intended to be the Godot project root, with `project.godot` at this level. Keep the Game Bible, `AGENTS.md`, `PROJECT_CONTEXT.md`, skill definitions and automation scripts in this same Git repository so they remain versioned together.

Recommended initial layout:

```text
project.godot
AGENTS.md / PROJECT_CONTEXT.md
DECCAN_LORDS_GAME_BIBLE/       # canonical design source; don't duplicate
skills/                        # source skill definitions
.agents/skills/                # installed Codex skills
scenes/{app,campaign,settlement,battle,entities,ui}/
src/{core,campaign,world,economy,politics,units,combat,ai,persistence,ui}/
resources/{definitions,scenarios}/
assets/{models,materials,textures,animations,audio,fonts}/
tests/{unit,integration,scenarios}/
tools/                         # project-specific automation if needed
CREDITS_AND_LICENSES.md
scripts/                       # repo-level install/validation scripts only
```

Create feature subfolders when the first feature needs them instead of filling the repository with dummy scripts. Use typed GDScript, small cohesive scenes/scripts, stable entity IDs, explicit validated state-changing methods/commands, and data-driven definitions for configurable goods/buildings/units/factions. Keep persistent simulation state separate from rendering/animation and UI. Avoid a giant game manager script, unrelated global autoloads, cyclic dependencies, hard-coded per-faction logic and untested shared mutable state. Document save format/version when persistence is introduced. A future feature should state what state it reads/writes, its normal/boundary/failure cases, how it is tested and how it affects existing systems.

## 13. Player progression and long-session design intent

See the detailed [campaign progression and feature register](19_feature_register_and_campaign_progression.md). The intended career starts with a scenario-appropriate lord/clan inheritance, then offers choices to serve a ruler, complete favours, develop holdings, become a powerful warlord/court actor, change allegiance, support another power, found a kingdom or pursue imperial authority when the world rules provide plausible support/recognition. Companions, trusted nobles and family members may grow into useful administrators/commanders and be given responsibilities where rules permit.

This career is a freedom framework, not a rigid checklist or guarantee that every path is fully implemented in the first release. Long-session appeal should emerge from clear short-, medium- and long-term goals; consequential and readable decisions; independent NPC goals; varied economies/politics; useful delegation; low repetitive micro-management; tactical control that feels good; and credible recovery from setbacks. These qualities must be tested with actual play, not just documented.


## 14. Decisions still needed

The recommendation above intentionally leaves these open:
- Exact campaign start year and the initial historical/alternate-history boundary.
- Exact strategic map boundaries and the first prototype region.
- Whether the suggested strategic/local/tactical scene transitions feel right to the user, versus a single continuous map.
- Visual benchmark approval: stylised low-detail 3D versus another art treatment.
- Campaign time control (pause/slow/normal/fast) and exact tactical pause/order behaviour.
- Exact first-slice resources, buildings, merchant contract and political interaction.
- Battle size, unit count, formations, manual control details, siege scope and defeat/recovery rules.
- First-release scope; all long-term ambitions are not automatically v1 features.
- Local-model choice and whether a Godot MCP measurably improves development after the project boots reliably.

The immediate priority is to agree on the overall flow and prove it with a small polished playable slice. The rest of the detailed design should be informed by the user's master history and the results of actual prototypes.
