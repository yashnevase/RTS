# External Godot RTS resources — evaluation notes

**Status:** Technical references to inspect; not adopted dependencies, not authoritative architecture and not a replacement for the Game Bible. Re-check current versions/licences when used.

## 1. Godot RTS genre skill

Link: https://atskills.one/thedivergentai/godot-genre-rts

Potential use: prompt patterns, genre-specific checklists, and reminders of common RTS subproblems. Do not accept its instructions blindly as a design specification. Compare each relevant idea with the agreed game format and the actual project, and avoid installing third-party skill files without inspecting their content and intended tools.

## 2. Godot forum — 3D RTS tutorial series

Link: https://forum.godotengine.org/t/3d-rts-tutorial-series-for-godot/94795

Potential use: learn/compare implementation approaches for a 3D RTS camera, selection and orders, movement, navigation and unit behaviour. Treat tutorials as illustrative examples; verify Godot API/version, typing, lifecycle, performance and edge cases before adopting code. Use ideas selectively instead of following an entire series if it conflicts with the project's separation of simulation, scene presentation and data definitions.

## 3. lampe-games/godot-open-rts

Link: https://github.com/lampe-games/godot-open-rts

Potential use: inspect a real Godot RTS codebase to understand scene/resource organisation, selection/orders, unit control, navigation, combat and build workflow where the repository actually provides those elements.

Before reusing code or assets, inspect the current default branch, maintenance/last commit, README, LICENSE, dependencies, Godot version, open issues and tests. If licence or ownership is unclear, use it as a learning reference only. Do not wholesale merge the repository or let its architecture dictate DECCAN LORDS. Adapt only a small, isolated component after it passes the project's tests and fits the current design.

## 4. majidmanzarpour/threejs-game-skills

Link: https://github.com/majidmanzarpour/threejs-game-skills

The useful workflow idea is a director routing to focused specialists with actual build/run/visual/test evidence and a clear report. Its packaged stack is for Three.js/browser games, so DECCAN LORDS uses a Godot-native specialist suite instead of copying its browser scaffold or tests.

## Reuse decision checklist

Before adding any external code, plugin, scene, model, texture, animation, sound or skill:
1. Is it relevant to an approved current milestone rather than merely interesting?
2. Is the license clear and compatible with the intended release/distribution?
3. Is it maintained and compatible with the pinned Godot/Blender versions?
4. Does it introduce unneeded dependencies, permissions, global state or architecture?
5. Can it be isolated, understood, tested and removed later?
6. Does a minimal integration improve actual development time, performance or quality?

Prefer learning/porting one technique over copying a large framework. Reusable assets are allowed when their exact licence permits the use; preserve attribution and provenance. Do not rip assets from commercial games, even if the project stays private during development.
