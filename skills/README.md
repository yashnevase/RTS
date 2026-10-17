# DECCAN LORDS Codex skills

These project-specific skills are designed for a **Godot + Blender desktop strategy game**. They adapt the director/specialist, deterministic testing and evidence-based QA pattern from [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills), without copying its Three.js/Vite scaffold or browser-only test scripts.

## Skills

- `deccan-lords-director`: route a task to the right specialist, preserve scope and integrate the result.
- `deccan-lords-gameplay-simulation`: Godot gameplay, economy, entities, campaign, armies and explainable CPU logic.
- `deccan-lords-visual-assets`: stylised 3D art direction, Blender source assets, Godot import, asset reuse and licences.
- `deccan-lords-ui-ux`: RTS controls, menus, alerts, readability and accessibility.
- `deccan-lords-audio-feedback`: ambience, music direction, interaction/combat feedback and audio QA.
- `deccan-lords-debug-profiler`: isolate runtime faults and profile the actual bottleneck.
- `deccan-lords-qa-release`: reproducible tests, headless checks, builds, screenshots and release evidence.

## Install into the actual game project

This repository is the design/skills source. Once the Godot game project folder exists, run:

```bash
bash scripts/install_deccan_lords_skills.sh /absolute/path/to/the/game-project
```

The helper copies the seven skill folders into `.agents/skills/` into the repository/game-project root `.agents/skills/`. It requires a real `project.godot` file and refuses to overwrite an existing skill directory. Inspect the skill files before installing and review later updates through Git.

Validate the skill manifests and installer in this repository with:

```bash
bash scripts/validate_deccan_lords_skills.sh
```

A GitHub Actions workflow also runs this check when the skills or helper scripts change.

The game project's root should also contain `AGENTS.md`, `PROJECT_CONTEXT.md` and a reliable link/copy of the Game Bible. The director skill checks these sources and does not invent missing context.

**Do not install the upstream `threejs-game-director` as the main DECCAN LORDS workflow.** Its bundled scaffold and QA scripts target Vite, Three.js and browser automation. Its orchestration/evidence methodology is the useful reference; the game needs Godot-specific scene, import/export, simulation and performance checks.

All gameplay remains GDScript-first unless measured need justifies another language. Local models and MCP are optional, never prerequisites. Installing these skills does not install runtime dependencies or automatically grant permissions to edit/execute files.
