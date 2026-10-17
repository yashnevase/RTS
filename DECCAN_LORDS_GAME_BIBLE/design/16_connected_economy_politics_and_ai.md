# 16 — Connected economy, noble service, merchant networks and military recovery

**Status: WORKING DESIGN ADDENDUM — the hybrid household/workforce baseline is user-approved; individual mechanics remain PROPOSED or OPEN unless explicitly noted.**  
**Date:** 2026-10-16

**Purpose:** Capture the user's latest connected-systems explanation in one place while its details are still being discovered. This document complements [settlements, population and economy](03_settlements_population_economy.md), [military, logistics and sieges](04_military_logistics_sieges.md), [politics, factions and NPC AI](05_politics_factions_npc_ai.md), and [emergent world events](06_emergent_world_events.md). It does not replace those system documents or lock formulas.

## 1. Confirmed working baseline: hybrid households and workforce

The user explicitly approved a hybrid approach. Households, homes, needs and population development matter, but the player should normally assign labour by role or category rather than manually direct every villager.

A household's housing tier may affect capacity, comfort, needs, prosperity, tax potential and the kind of work its members can support. Example household sizes mentioned by the user are illustrations, not final balance values. Housing can be upgraded when families request it and suitable resources are available. It may be downgraded or lost through neglect, damage or other events; the exact rules are open.

Prosperous and secure settlements with suitable housing and opportunities may attract wandering or new families. Growth creates more potential workers and revenue, but also raises demand for food, homes, services and protection. Population is neither an infinite worker pool nor a number that grows without cost.

## 2. Geography-aware production and investment

The player should be able to invest in their own villages and towns to improve productive capacity and revenue rather than relying only on a fixed tax value.

Potential activities include cultivation suited to the land, forestry/woodcutting, grazing, mining or quarrying where deposits exist, workshops, processing facilities, storage, markets and other period-appropriate enterprises. Local terrain, soil, water, rainfall and seasons, forest cover, ore, labour, roads, security and market access should affect what makes sense and how productive it is.

This draws on Anno-style production choices and connected supply chains, but the content must fit the selected historical period. Do not simply transplant industrial-era factories and goods into a historical Deccan setting. Regional specialties should create reasons to trade. Facilities consume labour, land, money, materials and possibly maintenance; moving people into one job can reduce output elsewhere.

The exact facility roster, crops, resource deposits, processing chains, yields, costs and historical availability remain OPEN.

## 3. Warehouses, markets and the movement of goods and money

Goods should exist as inventories that can be produced, consumed, stored, purchased, sold, transported, reserved for needs, looted or destroyed. They should not teleport freely between settlements or become automatically safe just because they belong to the player.

Warehouses and storehouses vary by capacity, protection, location and access. Larger or safer storage can protect valuable stock, while local storage near a village shortens the distance required to use goods. Concentrating resources in a strong town reduces some risks but can create a valuable target and make supply transfers vulnerable.

Markets should support meaningful buying and selling. Prices may be influenced by local supply and demand, scarcity, travel cost, security, season and access to routes. Start with an understandable model; exact market formula and degree of simulation are OPEN.

Caravans and merchants move goods between places and require time and protection. Guards cost money and manpower. Bandits or rival parties may intercept cargo. Goods captured in raids transfer from one side to another, while damaged trade, lost inventory and changed routes can weaken the victim beyond the immediate loss.

Track **physical goods separately from money**. Trade and taxes often transfer money between actors, while production creates goods and consumption, spoilage, casualties, destruction and extraction change stocks. Money can circulate through wages, purchases, loans, taxes, rents, contracts, tribute and loot; credit creates a future obligation rather than free permanent wealth.

## 4. Merchants and traders are persistent NPCs

Merchants should not be anonymous interfaces that grant unlimited money. Each significant merchant/trader can have a bounded but meaningful profile:

- Capital and inventory; goods or markets of interest; active route, current journey and risk tolerance.
- Friends, rivals, clients, creditors, debtors, protected partners and relationships with nobles, settlements and other merchants.
- Commercial goals and constraints: make profit, complete a contract, find a safer route, recover a debt, protect cargo, expand access or avoid a dangerous region.
- Knowledge gathered from direct observation, business dealings, companions, guards, rumours and trusted contacts. The merchant should not know everything happening on the map.

Candidate interactions include buying and selling goods, arranging trade agreements, offering loans, borrowing money, financing construction or a fortress, hiring escorts, requesting help with a route, negotiating repayment and offering tasks that build a relationship with one actor but may upset another.

A loan can help fund an investment before the player's treasury can afford it. Loan size and terms may depend on merchant capital, trust, reputation, previous repayment, urgency, competing uses for funds, collateral where suitable and social connections. Successful repayment can increase future access; delay or default can damage trust, raise costs, stop future credit, disrupt trade or lead the merchant to ask a well-connected ally for assistance. These reactions should depend on the circumstances, not fire identically every time.

Credit and commercial disputes should create strategic opportunities and risks rather than a single scripted result. A merchant friendly with another noble may report a debt or offer them a commercial opportunity; that noble still evaluates the request based on relationships, resources, obligations and their own interests.

Loan fees/interest, deadlines, collateral, default outcomes, the exact merchant attribute set and historically appropriate financial practices all remain OPEN and require research after the setting's date is chosen.

## 5. Noble holdings, appointments and obligations

**High-level direction now agreed:** use a configurable mix of arrangement components that can vary by kingdom/institution, rank and circumstances. This is not a universal contract with fixed terms. Only the structural principle is locked; historical names, legal rights, revenue formulas and service details remain open until the setting is researched.

