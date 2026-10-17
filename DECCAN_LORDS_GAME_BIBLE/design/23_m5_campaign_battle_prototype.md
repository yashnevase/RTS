# M5 — Campaign battle connection

**Status: bounded M5 prototype; see current evidence below.** All encounter content and force composition are provisional fiction, not final balance.

## Playable path

Travel to Kaldar Pass, halt any remaining travel order, then choose **Confront patrol** in the campaign sidebar. This optional encounter uses the existing M2 five-unit forces and seed 173. No route blocking, loot, civilian harm or political reward is introduced.

The campaign owns the active battle simulation; the battle scene renders and commands that same instance. Campaign time and economy remain paused. Existing mouse selection, attack, movement and selected retreat controls apply. **Withdraw all** orders all living troops to retreat; it does not instantly remove them from danger. Once victory, defeat or draw is resolved, **Return to campaign** applies the result exactly once.

The result retains each surviving soldier's stable ID, role and remaining health. Withdrawn living troops survive. Defeated troops are removed from the roster; casualties and the result enter campaign state and the chronicle. The sidebar displays survivors and wounds. A resolved encounter cannot apply its result again. After home recovery and paid replacements, preparing the next patrol creates another encounter opportunity. Standalone M2 retains restart functionality.

## Persistence

Campaign save schema 3 retains the live roster, last outcome/losses and completed patrol count. Schema 1 loads gain an initial encounter; schema 2 adds a completed count derived from its existing status. Existing economy and geography remain intact. Validation checks unique known roster slots, matching roles, bounded positive integer health, whole nonnegative counters, state and outcome before replacing live state. A prepared force must have five fully healed troops.

Save/load is unavailable during active combat. Save before entering or after returning; closing the application during combat does not checkpoint it. The existing save path is preserved.

## Recovery and another patrol — prototype tuning

- Stay at Keshavwadi with no travel order to rest. Each full day heals up to **20 health per wounded troop**, capped at the role maximum, and consumes **1 grain per treated troop**. Settlement production and household consumption happen first. No grain means no healing. Arriving at home does not count as a full rest day.
- Hire one missing roster place at a time at home for **12 coin and 2 grain**. This is an abstract external hiring/equipment/supply cost sink; it does not remove settlement workers. It is not a population or military labour model. No refunds, resale or recruitment beyond five places.
- A replacement fills a stable formation-slot ID; it is not resurrection of a named person. Wounds heal only on surviving troops. Last-battle losses remain recorded even after replacement.
- Once five troops are fully healthy, **Prepare next patrol** unlocks a new optional five-enemy encounter at Kaldar Pass. It changes no treasury, health or completed-count values. Battle completion increments the counter exactly once. Last result remains visible in state and chronicle.
- The regenerated opposing patrol is explicit prototype scenario content, not a persistent rival-army economy. No loot or repeatable victory payout is introduced.

All rates, costs, roster size and patrol availability are provisional implementation choices. They are not locked design or historical claims.

## Boundaries and follow-up

No mid-battle saves, enemy-party persistence, terrain-specific battlefield, loot, damaged holdings, battle-specific political outcomes or military supply/wage model. Strategic travel and caravan escorts still use M4 abstractions rather than tactical troop strength. This slice closes the repeat/recover/save path; it does not fulfill every consequence listed in the aspirational M5 roadmap.

Before broad M6 content growth, define which military strength, route security and political consequences the next encounter should use. A small M6 readability/onboarding pass can now build on the tested loop. Graphics remain prototype quality.

## Evidence

See `../../artifacts/m5/README.md` for commands, checked resolutions, captures and known gaps.
