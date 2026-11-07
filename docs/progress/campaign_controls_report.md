# Campaign controls revision

The user explicitly requested continuous world time, direct map movement, a name/house/banner starting page, full-map HUD and familiar inventory/party layouts. This supersedes earlier automatic pause-on-arrival and pause-on-menu behavior.

The first page accepts a personal name, house name, banner color and emblem. Entering starts 1× time. The full map has a compact top status strip, a bottom clock and screen navigation. Space toggles pause, 1/2/3 select 1×/2×/4×, I/P/C/J open screens, and Escape closes a screen. The clock remains accessible while screens are open. Clicking empty ground requests a route. Clicking a place opens a compact location card with travel action. Party markers have a portrait, personal color/emblem and animated pennant. Inventory and Party use three-column layouts, with the portrait between item/roster panes. The character equipment presentation is a visual foundation. Functional troop recruitment and equipment changes still require simulation data.

## Navigation

A 240×186 grid covers the regional envelope. A deterministic cardinal A* search blocks sea, high ground above a tunable elevation threshold and river cells except provisional crossing cells. Elevation bands increase movement cost. All moving parties now use the same grid routing and interpolation, including the market caravan. Inferred crossing candidates, coarse thresholds and within-cell endpoint snapping are gameplay assumptions. Accurate historical road, bridge, pass and forest coverage remains incomplete. Individual points within a roughly 4.5km cell share one passability decision. The grid carries its provenance in packages/sim/src/navigation.json. Modern physical inputs are Mapzen elevation and Natural Earth land/rivers, as documented in M1_terrain.md. Further crossing research is required before historical release.

Arrival and waiting completion leave the world clock running. Manual pause is available at any time. A field destination clears the settlement association, so markets and supplier quests remain accessible only from settlement visits. Refreshing starts a new session.

## Verification

Build, typecheck and unit/data tests pass. Navigation tests check coast rejection, reachable terrain and continuous arrival. Chrome verification exercises character creation, screen opening, a purchase-page layout and an empty-ground movement order. The clock advanced from 07:00 to 09:00 with Inventory open. Screenshots are in screenshots/campaign-hud.png and screenshots/party-layout.png. Automated browser rendering caught and corrected a terrain-import name collision during this revision. Full target-hardware frame profiling remains pending.
