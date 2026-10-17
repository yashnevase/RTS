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
- [External Godot RTS references and reuse rules](DECCAN_LORDS_GAME_BIBLE/references/20_external_godot_rts_resources.md) — describes how to assess tutorials/reference repositories without blindly importing their architecture.

## Current phase

M0 bootstrap is complete: this repository is an importable Godot 4.7 project, with Blender 5.2.2 and project-local Codex skills available on the development Mac. M1 is a deliberately small visual and control benchmark: one plateau scene, one market house, a small fort wall, three movable characters, a camera, a readable HUD and a quiet ambient loop. It tests art and interaction direction; it does not lock the final art style or claim that the full game systems exist.

The current high-level product format is agreed. The historical start date, final faction roster, approved visual direction, detailed simulation rules and first-release content boundary remain open or proposed. Continue one gated milestone at a time and preserve a working, reviewable project between milestones.

## Recommended engine/workflow direction

- Godot stable + GDScript for the game.
- Blender LTS for custom/modular art and animation.
- Reuse suitable assets only when their individual licences permit the intended use; keep a credit/licence manifest.
- Codex with the project-local `deccan-lords-director` skill as the task entry point; specialists are loaded only when needed.
- Git commits, reproducible tests, real scene/screenshot evidence, profiling and explicit risk reports at each milestone.
- Optional local Ollama model for suitable low-risk support work; optional Godot MCP only after the project can import/run/test without it.

## Run the current benchmark

Open the repository root in Godot 4.7 or run `godot --path .`. The main scene is the M1 field study. Blender source is in `assets/blender_source/`; the checked-in GLB is the runtime model. To regenerate the market-house model, run `blender --background --python tools/generate_m1_market_house.py`. To regenerate the ambient loop, run `python3 tools/generate_m1_ambience.py`.

M1 visual evidence is under `artifacts/m1/`. Regenerate both screenshots and verify selection, movement and building inspection with `godot --path . --script tools/m1_interaction_capture.gd`. The project-local skill suite is installed under `.agents/skills/` and can be validated with `bash scripts/validate_deccan_lords_skills.sh`. GitHub Actions runs the skill-bundle validation when the skills or helper scripts change.
