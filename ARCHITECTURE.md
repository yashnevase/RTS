# DECCAN LORDS — code ownership and extension guide

## Current boundaries

| Layer | Location | Owns |
| --- | --- | --- |
| Authored region | `src/world/region_definition.gd` | Location IDs, display metadata, map positions, road graph and path finding |
| Campaign rules | `src/campaign/m4_campaign_simulation.gd` | Parties, contracts, merchant decisions, daily movement, delivery and campaign save validation |
| Settlement rules | `src/settlement/settlement_simulation.gd` | Labor, production, inventory, taxes, trade and settlement save validation |
| Command wiring | `src/campaign/m4_campaign.gd` | UI commands, simulation invocation and refresh |
| Presentation | `src/campaign/m4_campaign_hud.gd`, `m4_campaign_map.gd` | Panels, selection, route preview and map drawing; no economic mutations |
| Shared UI | `src/ui/game_ui.gd` | Color tokens, panel, label and button factories |
| Persistence | `src/persistence/json_save_store.gd` | JSON/file I/O, temporary-file replacement and error messages |
| Save adapters | Campaign/settlement save stores | Existing entry points and default save paths |

Campaign owns one settlement simulation. Both views read that same instance. Rendering must never advance time; controller commands do. Save transport asks each domain to validate a candidate before replacing live state. Save paths remain stable; campaign schema 3 migrates versions 1 and 2. Invalid disconnected routes are rejected.

## Adding content and systems

- Add locations and roads in the region definition. Road edges currently cost one day. Coordinates are illustrative layout, not physical distance. Keep adjacency symmetric for two-way roads.
- Add economic rules in the settlement simulation, expose observable results, then add controls. Do not duplicate calculations in labels or map drawing.
- New contract types should get explicit data definitions and state transitions when implemented; the current one-shipment scenario is still a prototype.
- Connect tactical encounters through campaign commands and serializable outcomes. M2 now accepts a campaign-owned battle simulation; its standalone scene still works. Avoid a second authoritative army or inventory state in the battle renderer.
- Replace the strategic map presentation independently: it receives campaign state and emits a location selection. A future 3D renderer should keep that boundary. Weather, terrain movement costs and visibility require explicit simulation rules before visual effects can affect gameplay.

## Asset organization

Keep editable Blender sources in `assets/blender_source/`, runtime models in the existing runtime asset folders, and reproducible generators in `tools/`. Keep generated review captures in `artifacts/`, outside runtime imports using `.gdignore`. Record sources/licenses before adding external assets. Existing M1/M2/M3 scenes remain useful references; their removal needs a reference audit, not a bulk cleanup.

## Remaining limits

This pass removes duplicated save transport, duplicated campaign geography, redundant travel controls and the nested settlement scroll host. It does not reorganize every prototype or establish a finished game architecture. Milestone filenames remain stable to preserve scene and tooling references.

The connected patrol/recovery loop is now implemented. Meaningful progression, persistent opponents and broader consequences remain missing. The map remains an illustrated prototype. Current regression and visual evidence is in `artifacts/m5/`.

## Campaign encounter ownership

`src/campaign/campaign_encounter.gd` owns provisional encounter/recovery tuning, roster conversion and validation. Campaign commands debit replacement and recovery costs from the owned settlement; UI only invokes these commands. Campaign simulation owns the active `battle_simulation.gd` instance and applies its completed result once. `m2_battle.gd` accepts that instance before entering the scene tree; campaign mode replaces restart with withdraw/return controls. Hidden campaign UI is disabled while battle runs. Campaign save schema 3 adds the completed count; schema 1 and 2 loads are migrated. See the M5 note for current gaps.
