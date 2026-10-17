# M5 campaign/recovery evidence — 2026-10-17

Environment: macOS, Apple M4, Godot 4.7.2, Compatibility renderer. No dependencies or external assets added.

## Checks run

| Command | Result |
| --- | --- |
| `godot --headless --path . --editor --quit` | Passed; no reported script/import errors |
| `godot --headless --path . --script tests/unit/test_m2_battle_simulation.gd` | Passed, 7 groups |
| `godot --headless --path . --script tests/unit/test_m3_settlement_simulation.gd` | Passed, 8 groups |
| `godot --headless --path . --script tests/unit/test_m4_campaign_simulation.gd` | Passed, 7 groups |
| `godot --headless --path . --script tests/unit/test_m5_campaign_loop.gd` | Passed, 7 groups |
| `godot --path . --script tools/m5_interaction_capture.gd` | Passed at 1600×900 |
| `godot --path . --resolution 1280x720 --script tools/m5_interaction_capture.gd` | Passed at 1280×720 |
| `git diff --check` | Passed |

M5 simulation covers pause and invalid commands during combat, retreat survival, exactly-once outcomes, two patrols across save/load, actual commanded combat, unattended CPU defeat, wound recovery caps, no-food/no-heal, arrival versus full rest, replacement costs/cap, full-force replacement, schema 1/2 migration, malformed health/duplicate records, atomic failed loads and escort halt/resume.

An initial M4 run found health stored as floats but normalized to integers on load, breaking exact round trips. Health now uses integer persistence consistently; all suites above passed on the final implementation. One expanded graphical capture stopped producing output and was interrupted; a diagnostic rerun and the alternate-resolution run completed successfully. No root cause for that interrupted run was established; it is not counted as a pass.

## Actual mouse interaction

The capture injects viewport mouse press/release events rather than emitting button signals or calling the battle input handler directly. It selects a map location, orders travel, advances a day, saves, enters combat, selects a friendly unit, withdraws all, returns, travels home, prepares again and saves/reloads. A second unattended battle ends in a real defeat; UI commands hire five replacements, charging exactly 60 coin and 10 grain, then prepare another patrol. A live settlement view is captured afterward.

No units are killed or healed artificially in graphical captures. Boundary fixtures in the unit suite explicitly inject wounds/casualties to isolate accounting checks.

## Captures and visual inspection

Each stage has `1600x900` and `1280x720` variants:

- `battle_selected`: selected unit and campaign-specific battle controls.
- `battle_result`: withdrawal result and return control.
- `home_prepared`: returned retinue and another prepared patrol.
- `battle_casualties`: full defeat of the second force.
- `replenished`: paid replacements, treasury impact and next patrol prepared.
- `settlement`: shared settlement ledger after the loop.

Inspected the battle/return and home/settlement captures at both resolutions. Campaign sidebar and settlement content scroll; primary map/time/save controls remain available. Text is relatively small at 1280×720 and the sidebar is dense. The map and battlefield still look like prototypes.

## Limits and next step

This verifies a bounded repeat/recover/save loop. It does not establish performance targets, clean-machine export readiness or a finished game. No mid-battle saving, persistent enemy army, battle loot, holdings damage or battle-specific political consequences. Hiring is an abstract external cost sink, not household manpower. Escort strength still ignores tactical casualties. The next bounded M6 pass should improve onboarding, battle-result clarity, sidebar density and selection/order feedback before broader graphics/content work.
