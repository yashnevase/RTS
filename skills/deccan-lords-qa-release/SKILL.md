---
name: deccan-lords-qa-release
description: Verify DECCAN LORDS Godot changes with reproducible headless/import tests, simulation tests, real scene interaction, screenshots, performance checks and release evidence.
---

# QA and Release Specialist

## Rules

- Never claim a test passed unless it was run and its exit status/result inspected.
- First discover the pinned Godot version, installed tests and repository commands. Do not assume GUT, Playwright or a test framework is installed.
- Use the smallest relevant checks for narrow changes; run the full agreed regression suite for core simulation, input, save/load or release changes.
- Keep a reliable baseline: clean Git diff, reproducible seed/state, exact command, logs and result.

## Check ladder

1. **Static/import:** Godot version check; headless editor/import or project parse check appropriate to the current Godot version.
2. **Unit/simulation:** test changed rules independent of rendering where possible: economy transfers, household labour, political state, party movement, casualties/recovery, and AI decisions.
3. **Integration:** test the connected loop affected by the change with a deterministic seed, including both player and CPU behavior where applicable.
4. **Visual/interaction:** launch the actual project, exercise input, and capture screenshots at meaningful state(s). Inspect the result rather than relying solely on successful launch.
5. **Performance:** use a repeatable stress scenario and measured baseline when the change can affect frame time, memory, pathfinding, large entity counts or asset loading.
6. **Export/save:** validate save-load and target platform export when relevant; keep project/version metadata and migration behavior correct.
7. **Evidence/report:** record checks actually run, paths to logs/screenshots, failures, skipped checks, residual risks and the next test.

## Scenario quality

Use deterministic seeds for bug reproduction and automated comparisons. Add boundary and failure scenarios: missing/invalid data, destroyed or occupied target, insufficient money/supply/labour, interrupted travel, defeated party, abandoned settlement, missing asset, save interrupted or old save when applicable. Test whether NPC information and consequences remain causally consistent.

## Release/asset safety

Review dependency and asset licences, API keys, telemetry and network calls before release. Do not commit secrets. Do not add a paid API, MCP server, external package or test framework without checking necessity, maintenance, compatibility, permissions and licence. A build passing is not evidence of fun, visual polish or complete release readiness.
