# 13 — Relationship to the earlier GDD v1.0

The earlier document was titled **DECCAN LORDS — Game Design Document, Version 1.0 (Skeleton Locked), dated 2026-10-14**. It is retained as a historical reference rather than automatically discarded.

## Prior design commitments worth re-evaluating, not blindly inheriting

The earlier GDD specified a Deccan map around 1660, a player beginning as a minor lord with one village, about 20 troops and 100 coin, five core resources (grain, timber, iron, cloth, coin), three unit types (infantry, cavalry, archers), a compact v1 map, a population model based on inhabited villages, four main screens, rule-based NPC reactions, and exclusion of multiplayer/ML/LLM dialogue from v1.

## Where the current vision expands or reopens the earlier design

- The geographic ambition now extends across a much larger part of India, from Delhi toward Kanyakumari; launch scope versus future expansion is OPEN.
- The starting inheritance now includes a clan's history, neighboring friends/rivals, a town and potentially several villages/fortifications; exact starting assets OPEN.
- Housing tiers, household/family growth, differentiated needs, migration and urban growth are more prominent than in the earlier compact simulation.
- Separate supply caravans, animal/livestock transport, raids on logistics, relief efforts and deeper sieges are newly emphasized.
- Political progression could include subordinate lords, companion-led territories, kingship/emperorship, votes and alliances; exact rules and version scope OPEN.
- Session-based multiplayer is a long-term ambition. It remains deferred until the single-player systems are proven, but its requirements should influence modular state/command design.
- The earlier GDD used React + Canvas 2D; the current provisional technical recommendation is Godot 4.x for the main 3D PC game. This requires validation, not an untested rewrite.
- ML was excluded from runtime AI in the old GDD. The current position remains rules/planning first, but allows later experiments if there is a measurable, bounded use case.

## Preservation rule

When a new idea conflicts with the earlier GDD, record the conflict and resolve it in the decision log. Do not assume either the older GDD or a later casual idea automatically wins without discussion.
