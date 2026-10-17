# DECCAN LORDS — M0 local bootstrap prompt

**Use this only after cloning/downloading this repository into the dedicated local project folder and opening that folder in the ChatGPT desktop Codex workflow or another local Codex agent with the required permissions.** An ordinary browser chat cannot install software or access local files by itself.

Paste the prompt below into Codex. M0 is setup only; it must not start building the full game.

---

## Prompt

You are the local technical lead for DECCAN LORDS. This repository is the source of truth. Work inside this repository folder and nowhere else for project files. You may install required developer tools system-wide only if missing and only from official project websites/package sources after inspecting the plan. If the OS asks for administrator approval, a licence acceptance, a security override, account login, paid purchase or broad security change, stop and explain the prompt to the user rather than bypass it.

### 1. Read before changing anything

Read:
- `AGENTS.md`
- `PROJECT_CONTEXT.md`
- `DECCAN_LORDS_GAME_BIBLE/README.md`
- `DECCAN_LORDS_GAME_BIBLE/design/00_game_vision.md`
- `DECCAN_LORDS_GAME_BIBLE/design/12_decision_log.md`
- `DECCAN_LORDS_GAME_BIBLE/design/18_game_format_and_ai_production_pipeline.md`
- `DECCAN_LORDS_GAME_BIBLE/design/19_feature_register_and_campaign_progression.md`
- `skills/README.md`

Do not blindly assume an empty project: inspect the current folder, Git status, existing files, available disk space and available commands. Preserve user files. Never delete/recreate the repository to get a clean start.

### 2. Check tools before installing

On this Apple Silicon Mac, check:
- Git
- a current stable release of Godot (not beta/RC)
- a current supported Blender LTS
- Ollama (optional, not a blocker)
- the current Codex client/login and access to this workspace

Use official sources and current versions, not hard-coded version guesses from this document. Reuse correctly installed versions; do not reinstall unnecessarily. Record version and install path.

**Godot is required, Blender is required for the planned custom 3D workflow, Ollama is optional.** Do not download a large local model yet without reporting model size, disk/RAM needs and likely purpose. First prove the engine and asset import workflow. Do not install MCP servers in M0.

### 3. Establish project structure

For simplicity and one source of truth, the repository root is the Godot project root. Do not create an unnecessary nested second repository or duplicate the Game Bible. Keep existing documentation and the tools under `DECCAN_LORDS_GAME_BIBLE/`, `skills/` and top-level `scripts/`.

Create `project.godot` in the repository root if no existing Godot project is present. If an existing project is found, inspect it and report before changing its structure.

Use this initial structure, adapting only when the existing project justifies it:

```text
/
├── project.godot
├── AGENTS.md
├── PROJECT_CONTEXT.md
├── README.md
├── M0_BOOTSTRAP_PROMPT.md
├── DECCAN_LORDS_GAME_BIBLE/   # canonical design docs; do not duplicate
├── skills/                    # source skill definitions
├── .agents/skills/            # installed copies used by Codex
├── scenes/
│   ├── app/
│   ├── campaign/
│   ├── settlement/
│   ├── battle/
│   ├── entities/
│   └── ui/
├── src/
│   ├── core/
│   ├── campaign/
│   ├── world/
│   ├── economy/
│   ├── politics/
│   ├── units/
│   ├── combat/
│   ├── ai/
│   ├── persistence/
│   └── ui/
├── resources/
│   ├── definitions/
│   │   ├── units/
│   │   ├── buildings/
│   │   ├── goods/
│   │   ├── factions/
│   │   └── terrain/
│   └── scenarios/
├── assets/
│   ├── models/
│   ├── materials/
│   ├── textures/
│   ├── animations/
│   ├── audio/
│   └── fonts/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── scenarios/
├── tools/                     # game-project automation only
└── CREDITS_AND_LICENSES.md
```

Create empty feature subfolders only when the first milestone uses them; do not generate dozens of dummy scripts. The names above are a starting convention, not an excuse to create boilerplate without purpose. Keep root-level `scripts/` for this repository's installer/validator scripts; gameplay GDScript belongs under `src/` and scene files under `scenes/`.

### 4. Install the project skills

After the Godot project exists, run:
```bash
bash scripts/install_deccan_lords_skills.sh .
``
If skills are already installed, do not overwrite them. Inspect and reconcile them manually. Run:
```bash
bash scripts/validate_deccan_lords_skills.sh
``
This validator checks the skill bundle/installer; it is not a game test.

### 5. Bootstrap, smoke-test and secure

- Use a small Godot-first project with GDScript. Do not add C#, a custom engine, Node/React, a database, multiplayer framework or extra plugin unless a measured need and approved design calls for it.
- Separate persistent simulation state and state-changing commands from Godot scene nodes, animation and UI. Avoid giant monolithic scripts, cyclic dependencies and global autoloads unless there is a clear reason.
- Prefer typed GDScript, clear names, small cohesive scripts/scenes, data-driven resources for configurable units/goods/buildings/factions, stable entity IDs, centralized balancing data and documented save-state versioning before persistence is expanded.
- Keep important rules testable without rendering. Add deterministic seeds for reproducible simulation scenarios.
- Add no API keys, tokens, credentials or machine-specific absolute paths to Git.
- Add no unlicensed game models/music, no ripped commercial assets and no external asset-generation API. Record every imported asset's source and licence in `CREDITS_AND_LICENSES.md`.
- Do not add MCP servers yet. Do not launch into the full economy, politics, AI or broad map.
- Create a tiny valid Godot main scene/project configuration, run headless import/editor validation and launch the project if possible. If a check fails, fix only the bootstrap fault and rerun it.

### 6. Quality gate for M0

M0 is complete only when:
- The project root and tool versions are recorded.
- Git status and changes are reviewed; no user content was overwritten.
- Godot can import/parse and launch the minimal project (headless checks alone don't prove the scene looks right).
- The skill installer/validator has run as relevant.
- The scene/project file paths are documented and no dependency/MCP was added without need.
- A short report states exact commands, observed results, screenshot/log paths if available, unresolved issues and one recommended next milestone.

**Stop after M0. Do not start M1 until the user reviews the setup report.**
