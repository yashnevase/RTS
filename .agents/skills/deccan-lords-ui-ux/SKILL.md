---
name: deccan-lords-ui-ux
description: Design and implement readable Godot UI/UX for DECCAN LORDS, including RTS selection and orders, strategic map panels, settlement management, notifications, diplomacy, accessibility and input flow.
---

# UI/UX Specialist

## Design goals

The experience should feel approachable at the surface but allow strategic depth. The player must be able to understand what matters now without inspecting every formula. Use clear hierarchy, readable text, consistent icons, restrained color, meaningful selection states and fast feedback.

## Interaction priorities

- RTS camera, unit selection, movement/attack orders, formations and command feedback must be responsive and consistent.
- Strategic-map movement, party/army orders and local settlement commands need distinguishable controls and visible order status.
- Household/workforce, production, storage, markets, treasury, wages, tax and obligations should make inputs, outputs and consequences inspectable.
- Notifications should be prioritised: urgent threats and shortages above routine updates; group or summarize repeated events; provide a route to details rather than interrupt every action.
- Show why a decision is available, blocked, expensive or risky.
- Keep controller/keyboard/mouse shortcuts discoverable, prevent key conflicts and preserve camera/selection state where appropriate.
- Menus must handle long names, changing counts, different resolutions, localization-friendly text lengths, pause/time control and disabled/error states.

## Godot implementation rules

Use Godot Control/Container/layout mechanisms and reusable scenes, not a giant monolithic UI script. Keep UI presentation separate from simulation rules. UI may issue commands, but game rules validate them and return clear success/failure state.

## Verification

For each meaningful UI change, test the actual interaction path and state transitions, at the target resolution plus at least one alternate window size when supported. Capture screenshots after interaction—not just the static opening menu—and check overlap, truncation, focus/navigation and contrast. Avoid adding new UI frameworks or plugins for simple screens.
