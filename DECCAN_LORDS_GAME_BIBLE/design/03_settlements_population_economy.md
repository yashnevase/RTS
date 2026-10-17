# 03 — Settlements, households, population and economy

## Core concept from the user

The player inherits populated settlements. People are not just spawned as generic RTS worker units. Settlement growth should be driven by household housing, living conditions, fulfilled needs, safety, prosperity, migration and policy. The player assigns labor to farming, crafts, construction, military service and other roles, within the limits of available households/workforce.

## Housing growth idea — PROPOSED

A small rural settlement may start with huts. Better housing can progress through house and larger clan/civic homes such as a wada. Each housing tier could increase household capacity or the number of people/family members supported (the example capacities 4/6/8/12/15 were illustrative, not chosen values). New families may arrive when living conditions and housing availability are attractive. The exact family/person/workforce abstraction is OPEN.

## Candidate household needs by tier

- Basic rural households: food and fuel/firewood, water/access to essentials, safety.
- Better-off households: clothing, tools, improved services or market access.
- Wealthier households: additional goods, amenities, services, status, or luxury demands.

Needs should not become a checklist of dozens of goods by default. Each added good must create a meaningful production/trade choice. Exact needs, tiers and goods are OPEN.

## Candidate economic loop

1. Households arrive, remain, grow, migrate or leave in response to conditions.
2. The player builds farms, storage, wells, homes, workshops, markets, religious/community structures and defensive works.
3. Available labor is assigned to production and services.
4. Goods are consumed, stored, traded, taxed or used by the army.
5. Tax rate, security, prices, services and shortages affect prosperity, loyalty and population.
6. Prosperity and population support more production, revenue and recruitment—but create additional demand and protection costs.

The loop needs formulas, rates, limits and test examples later. The design should favor understandable cause-and-effect rather than simulation for its own sake.

## Taxes, loyalty and demands

User's concept: residents may accept higher taxes if they receive safety, services, supplies and favorable conditions; high tax with unmet needs or poor protection risks resentment, revolt, flight or decline. This is PROPOSED; the precise relationship must be tuned and explained in UI.

## Settlements can change over time

Candidate stages: hamlet/village → larger village/market town → town/city, with historic centers, geography, population, trade and government affecting what is possible. Warfare or neglect may reduce prosperity, population, infrastructure or settlement status; recovery may take time. Whether a settlement can become a ruin, be permanently destroyed, or be rebuilt is OPEN.

## Labor and war

Open design issue: separate professional soldiers from local levies/militia, and specify what happens to household labor when residents are mobilized. Avoid instantly losing all agriculture because every able person is called to war unless that is the intended strategic trade-off. A family/household abstraction may allow roles to change without tracking each human individually.

## Production and trade

Candidate resources and goods include food/grain, timber/firewood, stone, iron, cloth, tools, livestock, weapons, gunpowder, coin and luxury/market goods. This is not a final resource list. Prefer a small core resource set with regional specializations and trade goods added only where they produce interesting decisions.

## Key edge cases to specify later

Famine, bad monsoon, siege shortages, storage loss, migration, tax revolt, market access, isolated villages, disrupted roads, stolen supply, population recovery after war, production shutdown when labor or inputs are unavailable, and what persists when a settlement changes owner.

## Connected-system extension

The latest cross-system working design—including the approved hybrid household/workforce baseline, geography-aware production, warehouses, markets, household attraction and persistent merchant loans/relationships—is documented in [Connected economy, noble service, merchant networks and military recovery](16_connected_economy_politics_and_ai.md). Use it alongside this file; it does not replace the settlement formulas and open questions here.
