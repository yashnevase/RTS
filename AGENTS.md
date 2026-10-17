# DECCAN LORDS — Agent Instructions

## First action: establish context
Before starting an implementation milestone, also read `M0_BOOTSTRAP_PROMPT.md` for environment/setup tasks, `DECCAN_LORDS_GAME_BIBLE/design/19_feature_register_and_campaign_progression.md` for the long-term feature inventory, and `DECCAN_LORDS_GAME_BIBLE/references/20_external_godot_rts_resources.md` before evaluating external RTS code/tutorials.
Before editing anything, read:
1. `PROJECT_CONTEXT.md`
2. `DECCAN_LORDS_GAME_BIBLE/README.md`
3. `DECCAN_LORDS_GAME_BIBLE/design/00_game_vision.md`
4. `DECCAN_LORDS_GAME_BIBLE/design/12_decision_log.md`
5. The specific design/system file related to the task
6. `DECCAN_LORDS_GAME_BIBLE/design/11_open_questions.md` when a rule is unclear
7. `DECCAN_LORDS_GAME_BIBLE/design/18_game_format_and_ai_production_pipeline.md` when the task concerns format, production sequencing, model/effort, local models, MCP or QA gates
8. Relevant project-local skill in `.agents/skills/` when installed; use `skills/README.md` in RTS-Docs to find the skill suite and installer

## Current collaboration phase
The project is in **DISCOVERY / PRE-PRODUCTION**. M0 setup, M1 visual/control benchmark, M2 standalone battle prototype, M3 settlement/economy prototype and M4 strategic campaign prototype are complete bounded prototypes. The user wants core gameplay loops proven before broad cinematic/cosmetic polish and wants day/night, weather and varied terrain retained as later world features; those systems and their gameplay effects are not yet specified. Treat design content as `PROPOSED`, `OPEN`, `RESEARCH`, `DEFERRED`, or `LOCKED` exactly as recorded. M3/M4 exact numbers, names and formulas are prototype-only; do not silently convert them into locked rules. M2 battle remains standalone; M5 connects it to campaign state.

## Design rules
- Preserve the user's intended game rather than replacing it with a generic RTS template.
- Distinguish user-provided historical knowledge, verified research, design inference, and fictional alternate-history choices.
- Do not invent missing formulas, starting holdings, victory conditions, time systems, or political rules without marking them as proposals.
- When something material is underspecified, document the options, trade-offs, and what decision is needed. Do not block low-risk work over cosmetic details.
- The Game Bible's Markdown files are the canonical source. DOCX/PDF/XLSX exports are derived snapshots and can become stale.
- Maintain relative Markdown links when renaming or moving files.
- Preserve a decision history. Never erase an earlier decision silently; supersede it with a dated entry explaining why.

## Change discipline
- Make only changes that serve the requested task; avoid broad unrelated refactors.
- For design work, update canonical Markdown and the decision log only to the certainty level actually approved. A user idea stays proposed/open until the user explicitly locks it.
- For implementation work, first state a concise plan and identify acceptance criteria. Change one coherent vertical slice at a time.
- Do not create a full React/HTML version of the game as a precursor to a Godot rewrite. The existing Three.js prototype is a reference/source to inspect; port or reuse components selectively.
- Do not install new MCP servers, editor plugins, assets, or packages without checking maintenance, licence, compatibility, permissions, and necessity.
- Do not assume multiplayer is part of the first playable version. Keep future networking needs in mind without implementing speculative online infrastructure.

## Implementation quality bar (when coding is authorized)
- Keep simulation state separate from rendering and UI.
- Prefer data-driven definitions for units, structures, goods, factions, events, and tuning values where appropriate.
- Keep NPC decisions testable without rendering and explain major decisions in debug logs.
- Include edge cases and automated tests for important state transitions.
- Run the relevant import/parse/build/headless tests and report exact results. Never claim a test passed unless it ran successfully.
- Inspect diffs; do not overwrite or delete user work without explicit instruction.
- Do not embed credentials or secrets. Treat downloaded code/assets as untrusted until reviewed.

## Expected completion report
For every meaningful task report: files changed, what changed, assumptions made, tests actually run and results, known gaps, and any decisions still needed. Keep the report factual and concise.