Holdings should scale with the noble's rank and circumstances. Do not assume that every lord has a town, a fortress and villages all at once. A relatively minor lord may hold villages and a small fort; a powerful noble may control many villages, multiple forts, one or more towns and a larger region. The historical starting state determines the actual configuration.

A lord's relationship with a superior ruler could combine several arrangements:

- A salary or regular payment.
- Authority to administer a defined area and collect specified revenue.
- A revenue grant or assignment, in which the appointee retains permitted income but must remit an agreed share or amount to the superior.
- Privileges, rank, court access or additional responsibilities/holdings.
- Military or civic obligations: provide troops, join campaigns, protect routes, maintain local order or satisfy revenue/service targets.

These are candidate mechanics, not a claim that all historical systems used the same contract. A ruler's policies can alter the arrangement, within the institutions selected for the period. Strict obedience to demanding orders may produce higher rank or greater privileges while hurting household welfare and long-term productivity. More careful government may preserve local prosperity and future revenue while still meeting the superior's needs. The player should be able to experiment with those trade-offs.

Authority over territory, revenue rights, actual ownership, military occupation and political recognition are related but not identical. The superior may be able to revise an appointment, reassign a holding or revoke a privilege; doing so should have political consequences. An emperor may coexist with kings, subordinate rulers or powerful allies, while local lords operate beneath or alongside broader power structures. The exact hierarchy, titles, salary/revenue/remittance mechanisms, promotion rules and obligations must be researched for the chosen start date.

## 6. Armies, parties, movement and recovery

Small groups led by lords, companions or commanders should be able to move independently on the strategic map. They can patrol, scout, escort, raid, guard routes or respond to local opportunities. Multiple friendly parties may merge to form a larger campaign army, and an army may split into separate groups. Merge/split rules must account for command, speed, morale, supply, wages, leadership and intent. The same core rules should apply to CPU-controlled factions wherever practical.

Mobile actors include armies, small parties, caravans and potentially other resource-bearing groups. They can encounter, observe, follow, intercept, raid or avoid one another. A raid can reward the attacker with part of the cargo or other loot, but may reveal information about the attacker, create witnesses or rumours, harm reputation or trade, and provoke revenge. NPCs react according to what they plausibly know and whether retaliation is worth the risk. Scouts, spies, witnesses, survivors, merchant connections and reports can provide incomplete or incorrect information.

Recovery is separate from recruitment and training:
- Civilian residents can recover in a suitable and safe home.
- Wounded troops can recover over time at a safe camp, barracks, garrison or other suitable facility.
- Food, safety, rest duration and support facilities/upgrades may affect recovery.
- Training develops skill; healing restores surviving wounded people; recruitment/population growth replaces losses.
- Professional troops retained in service continue to require wages and supplies. If the chosen levy model allows temporary levies to return home after being disbanded, they can resume civilian labour rather than remain a permanent idle cost.

Exact healing rates, caps, costs, building upgrades, party sizes, army command rules and levy-return mechanics remain OPEN.

## 7. A shared CPU decision engine

The user will provide historical observations and tactical examples later. These should help define how NPC “brains”, attributes, skills and relationships work. Begin with explainable, reusable rules and formulas; do not assume a machine-learning model is needed for believable behavior.

For each useful behavior example, record:
1. Situation, terrain, distance, weather and current political/economic/military state.
2. Actor's role, rank, traits, skills, relationships, resources, obligations and goals.
3. What the actor knows, what they only suspect, and what remains hidden.
4. The plausible actions available and their costs, risks and likely outcomes.
5. The chosen action and why that choice made sense for this actor.
6. Immediate outcome plus delayed consequences and other actors' responses.

Shared algorithms can use weighted/utility scoring, planning and tactical state machines, while differing data and circumstances create different behavior. Controlled randomness may break ties or add uncertainty, but should not replace causal rules. NPCs should be able to make mistakes based on incomplete information; do not give the CPU omniscience or arbitrary hidden bonuses. Distinguish sourced historical evidence, user-provided interpretation, design inference and fictional illustration in the record.

## 8. Connected cause-and-effect example

A lord borrows from a merchant to build a fort protecting a road and nearby villages. The fort improves safety for a caravan route. More goods reach the market, trade becomes more attractive, a workshop expands and prosperous households move into available housing. Population and revenue rise, but so do food demand, labour competition, upkeep and the lord's ability to attract attention from a superior or rival.

Later, a rival's party attacks a poorly escorted caravan carrying goods between a village and the town. The attacker gains some inventory; the merchant loses stock and may avoid the route or ask for protection. Survivors or scouts provide incomplete information. The merchant's friends and creditors weigh whether to help. The lord can pursue retaliation, negotiate, hire guards, alter storage policy, use the fort to protect the road, or seek support from a superior. The choice affects money, goods, labour, safety, relationships, local prosperity and future risk.

This example illustrates the intended interconnectedness, not a required mission or finalized set of numbers.

## 9. Scope discipline and immediate next work

Do not implement all of these systems simultaneously. First choose one representative vertical slice that exercises the interactions: one settlement with households and labour; two or three geography-appropriate production activities; a warehouse and market; one merchant with a loan or trade contract; a noble with a defined obligation to a superior; one mobile party; and a simple raid/escort response. Test the cause-and-effect chain and UI clarity before multiplying content.

The immediate discovery priorities are:
1. Hear the user's historical and tactical observations as they are ready.
2. Define a concrete noble appointment/revenue example.
3. Define one merchant-loan scenario from offer through investment to repayment or default.
4. Clarify the first resources, production activities and household needs for the chosen historical period.
5. Turn those examples into data schemas, decision inputs, test scenarios and open questions.

The approved hybrid household/workforce approach is the working baseline. All illustrative capacities, formulas, titles, resource lists, loan terms, historical institutions and production chains remain OPEN or PROPOSED unless explicitly approved later.
