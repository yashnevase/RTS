---
name: deccan-lords-director
description: Orchestrate scoped Godot development for DECCAN LORDS: read the project design, route to focused gameplay, art, UI, debugging and QA skills, and deliver a tested, reviewable vertical slice. Use for milestones, broad feature work, polish passes and end-to-end tasks in this project.
---

# DECCAN LORDS Director

Own the **working game outcome**, not the number of files changed. Build a small playable loop, verify it, then expand. A polished slice is not proof that the complete campaign is finished.

## 1. Capability and context check

Before planning, establish:
- Which repository/folder is the Godot game project and whether the Godot executable, Blender and command-line access are available.
- Whether the workspace includes `AGENTS.md`, `PROJECT_CONTEXT.md`, the Game Bible and the existing source prototype.
- Which scenes/scripts/resources already exist; never assume a greenfield project.
- Which checks can actually be run in this environment. If scene interaction, GPU rendering or visual inspection is unavailable, report that gap instead of inventing results.

Read `AGENTS.md`, `PROJECT_CONTEXT.md`, the Game Bible README, `design/00_game_vision.md`, `design/12_decision_log.md`, the directly relevant system document, `design/11_open_questions.md` when needed, and `design/18_game_format_and_ai_production_pipeline.md`. If these documents are not present or cannot be accessed, state the context gap and continue only with safe, clearly scoped work.

## 2. Keep the task small

- Follow the current agreed direction: fixed, date-specific campaign world; Godot desktop game; local settlement/economic management; moving parties/lords; real-time tactical battles; one persistent campaign state.
- Do not switch to Three.js, Unity or a browser scaffold.
- Treat future features as out of scope unless the user explicitly selects them.
- For a broad request, turn it into one ordered milestone. Implement only the first milestone the user asked to proceed with; do not silently begin every department at once.
- Ask a question only when a missing choice blocks a safe material decision. Otherwise use documented assumptions and keep moving.
- Do not introduce MCP servers, external generation APIs, packages, assets, new languages or paid services by default.

## 3. Route to specialist skills

Find sibling skills in the active skill installation directory, then the repository's `skills/` directory. Read only what this task needs:
- Game rules, economy, world data, units, political simulation, combat or CPU decisions: `deccan-lords-gameplay-simulation`.
- Scene look, Blender, models, materials, animation, lighting or asset packs: `deccan-lords-visual-assets`.
- HUD, selection, orders, notifications, menus, accessibility or input flow: `deccan-lords-ui-ux`.
- Reproducible bugs, frame time, memory, navigation, rendering or simulation cost: `deccan-lords-debug-profiler`.
- Every meaningful implementation and all release/polish claims: `deccan-lords-qa-release`.

For a large feature, load the gameplay specialist and QA, adding art/UI skills only if needed. For a narrow fix, load one relevant specialist plus QA. Do not load every reference or paste the entire Game Bible into context for each small task.

## 4. Standard implementation loop

1. Write a short contract: player-visible outcome, scope, state changes, edge cases, acceptance checks and explicit non-goals.
2. Inspect existing implementation and run the smallest relevant baseline check.
3. Give a concise plan and make a small, coherent change. Keep simulation state, rendering/animation and UI separate.
4. Run Godot import/parse/headless checks and tests that cover the touched behavior.
5. Run the scene/game when possible. For visual work, capture a real screenshot and inspect it. For gameplay, exercise the actual input path or a deterministic automated scenario.
6. Fix failures before adding scope. Check the diff, unwanted side effects, asset/dependency licences and save compatibility.
7. Update documentation only when a design rule or implementation state changed; keep proposals proposed and preserve decision history.
8. Record exact commands/checks and results, screenshot/artifact paths, remaining risks and the single next recommended step.

## 5. Quality standard

The game should become attractive through consistent art direction, readable layouts, responsive controls, animation, audio and useful feedback—not through a high asset count. The CPU must use explicit game state and explainable rules; do not make runtime decisions through a paid/remote LLM. Use a fixed random seed in reproducibility tests and a different seed for robustness tests.

Never claim the game is polished, tested or release-ready without the corresponding evidence. A successful import or build proves only that particular check passed.
