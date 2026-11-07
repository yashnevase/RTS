# Simulation specification — review draft

All numerical constants below are TUNABLE gameplay proposals, not historical measurements. OPEN family/culture/naval rules in DECISIONS.md block their implementation.

## Time and determinism

One tick = 1 game hour (TUNABLE). Commands execute at a tick boundary in sequence order. Stable phases: commands, movement/encounters, daily supply/economy, weekly political/AI planning, seasonal modifiers, event publication. Daily interval 24 ticks and weekly interval 168 ticks (both TUNABLE). Calendar seasonal mapping must be authored explicitly; do not assume Gregorian quarter boundaries equal local monsoon dates.

Use a specified integer PRNG algorithm, recommended xoshiro128**, with four unsigned 32-bit state words per stream. Root seed expands via a versioned hash of root seed + stable system ID + stable entity ID; use per-system/entity streams so new systems do not consume existing rolls. Nonzero state required. Serialize every stream and algorithm version. Fixed-point integer arithmetic for money, supply and movement; sorted ID iteration, stable ties, no wall-clock inputs. Changing an algorithm requires a simulation version and golden replay update.

## Proposed rule tables

Clamp(x,a,b) bounds x; all weights, ranges, floors and schedules are TUNABLE. Missing historical values are not automatically filled by these formulas: scenario assumptions must be explicit.

| System | Inputs → outputs | Formula / tunable starting rule |
|---|---|---|
| Movement | Edge length, terrain, supply, party → position/arrival | distance/tick = baseSpeed / terrainCost × season × condition; baseSpeed=4 km/hour (TUNABLE); road=.6, plain=1, hills=1.8, mountains=3 cost (TUNABLE). Rivers require explicit crossings. No movement along structural node stubs. |
| Supply | Heads, goods, storage → stock/fatigue | demand=heads×ration; ration=1 abstract unit/day (TUNABLE); consume min(stock,demand); unmet fraction raises fatigue and reduces morale. Forage limited by region stock and recovery. |
| Production | Inputs, labor proxy, capacity → goods | output=min(capacity,available input/recipe); reserve inputs before execution, then settle output. No negative inventory. Unknown populations cannot become labor counts without labelled assumptions. |
| Prices | Stock,target,demand → quote | basePrice×clamp((target+epsilon)/(stock+epsilon),.25,4); epsilon=1 (all TUNABLE). Quote includes quantity, transport and fees; transaction recomputes against reserved stock. |
| Trade | Quotes, route risk, capital → caravan plan | expectedProfit=sale−purchase−wages−tolls−riskReserve; riskReserve=lossProbability×cargoValue; reject insolvent purchases. |
| Tax | Realized revenue, rights → transfers/unrest | collected=taxableRevenue×rate×collectionEfficiency; initial rate=.1 (TUNABLE). Rights allocate collected money, never duplicate it. Arrears tracked separately. |
| Recruitment | Eligible pool, wage, availability → recruits | accepted=min(request,pool,affordable); recovery capped at pool target; initial weekly recovery=.05×target (TUNABLE). Pool targets require explicit scenario assumptions. |
| Training | Experience, upgrade rule, funds → troop upgrades | apply only when experience threshold met and equipment/cost paid; thresholds are data rows, no historical troop constants in code. |
| Morale | Supply, wages, losses, leader → morale | dailyChange=2×supplySatisfied+1×paid−5×casualtyFraction−3×unpaid; clamp 0..100 (all TUNABLE). Leadership modifier bounded ±.2 (TUNABLE). |
| Auto-battle | Troops, terrain, orders, leaders, morale → losses/report | strength=sum(count×combatRating)×terrain×moraleFactor×supplyFactor×commandFactor. Round casualties=min(remaining,round(incomingStrength/defense×exposure×seededNoise)); exposure=.02; noise=.9..1.1 (TUNABLE). Simultaneous casualties; morale/retreat checked after each round; round cap=100 (TUNABLE), then disengage/stalemate. |
| Siege | Stock, blockade coverage, works → readiness/assault | dailyStock=max(0,stock−demand+unblockedSupply); works gain=engineers×workRate; assault uses auto-battle with fort defense modifier. Starvation causes bounded attrition only after unmet demand. All rates in siege profile. |
| Relations | Directed event memories → dimensions | dimension=clamp(base+sum(eventWeight×decay(age)),−100,100); decay half-life=365 days (TUNABLE), with permanent obligations separate. Betrayal affects known witnesses, not omniscient world reputation. |
| Personality | Values, needs, memories → preferences | Utility weights individual loyalty, ambition, empathy, identity salience and risk tolerance. No universal good/bad scalar. Traits may change slowly after repeated events, never fresh random personality daily. |
| AI | Legal actions, beliefs, resources → command | score=expectedBenefit−risk−cost+obligation+relationshipFit+goalFit; normalize components to −1..1; proposed equal weights=1 (TUNABLE). Choose best legal affordable action; seeded tie-break only. Commitment lasts 24h (TUNABLE), interrupted by danger/resource invalidation. |
| Succession | Death, eligible relatives, laws → claims/transfer | Freeze offices, evaluate dated eligibility rules, publish claims, transfer rights after rule resolution; unresolved succession becomes regency/dispute, never orphan references. Marriage/adoption/eligibility formulas remain OPEN. |
| Demography | Birth/death eligibility, households → generations | Run weekly eligibility and yearly aging; historical birth/death facts separate from simulated future events. Fertility/mortality tables and generation permission remain OPEN. |
| Quests | Shortages/threats/relationships → offers | Generate only from actual state needs; reserve reward and target; cancel with explanation if need/target expires. |

Battle reports expose strength factors, orders, losses, captures and retreat cause. Later RTS consumes identical input and returns the same outcome contract; validate distributions rather than requiring identical casualties.

## Stability and developer controls

Monthly diagnostics: character counts, polity share, prices, stock, insolvency, route congestion, missing references. Soak seeds must include fragmentation, recovery and multiple surviving powers; do not force historical outcomes or guarantee no empire can succeed. Console commands use the same command pipeline and replay log; mark saves modified, offer snapshots and reset, and permit seeded event injection. Console never directly mutates state behind the event system.
