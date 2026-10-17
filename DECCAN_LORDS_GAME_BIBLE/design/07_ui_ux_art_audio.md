# 07 — UI/UX, accessibility, art, animation and audio

## UI principles

- The game should be approachable to people who enjoy strategy but are not expert RTS players.
- Show current needs, risks and consequences near the relevant decision.
- Keep map information legible at different zoom levels; use icons and color consistently.
- Detailed statistics can exist in panels, but should not overwhelm the main play view.
- Give strong feedback for selection, movement orders, construction, completed production, danger, hits, morale changes and political outcomes.
- Use tooltips and progressive disclosure rather than forcing a manual before play.
- Key actions should be accessible through clear mouse controls and meaningful shortcuts; accessibility options remain to be designed.

## Candidate screen groups

Not locked: main menu/campaign setup, strategic map, local settlement management, army/party management, diplomacy/lord profile, tactical battle, siege, event/dialogue choice, codex/help, settings/save-load.

These may be overlays or scenes. We should not create a separate “screen” for every concept before the navigation flow is tested.

## Visual target

Stylized 3D, three-quarter/isometric-like camera; consistent architectural and environmental language; pleasing color harmony; readable silhouettes; natural lighting; restrained VFX; smooth camera and selection feedback. The existing Three.js screenshot is a starting visual reference. It does not decide the final renderer, art direction or asset quality.

## Animation priorities

Minimum quality bar for a representative slice: idle, walk/run, turn, attack, hit reaction, death/retreat, building construction or state change, and clear formation movement. Prioritize readable animation and responsiveness over huge numbers of poorly integrated animations.

## Audio priorities

Layered ambient beds by biome/time/weather; distinct work, movement, weapon, impact, construction, UI and alert sounds; music that supports peaceful development and tense conflict. Music may be curated/composed separately; all third-party audio must have a verified licence and attribution record when required.

## Asset production pipeline

Use a fixed art direction guide, palette/material rules, scale conventions, naming rules, animation requirements, LOD/performance budgets, and source/licence metadata. Blender and AI tools can support asset production, but every final asset requires review for consistency, topology, rig quality, visual artifacts and commercial rights.

## Definition of polish

Readable, responsive, stable and cohesive at target zoom and camera angle. Do not rely solely on bloom, particle counts or expensive graphics. Establish performance budgets early and profile on a realistic Windows PC, not only the Mac development machine.
