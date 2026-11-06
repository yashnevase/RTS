# UI specification — review draft

Desktop baseline: 1920×1080 (TUNABLE), keyboard scalable text, readable 1280×720 fallback. Escape closes top panel; Space toggles pause; tooltips expose units/provenance. Every command shows costs, elapsed time and confirmation only where consequential. Color is reinforced by symbols/text. Decorative art never contains the only readable labels.

| Screen | Wireframe layout | Data/actions |
|---|---|---|
| Map HUD | Top date/resources; left party summary; center map; right selected entity; bottom time/log | Pause/1×/2×/4×, route preview, known risk, movement, notices |
| Party | Left roster; center unit detail; right supply/pay | Wounded/fit, wages, capacity, recruit/upgrade/disband, consumption forecast |
| Town | Portrait/art header; left actions; center market/issues; right authority | Enter market, recruit, seek work, governor audience; control and revenue shown separately |
| Village | Settlement header; production/needs center; local contacts right | Buy food, recruit where legal, assist, raid with consequences |
| Fort | Fort art left; condition/supply center; authority/actions right | Garrison, access, governor, readiness and ownership confidence |
| Clan | Crest/header; members/branches left; holdings center; obligations right | Service, reputation, relationships and succession claims |
| Character | Large portrait left; name/status top; biography/relations center; actions right | Talk, offer contract, negotiate; display sourced biography separately from gameplay traits |
| Dialogue | Portrait left; speaker/text center; response choices below | Topic-driven negotiation tied to real offers/state, disabled reasons, no invented historical quotes |
| Diplomacy | Actor list left; directed ties center; treaty terms right | War/peace/access/service offers, obligations and expiry, counteroffer |
| Trade | Player inventory left; market right; transaction basket bottom | Quantity, unit price, stock, total, capacity, fees, affordability; one atomic commit |
| Siege | Fort illustration; progress/supply comparison center; orders bottom | Approach/blockade/assault/withdraw, forecast uncertainty and costs |
| Battle report | Forces/losses columns; timeline center; aftermath bottom | Orders, terrain/leader factors, casualties, captures, loot and retreat explanation |
| Kingdom | Territory/rights left; council/vassals center; policy/budget right | Appointments, taxes, diplomacy, disputed claims, legitimacy and treasury |
| Developer console | Toggle overlay with command input and inspected entity | Search IDs, snapshot, seed/tick, grant/remove resources, relations, spawn approved templates, events, pause/step; modified-save badge |

Historical unknowns display “Unknown” with source/doubt access. Player knowledge may be limited separately from database confidence. Negotiation response varies with motives and memories, with explanations such as unpaid wages or broken promises; portrait expression reflects current interaction, not a permanent moral judgement.
