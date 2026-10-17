# 02 — World, geography and historical scope

## User's current ambition

The broad ambition is a map spanning a large part of the subcontinent—from the Delhi region toward Kanyakumari—with major historical cities, towns, villages, forts, ports and local power centers. Some settlements may grow into larger towns/cities; neglected or devastated places may temporarily become ruins and later recover. The Deccan is the narrative and political starting point, not necessarily the permanent geographic limit of the dream game.

## Core world model — important clarification

The ambition is a **large, fixed, researched map spanning major parts of the subcontinent—from the Delhi region toward Kanyakumari**. The user explicitly does not want us to assume that a large map is inherently too ambitious merely because it covers a lot of geography.

The intended approach is **fixed geography + reusable systems + varied data**, not a Minecraft-style random world and not bespoke code for every settlement or lord.

- Hand-author or research strategic geography and important real-world locations, routes, rivers, passes, terrain regions and strategic landmarks.
- Represent villages, towns, cities, forts, ports, parties, armies, nobles, factions and rulers through common schemas and reusable behavior systems.
- Differentiate instances through their data: geography, culture, customs, resources, production, population, needs, prosperity, fortification, faction/overlord, rank/authority, army, traits, ambitions, relationships, memories and circumstances.
- A shared system should create distinct outcomes from differing inputs. The same lord decision system may make one noble conciliatory, another suspicious and another aggressive because their goals, traits, information, resources, allies and terrain differ.
- Controlled/seeded randomness can add variation, but random numbers should enrich plausible behavior rather than substitute for rules.
- Reusable entities should not be identical reskinned objects: a hill fort, coastal port and plateau town need different data and relevant rule modifiers while sharing the underlying architecture.

## Scale is not the same as simulation detail

A large geographic map and a fully detailed simulation of every household at every moment are separate decisions. Do not respond to the map ambition by automatically shrinking the world to one small region. First define the shared world model and prove it with a representative slice.

Possible detail levels to evaluate for performance—not as a reason to remove geography:
- **Local detail:** settlements and battles the player is inspecting, owning or interacting with can expose detailed household, building, production and tactical simulation.
- **Strategic simulation:** distant or less relevant places can still exist, change ownership, produce/consume aggregate resources, move, form relationships and participate in wars using cheaper updates where appropriate.
- **Landmarks and routes:** important forts, cities, rivers, ports and passes remain meaningful even when not viewed closely.

These levels are a performance/detail hypothesis to validate. They must not prevent the larger world from behaving consistently or make distant lords/settlements feel like fake decoration. Exact map coverage, update cadence and representation at each zoom level remain design/technical decisions.

## Geography as gameplay

Candidate features from the user's vision:
- Sahyadri and other mountain ranges, hilltops and defensible passes.
- Rivers, bridges/fords and crossing points.
- Plateau farms, forests, grazing areas, roads and coastal trading centers.
- Terrain/weather affecting cultivation, travel speed, visibility, combat and siege endurance.
- Hill forts and settlements with different defensive and economic profiles.
- Routes where armies and slow supply trains can be intercepted.

Every geographical feature should support a real decision. Avoid making every terrain type a separate system if a small number of movement, visibility, production and defense modifiers can create the desired results.

## Historical framing

- Existing GDD baseline: Deccan around 1660.
- Current conversation: wider 1600–1700-era Indian setting and a long-range map aspiration.
- Exact campaign year, political boundaries, named figures, faction roster, settlement roster, and historical/alternate-history boundary are OPEN.

### Preliminary historical narrative received — 17 October 2026

The user supplied an initial narrative draft covering central Deccan, southern India and parts of northern India, mostly c. 1500–1700. It is a pattern-analysis draft, not yet the planned master history spanning c. 1500–1800. Its observations about coalition warfare, changing noble support, strategic forts/routes, economic extraction, campaign costs, merchant networks, succession and local autonomy are valuable design inputs. Some chronology and causal claims need verification; the preliminary claim review and game-design patterns are documented in [Historical pattern intake: first story draft](17_historical_pattern_intake_story_draft_01.md).

Keep the campaign date and faction roster OPEN. Do not make every historical claim a literal game rule or use broad cultural/religious stereotypes as fixed AI behavior. After the master history is supplied, reconcile timelines and relationships before undertaking a larger rewrite of faction data and system rules.

Candidate powers mentioned by the user include Deccan sultanates, Mughal authority, Maratha/Deccan local lords, Siddis, British, Dutch, Portuguese, French, Spanish and Arab-linked trading or political groups. Presence and role must be verified against the selected date and region; do not populate the game just because a power is familiar today.

## Content tiers — proposal

For manageable development, consider marking places as:
- **Playable-detail:** player-owned or locally contested settlements that use household/production/building simulation.
- **Strategic-detail:** AI-held places represented by a simpler aggregate state until the player interacts with them or they become strategically relevant.
- **Named landmark:** important historical location with defined strategic purpose and a lightweight state.

This could make a wide map possible without calculating every home and workshop at equal detail. It requires a test and explicit design decision.

## Historical accuracy policy

Maintain a research ledger with: claim, region/date, source, confidence, game interpretation, and whether the mechanic departs from history for playability. User-provided local knowledge should be captured as valuable research input but not silently represented as independently verified fact. See [research and decision log](12_decision_log.md).
