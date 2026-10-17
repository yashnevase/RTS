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

The repository contains the source-of-truth design documents and reusable Codex skills. The actual Godot project has not yet been initialized; no full game implementation or playable slice is claimed.

The current high-level product format is agreed. The historical start date, final faction roster, visual benchmark, detailed simulation rules, and first-release content boundary remain open or proposed. The team should implement one gated milestone at a time and preserve a working, testable project between milestones.

## Recommended engine/workflow direction

- Godot stable + GDScript for the game.
- Blender LTS for custom/modular art and animation.
- Reuse suitable assets only when their individual licences permit the intended use; keep a credit/licence manifest.
- Codex with the project-local `deccan-lords-director` skill as the task entry point; specialists are loaded only when needed.
- Git commits, reproducible tests, real scene/screenshot evidence, profiling and explicit risk reports at each milestone.
- Optional local Ollama model for suitable low-risk support work; optional Godot MCP only after the project can import/run/test without it.

## First setup sequence

1. Clone this repository on the Mac and open it as the Codex workspace.
2. Install a stable Godot release, Blender LTS, Git and the preferred local Codex client.
3. Create the smallest Godot project in this repository root (so the Game Bible, code and skills stay together) and verify it opens/imports/runs.
4. Run `bash scripts/install_deccan_lords_skills.sh .` from the repository root. The script requires `project.godot` and will not overwrite already installed skill directories.
5. Start with milestone M1 in the production pipeline only after M0 succeeds.

To validate the skill bundle itself, run `bash scripts/validate_deccan_lords_skills.sh`. GitHub Actions runs this check when the skill files or helper scripts change.
