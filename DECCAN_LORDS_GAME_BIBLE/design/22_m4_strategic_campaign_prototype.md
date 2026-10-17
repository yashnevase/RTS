# 22 — M4 strategic campaign prototype

**Status:** IMPLEMENTED PROTOTYPE — all names, locations, quantities, contract price, travel time and standing effects are temporary fiction/tuning, not historical claims or locked design.
**Date:** 2026-10-17

This note records the bounded strategic-map slice in `scenes/campaign/m4_strategic_campaign.tscn`. Its purpose is to show a persistent campaign state, named authored route graph, one travelling player party, a superior's obligation, an explainable merchant choice and a caravan that changes settlement and political state. The broader map ambition remains authored and can expand by data; this four-location board is a vertical slice.

## Prototype region and entities

| ID | Display name | Role |
|---|---|---|
| `keshavwadi` | Keshavwadi | Player settlement; uses the existing M3 settlement simulation instance |
| `kaldar_pass` | Kaldar Pass | Shared route junction |
| `nandipur` | Nandipur Market | Merchant Leela's starting market |
| `suryagarh` | Suryagarh Fort | Governor Amara's seat |

All four names and the diagrammatic river/landscape are fictional. Routes are authored links: Keshavwadi—Kaldar Pass—Nandipur Market, with Suryagarh Fort also linked to Kaldar Pass. Each link takes one campaign day. Movement uses a shortest path across the route graph. A party keeps its route order until it arrives.

The player controls Rao's Retinue. Governor Amara is the superior and gives a visible obligation: keep the Kaldar route open for the settlement and market. Standing begins at 40/100. Leela of Nandipur begins with 140 coin and 40 grain. The only CPU choice in this slice belongs to Leela; no hidden superior planner is implied.

## Player loop

1. Select a location and advance days to travel. Each campaign day also runs the active M3 settlement simulation, so stores, taxes and upkeep change while the party travels.
2. Reach Nandipur Market and arrange an escorted delivery of 12 grain for 24 coin. The settlement pays the merchant, merchant inventory reserves the grain and the caravan carries it.
3. Set a public route order back to Keshavwadi. Leela departs only if Rao's Retinue is at Nandipur and the party publicly ordered that destination. Otherwise she waits and logs the reason.
4. The party and caravan move over the same authored route. At Keshavwadi, the caravan unloads 12 grain if the party is present and storehouse capacity allows it.
5. Successful delivery raises Governor Amara's standing by 2 and records a chronicle entry explaining the route protection consequence.
6. Save/load preserves campaign actors, routes, pending contract/cargo, merchant knowledge/decision log, relationship state and the nested M3 settlement in one versioned JSON file.

These are prototype quantities and outcomes only. They are chosen to make transfers and cause/effect easy to inspect. They do not claim period prices, historical names, real travel scales or final relationship formulas.

## Explainable information boundary

Leela knows the authored public route and sees a party at her market. She can also observe the player's public destination order. Her decision rule uses only that information and the fact that the contract was accepted: wait for the announced escort or depart when it exists. The visible `MERCHANT DECISION · WHY` panel and activity chronicle retain the reason. She does not inspect the settlement's private stores or infer an unreported party location.

## Persistence and validation

Campaign save schema 1 nests M3 settlement save schema 1. A load constructs and validates a candidate settlement and candidate campaign state first. It rejects unknown locations, malformed routes, invalid actor accounts/relationship standing, malformed logs, unsupported versions and mismatched campaign/settlement days without replacing current state. Save files use `user://saves/m4_campaign.json` with temporary-file replacement and a backup path.

## Deliberate boundaries

This is not the full strategic layer: there is no encounter/raid simulation, dynamic route danger, fog of war, rival army planner, party composition/upkeep, political negotiation, credit, variable pricing, time speed controls, weather, day/night or tactical-battle transition. M5 is the campaign-to-battle connection. The current M4 region illustration is a readable map board, not a researched geographic map or final 3D art direction.

## M4 evidence

`tests/unit/test_m4_campaign_simulation.gd` checks routing, invalid commands, daily settlement updates, merchant knowledge-based decisions, contract accounting, delivery/standing consequences, malformed saves and file save/load. `tools/m4_interaction_capture.gd` exercises the actual campaign and settlement UI at 1600×900 and 1280×720. Captures are in `../../artifacts/m4/`.
