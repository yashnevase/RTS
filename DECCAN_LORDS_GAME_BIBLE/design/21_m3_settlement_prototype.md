# 21 — M3 settlement and economy prototype rules

**Status:** IMPLEMENTED PROTOTYPE — all names, amounts, yields, prices and formulas below are temporary tuning, not historically researched or design-locked.
**Date:** 2026-10-17

This note records the exact rules in `scenes/settlement/m3_settlement.tscn` so a reviewer can inspect the playable slice without mistaking prototype numbers for approved game design. The test settlement name **Keshavwadi** is fictional and does not assert a historical location. The prototype uses an aggregate household/workforce model consistent with the approved working baseline.

## Player loop

1. Review three household groups, their combined population, available workers and current stores.
2. Assign pooled workers to farming, woodcutting or milling.
3. Buy or sell a limited quantity of grain, timber or flour with a finite local merchant stock and coin reserve.
4. Choose no, standard or high tax and inspect projected daily tax and upkeep.
5. Advance one day. Production runs, households consume grain, taxes are collected, upkeep is paid or recorded as arrears, and priority notices explain shortages or stoppages.
6. Save or load the settlement through versioned local JSON persistence.

## Temporary starting data

| Item | Prototype value |
|---|---:|
| Household groups | Field: 8 households / 32 people; woodland: 5 / 20; market: 6 / 24 |
| Total workforce available | 30 |
| Starting assignments | Farm 8; woodcut 3; mill 2 |
| Starting storehouse | Grain 44; timber 18; flour 6; capacity 140 total goods |
| Starting treasury and market coin | Settlement 90; merchant 250 |
| Starting market stock | Grain 48; timber 24; flour 16 |

## Daily order and formulas

The day advances in this order. Integer amounts are used throughout.

1. **Farm:** each assigned worker adds 2 grain, limited by free storehouse space.
2. **Woodcut:** each assigned worker adds 1 timber, limited by the remaining space.
3. **Mill:** each assigned worker can consume 2 grain to create 1 flour. Workers without enough grain do no work. Processing frees one net storehouse unit per flour made.
4. **Households:** grain need is `ceil(total population / 12)`; for the starting 76 people, that is 7 grain/day. The settlement consumes what it has and records any shortfall.
5. **Tax:** tax level is 0 (none), 1 (standard) or 2 (high). Daily coin collected is `floor(households × tax level / 3)`, giving 0, 6 or 12 coin with the starting 19 households.
6. **Upkeep:** daily upkeep is `4 + 2 × number of staffed production activities`; the starting three active activities cost 10 coin/day. Tax is credited first. The treasury pays what it can; remaining upkeep is retained as arrears and added to the next day's bill.

Household coin, wages, prosperity, tax resistance and purchasing are not simulated. Tax is an abstract transfer from the population into the settlement treasury. Unpaid upkeep is a debt on the settlement and reduces future treasury when paid. Goods made by production and grain consumed by households are explicit stock flows.

## Market and storage

Buy/sell prices are fixed prototype values:

| Good | Buy | Sell |
|---|---:|---:|
| Grain | 3 coin | 2 coin |
| Timber | 4 coin | 3 coin |
| Flour | 5 coin | 4 coin |

Trades transfer goods and coin between the settlement and finite local market inventories. A trade fails without enough goods, storage capacity, settlement coin or market coin. Market prices do not change with supply or demand. The settlement storehouse has a shared 140-unit limit; there is no spoilage, theft or reserved stock.

## Notices and persistence

- **Urgent (priority 3):** food shortage and unpaid upkeep.
- **Watch (priority 2):** production stopped by missing mill input or storehouse capacity.
- **Info (priority 1):** settlement setup and routine information.
- The state retains at most eight notices, sorted by priority and recency.
- Save schema version 1 is written at `user://saves/m3_settlement.json` through a temporary file and backup replacement. Loads reject unsupported versions, invalid labour, over-capacity inventories, malformed notices and bad JSON without replacing the active state.

## Prototype boundaries

This slice does not add housing upgrades or attraction, household-specific labour, prosperity or unrest, seasonal or weather effects, day/night, land suitability, building construction, dynamic prices, caravans, credit, political obligations, campaign-map persistence or battle integration. Those remain for later design and milestones. The selected data tests a household/workforce pool, a two-step grain-to-flour chain, a basic food draw, local exchange, taxes/upkeep and recoverable persistence without claiming the values are final.

## M3 evidence

Rules and edge cases are covered by `tests/unit/test_m3_settlement_simulation.gd`. Actual scene interaction is exercised by `tools/m3_interaction_capture.gd`. Screenshots in `../../artifacts/m3/` show the initial settlement and the post-trade/day/save-load state at 1600×900 and 1280×720.
