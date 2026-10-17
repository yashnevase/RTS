# 04 — Military, parties, logistics and sieges

## Desired feel

Combat should offer the readability and command satisfaction of an RTS, while the wider campaign gives armies logistical and political context. The size, speed and detail of battles versus strategic movement remain OPEN.

## Army and party distinctions

Candidate entity types:
- **Lord's field army:** mobile combat formation with commander, troop composition, morale, wages, speed and supply needs.
- **Garrison:** troops attached to a settlement/fortification.
- **Patrol/raiding party:** smaller force used for scouting, escorting, raids or local security.
- **Companion-led party:** an assigned commander with their own orders and configurable autonomy (future scope to assess).
- **Supply caravan/train:** separate, slower non-combat or lightly defended transport party carrying food, livestock, materials, weapons, gunpowder and siege equipment.

These are candidate categories, not locked. Decide whether they are separate simulation entities or modes of one party model.

## Supply-train idea from the user

A large army may be supported by a slower convoy. Heavy loads reduce speed and may affect security. An escort protects supplies but reduces the army's available combat strength; leaving supplies behind may increase march speed but risks shortages. Enemies may raid the convoy, seize supplies or recover dropped goods. A successful defensive strike may disrupt the besieging army's camp or supplies and shorten a siege.

This creates a strong tactical/economic loop, but it risks becoming too much micromanagement. Test whether supplies can be represented with a small number of legible states before adding detailed goods and animals.

## Forts, town walls and settlement defense

The user wants both customizable fortifications and geographic defensive locations. Not every settlement must be a full castle. Candidate distinctions:
- Natural refuge/hilltop stronghold.
- Small fortification or fortified manor.
- Fort controlling a pass or route.
- Walled town/city.
- Major fortress/capital.

Buildings, walls, garrisons and terrain should affect approach routes, defense, siege time, supplies, and strategic control. Exact build rules, footprint, upgrade limits, costs and siege modes are OPEN.

## Sieges — desired possibilities

- Defenders ration food, water, ammunition and other essentials.
- Some civilian population contributes to defense or support, but this must have an explicit cost to local work and survival.
- Attackers require supply and a viable siege camp/encirclement.
- Relief forces, diversionary raids, sabotage, convoy interception or allied attacks can disrupt a siege.
- A weaker defender may survive through terrain, planning, stores, alliances and timing.
- Surrender, negotiated terms, relief, assault, retreat, capture and post-siege consequences need explicit outcomes.

Cannons, gunpowder artillery, specialist siege equipment and period-appropriate engineering require research and careful scope decisions. Do not assume every faction has the same equipment.

## Army types and command

Infantry, cavalry and ranged units are an initial abstraction, not a finalized roster. Later decisions must cover unit roles, formations, command latency, morale, fatigue, terrain, weather, fort bonuses, retreat, capture, casualties, replenishment and how battlefield results update the campaign.

## Reuse of existing prototype

The uploaded Three.js prototype already has selection/movement/combat/pathfinding mechanics that can inform requirements. Reuse is conditional on a focused technical audit. Do not port everything automatically or assume it can be copied directly into Godot.

## Connected-system extension

The cross-system design adds party merge/split, time-based recovery at homes/camps/barracks, and raid outcomes that depend on what the target and its allies can learn and how they evaluate retaliation. See [Connected economy, noble service, merchant networks and military recovery](16_connected_economy_politics_and_ai.md); exact recovery, command and retaliation rules remain open.
