# DECCAN LORDS — Design, Skills and Game Project

DECCAN LORDS is a stylised, historically inspired Deccan/Indian kingdom strategy game. Its agreed high-level format is a fixed, date-specific world that evolves through player and CPU decisions, connected settlement/economic management, moving parties/lords and real-time tactical battles over shared campaign state.

## Start here

1. [Project context for ChatGPT and Codex](PROJECT_CONTEXT.md)
2. [Agent rules](AGENTS.md)
3. [Living Game Bible](DECCAN_LORDS_GAME_BIBLE/README.md)
4. [History draft analysis and source checks](DECCAN_LORDS_GAME_BIBLE/design/17_historical_pattern_intake_story_draft_01.md)
5. [Game format and AI-assisted production pipeline](DECCAN_LORDS_GAME_BIBLE/design/18_game_format_and_ai_production_pipeline.md)
6. [ChatGPT + VS Code + Codex workflow](CHATGPT_VSCODE_WORKFLOW.md)
7. [Godot-native Codex skills](skills/README.md)

## Local setup and feature register

- [M0 local bootstrap prompt](M0_BOOTSTRAP_PROMPT.md) — gives Codex explicit instructions for tool checks, a professional Godot folder structure and the first smoke test.
- [Campaign progression and feature register](DECCAN_LORDS_GAME_BIBLE/design/19_feature_register_and_campaign_progression.md) — preserves the lord-to-king/empire journey and long-term features separately from the first playable slice.
- [M3 settlement prototype rules](DECCAN_LORDS_GAME_BIBLE/design/21_m3_settlement_prototype.md) — records temporary economy values and boundaries without locking them as design.
- [M4 strategic campaign prototype rules](DECCAN_LORDS_GAME_BIBLE/design/22_m4_strategic_campaign_prototype.md) — records the fictional region, route, merchant, escort and save rules for the campaign slice.
- [External Godot RTS references and reuse rules](DECCAN_LORDS_GAME_BIBLE/references/20_external_godot_rts_resources.md) — describes how to assess tutorials/reference repositories without blindly importing their architecture.

## Current phase

M0 bootstrap, M1 visual/control benchmark, M2 standalone battle prototype, M3 settlement/economy prototype and M4 strategic campaign prototype are complete as bounded implementations. The default scene is now the campaign map, which holds the M3 settlement simulation alive and includes a settlement ledger view. The M2 5v5 field battle remains available at `scenes/battle/m2_field_battle.tscn`, and the M1 plateau study remains available at `scenes/benchmark/m1_field_study.tscn`. M2 battle is not yet connected to campaign encounters; that is M5 scope. The named region, starting values, contract, route and standing change in M4 are fictional prototype placeholders, not final design.

The user's current direction is to prove the core game loops before a broad cinematic/cosmetic art pass. Day/night, weather and varied terrain remain desired future world features; their exact rules and gameplay effects are still open.

The current high-level product format is agreed. The historical start date, final faction roster, approved visual direction, detailed simulation rules and first-release content boundary remain open or proposed. Continue one gated milestone at a time and preserve a working, reviewable project between milestones.

## Recommended engine/workflow direction

- Godot stable + GDScript for the game.
- Blender LTS for custom/modular art and animation.
- Reuse suitable assets only when their individual licences permit the intended use; keep a credit/licence manifest.
- Codex with the project-local `deccan-lords-director` skill as the task entry point; specialists are loaded only when needed.
- Git commits, reproducible tests, real scene/screenshot evidence, profiling and explicit risk reports at each milestone.
- Optional local Ollama model for suitable low-risk support work; optional Godot MCP only after the project can import/run/test without it.

## Run the current benchmark

Open the repository root in Godot 4.7 or run `godot --path .`. The M4 campaign screen shows the authored prototype region, travel orders, the merchant's visible decision reasons, a contracted grain caravan, campaign time and relationship standing. Switch to **Keshavwadi Settlement** to inspect the same M3 simulation; advancing campaign time continues its economy. The M2 battle is separately available at `scenes/battle/m2_field_battle.tscn`; left-click selects, Shift-click adds to the group, right-click moves or attacks, `R` retreats selected units and `Esc` clears selection. The original M1 field study is at `scenes/benchmark/m1_field_study.tscn`. Blender source is in `assets/blender_source/`; the checked-in GLB is the runtime model. To regenerate the market-house model, run `blender --background --python tools/generate_m1_market_house.py`. To regenerate the ambient loop, run `python3 tools/generate_m1_ambience.py`.

M1 visual evidence is under `artifacts/m1/`, M2 battle evidence under `artifacts/m2/`, M3 settlement evidence under `artifacts/m3/`, and M4 campaign/settlement evidence under `artifacts/m4/`. Run `godot --headless --path . --script tests/unit/test_m4_campaign_simulation.gd` for campaign travel, merchant decisions, convoy transfers, relationships and campaign/settlement save checks. Run `godot --path . --script tools/m4_interaction_capture.gd` to exercise campaign travel, caravan delivery, save/load and the shared settlement view. M3 checks remain available with `godot --headless --path . --script tests/unit/test_m3_settlement_simulation.gd` and `godot --path . --script tools/m3_interaction_capture.gd`. M2 checks remain available with `godot --headless --path . --script tests/unit/test_m2_battle_simulation.gd` and `godot --path . --script tools/m2_interaction_capture.gd`. M1 interaction checks remain available with `godot --path . --script tools/m1_interaction_capture.gd`. The project-local skill suite is installed under `.agents/skills/` and can be validated with `bash scripts/validate_deccan_lords_skills.sh`. GitHub Actions runs the skill-bundle validation when the skills or helper scripts change.
