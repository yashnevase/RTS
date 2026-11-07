# M2 travelling companies

Run `npm run dev` and open the local address. Campaign starts paused at Pune at 06:00. Select Saswad or Ahmadnagar and choose **Travel here**, or right-click a linked destination. Inspect a party banner, locate it from the journal, or follow your own company. Use Space or the clock buttons for pause/play and 1×/2×/4×. Wait for 1, 6, 12 or 24 hours. Waiting holds the player in place, advances other parties and pauses at the chosen hour. The prior journey can resume on play. Arrival automatically pauses. A journey may be redirected via its next waypoint without teleporting.

## Travel model

Four companies share one worker and fixed-hour engine. The NPCs are a fictional village train, caravan and patrol on seeded itineraries. Fourteen explicit, undirected demo edges cover part of the Maharashtra atlas. The Pune–Ahmadnagar corridor is supported as a broad hint by the pack. Edge geometry, detour factor, distances, terrain classes, daytime schedule, monsoon window, speeds and traffic are tunable simulation assumptions. Preview legs are schematic and require crossing and route research before historical release.

The route preview uses the same movement rules as the simulation. Pune to Ahmadnagar covers 130.531 km and takes **52 elapsed game hours** at steady pace from the initial dawn, including overnight stops. Swift pace and monsoon change travel time. Ration-days are a trip estimate. Full inventory and actual supply consumption belong to M3.

A local 2400×1964 terrain overlay covers 73.35–75° E, 18–19.35° N using Mapzen Terrarium zoom 11. Geographic registration matches the regional relief. Color and hillshade derive from terrain samples, with a feathered edge. The Maharashtra–Goa regional footprint stays the same. Attribution follows [the terrain provenance](M1_terrain.md).

## Checks and limits

Unit checks cover reproducible seeded traffic, arrival versus ETA at every clock speed, pausing, waiting, overnight travel, pace, monsoon, progress-preserving reroutes and rejection of unreachable destinations. Chrome verification covered travel to Saswad, speed switching, paused mid-route state, six-hour waiting and locating the player. [Browser screenshot](screenshots/M2-march.png).

The debug controls step one hour or relocate to a graph node and flag the session modified. Reloading starts a fresh movement preview. NPCs currently travel on itineraries. Trading, raiding, permanent consequences and campaign saves require later systems. Software-rendered browser verification does not certify a sustained 60 fps on target hardware.

## Module handoff

- M3 introduces stocked markets, production, caravan transactions and supply contracts. Test a sale, shortage and recovery; run five simulated years checking price bounds, stock and transfers.
- M4 gives people motives, memory, service and succession. Test a witnessed event, then run multiple seeded generations checking references and population.
- M5 adds encounter interception, raids, auto-battles and sieges. Test losses, retreat, recovery and deterministic replay before expanding careers.
- M6–M7 connect the player careers and tune the whole region through repeated playtests. M8 is a separate optional RTS milestone.
