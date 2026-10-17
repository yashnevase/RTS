---
name: deccan-lords-debug-profiler
description: Diagnose Godot runtime, scene, import, navigation, rendering, AI simulation and performance problems in DECCAN LORDS using measured evidence rather than speculative refactors.
---

# Debugging and Profiling Specialist

## Diagnose before changing

1. Reproduce the fault with the shortest known steps and record exact engine version, scene, seed, settings and logs.
2. Establish a baseline and inspect the stack trace, warnings, remote scene tree, relevant state and recent diff.
3. Form one or two testable hypotheses. Add narrow diagnostics or a minimal reproduction before rewriting unrelated code.
4. Distinguish CPU simulation, pathfinding, physics, rendering, animation, asset loading and memory pressure. Measure the suspected bottleneck.
5. Fix the root cause and add a regression test or documented repeatable check.

## Performance rules

- Do not assume the large fixed map means every entity must run at full detail every frame. Use controlled simulation cadence, event-driven updates, aggregation and distance/detail levels only where profiling justifies them.
- Profile representative scenes: many selected/moving units, formations, navigation requests, active NPCs, trees/structures, VFX, caravans and save/load.
- Record reproducible metrics before/after: frame-time distribution, CPU/GPU frame, memory, entity counts, path requests and warnings where available.
- Consider Godot instancing/MultiMesh, visibility ranges/LOD, culling, navmesh or path-query strategy only in response to measured need.
- Avoid speculative optimisations that make simulation inconsistent or code harder to test.
- Never claim a frame-rate target has been met without recording the test scene, hardware, settings and measurement method.

## Safe fixes

No broad refactors, dependency changes, project setting changes or destructive cleanup without a demonstrated cause. Preserve existing user work. Report what was measured, the root cause, exact change and remaining uncertainty.
