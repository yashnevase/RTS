# 08 — Technical architecture and AI-assisted workflow

## Provisional stack direction

**PROPOSED: Godot 4.x, using the latest supported stable patch at project setup, with GDScript for gameplay logic.** The intent is to use an integrated game engine for scenes, 3D rendering, animation, audio, UI, input and desktop export rather than build the entire product in React/Three.js and later rewrite it. Verify the current stable version and pin it in project setup; do not use an untested development/nightly build for the main project.

Godot officially supports native macOS development and Windows desktop exporting. Reference: [Godot Windows export documentation](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html) and [Godot platform FAQ](https://docs.godotengine.org/en/stable/about/faq.html).

## Game format and agent workflow proposal

The full recommendation for the fixed-world kingdom sandbox, connected strategic/local/tactical views, visual benchmark, staged vertical slice, current tool versions, local-model/MCP options and quality gates is documented in [Recommended game format and AI-assisted production pipeline](18_game_format_and_ai_production_pipeline.md). Keep the art direction, camera and scene flow PROPOSED until the representative benchmark is reviewed. The tool recommendations are checked as of 2026-10-17 and must be rechecked at setup.

## What to do with the existing Three.js prototype

- Keep it in version control as a reference/prototype.
- Audit movement, selection, combat, pathfinding, structures, resources, and screenshot style.
- Record desired behaviors and edge cases before adapting anything.
- Port or reimplement only components that are valuable and fit the chosen architecture.
- Do not build a second complete version of the campaign in React first.

A tiny React/HTML mockup is acceptable if it validates a UI interaction quickly; it must not become a parallel full-game implementation.

## Architecture principles

- Simulation state is separate from rendering and UI.
- State-changing actions are explicit commands validated by game rules.
- Data for buildings, units, goods, factions and events is data-driven where useful.
- Save/load has versioned schemas and deterministic migration tests.
- AI decision logic is modular, explainable and testable independently of rendering.
- Rendering/animation runs at frame cadence; settlement and political simulation run on controlled update cadences.
- No subsystem may silently invent state transitions owned by another subsystem.
- Use Git branches/commits and automated tests for meaningful work; avoid broad unreviewed AI edits.

## AI coding workflow

1. Human + assistant agree a small feature spec and acceptance criteria.
2. Codex implements only that scope.
3. Build/import/headless tests run; capture screenshots or logs for visual changes.
4. Review edge cases, performance, save compatibility and regressions.
5. Update the bible and decision log after decisions change.

## Local models and paid model use

A local model via a local runtime such as Ollama may help with repetitive drafts, sample data, tests, documentation and first-pass utility code. A stronger coding model should handle architecture, complex integration, critical debugging and final reviews. Local inference can reduce external usage, but code and data still need tests and licence/security review. Never grant an untrusted model unrestricted shell, filesystem or secret access by default.

## Jev and decision-model tooling — RESEARCH, NOT ADOPTED

Jev is a hosted decision model that returns typed probabilistic answers to bounded questions (yes/no probability, choice among options, or a score). It may be useful for narrow development workflow tasks such as model routing, categorizing test/playtest traces, or triaging logs. It is not a code-writing model, game engine, pathfinder, or replacement for game simulation rules.

Do not add Jev as a dependency to the game runtime. CPU lord decisions should be grounded in explicit state and tested game algorithms. A hosted decision call at runtime would add latency, service dependence, cost and replay/networking complications without a demonstrated gameplay benefit.

Do not integrate Jev into the Codex workflow yet. LangChain's examples use its own agent middleware; adopting it in our Codex/Godot setup would need extra glue and a separate TypeSafe API key. Vendor-reported task-specific speed/cost figures are not an end-to-end promise. One public coding-agent filtering experiment published mixed evidence: an earlier 30-task run was encouraging, while a later 49-pair Terminal-Bench follow-up reported fewer passes, higher input tokens and higher model cost for that particular implementation. These results do not prove that Jev generally fails; they do show that our own A/B evaluation is necessary.

If repeated classification/routing becomes a measurable bottleneck, build a small off-by-default benchmark and compare completion time, total cost, quality/test pass rate, wrong decisions and human corrections. Keep raw evidence accessible. Never make probabilistic classification the sole security control; deterministic allowlists, OS permissions and user approvals remain authoritative.

See [Jev harness research](../references/15_jev_harness_research.md) for the current evidence and adoption gate.

## MCP policy

Add an editor MCP integration only after confirming it is maintained, compatible with the pinned Godot version, permission-scoped, and useful for real tasks. MCP is an interface to tools, not a substitute for specs, tests, version control or review.

## Performance and target platforms

Primary target: Windows PC distribution. macOS is the development environment and may also be a release target. Minimum CPU/GPU/RAM, frame-rate target, resolution, army count, entity budgets and save size are OPEN and must be tested against a representative scene.

## Future multiplayer preparation

Keep commands and state transitions explicit, but do not build online infrastructure before the single-player core is proven. Multiplayer would require separate choices for authority, session hosting, synchronization, persistence, rejoin behavior, anti-cheat and disconnect recovery.
