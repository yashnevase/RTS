# 11 — Open questions for discussion

These are prompts, not a questionnaire the user must answer all at once. Work through them in the order that naturally comes up in conversation.

## A. Opening and player identity
1. What exactly happens to the father: death, retirement, betrayal, reassignment, or a selectable backstory?
2. What year does the game begin? Is the world a historically grounded alternate history or a more freely evolving simulation?
3. What does the player personally control: a lord's character, a clan/faction, or both?
4. What are the exact initial holdings: number/type of villages, town, fort(s), households, treasury, troops and allies?
5. Is the player named/customized, and do personal stats matter in v1?

## B. Map scale and zoom
6. The desired world is a large fixed, researched map extending from Delhi toward Kanyakumari. What geographic boundaries, locations and routes must be represented, and what historical start date fixes the roster?
7. How are strategic map, local settlement management and tactical battlefield connected?
8. Which simulation details must be maintained for every entity at all times, and which can update at a cheaper cadence while remaining behaviorally consistent?
9. Which locations, settlement types and entity interactions must be represented in the first vertical slice to validate the full-world model?

## C. Settlements and population
10. Is the basic unit a person, family/household, or workforce point?
11. What exactly does a housing upgrade increase: people, families, labor, tax, status, or a combination?
12. What goods/services do households need at each tier?
13. Which needs must be fulfilled continuously versus supplied periodically?
14. How do tax, safety, prosperity, culture/religion and ruler reputation affect migration and unrest?
15. Can settlements be permanently destroyed, temporarily ruined, captured intact, or rebuilt?

## D. Economy and logistics
16. What are the core resources and which are goods versus abstract values?
17. Are supplies transported on separate map entities, attached to armies, or both?
18. How is a convoy loaded, escorted, raided, captured or recovered?
19. How are trade routes, market access, prices and regional specialties represented?

## E. Military and forts
20. Which units are available at the start, and how do local levies differ from professional troops?
21. Are battles fully real-time, pausable real-time, or a separate tactical scenario?
22. How are army size, command responsiveness, morale and retreat handled?
23. What can be built/customized in a fort or a walled town?
24. How should siege food, relief armies, camps, artillery, surrender and post-siege outcomes work?

## F. Politics and NPCs
25. What are the political ranks and the powers/obligations at each rank?
26. What makes a ruler accept another lord as king/emperor—military force, votes, relations, treaties, recognition or a combination?
27. Which actions affect trust, fear, honor/reputation and allegiance?
28. Can companions govern, recruit followers, become nobles, or found their own polities in the first release?
29. Which decisions must NPCs explain to the player?

## G. Style, UX and competitive goals
30. Is the view fixed/isometric-like, freely rotated 3D, or a controlled hybrid?
31. Which three visual references matter most, and what should not be copied from each?
32. Should the first experience be mostly peaceful, tutorialized through threats, or immediately military?
33. Do competitive modes use the same progression and economy as campaign, or a balanced ruleset?

## H. Historical and ethical research
34. Which regions, peoples, titles, terms and institutions does the user want represented accurately?
35. How should warfare, captivity, looting, slavery, religious institutions and civilian harm be represented in tone and age rating?
36. What level of historical fidelity is desired when it conflicts with strategic balance or player freedom?

## I. Connected economy, politics and military recovery

37. Which rights come with a noble's appointment: salary, land administration, tax/revenue collection, retained income after remitting a share, privileges, troop duties, or combinations?
38. Who sets a lord's obligations, and how can a ruler increase, negotiate, revoke or reassign them? What follows excellent service, partial performance or failure?
39. Which holdings are inherited, granted, administered for a superior, owned outright or occupied by force? How does that distinction affect succession, taxation and changing allegiance?
40. What state should a persistent merchant track: capital, inventory, routes, credit, partners, debts, friendships, rivalries and rumours? Which is essential in the first prototype?
41. What governs loan size, fee/interest, deadline, collateral where appropriate, repayment, default, negotiation and consequences? Can a merchant ask a connected noble for help collecting a debt?
42. Should initial market prices be fixed by region, updated in supply/demand bands, or calculated from local inventories and transport costs?
43. Which production facilities and chains matter first, and how should soil, rainfall, terrain, water, forest, ore, labour and roads constrain them?
44. How do warehouses differ in capacity, security and access? Can stock be reserved for households, markets, armies or contracts?
45. Which household needs trigger upgrades, and when do prosperous new families arrive? How should growth balance food, jobs, housing, services and labour?
46. Which recovery factors matter for civilians and troops: time, safety, food, home/camp/barracks, support facilities or upgrades?
47. How do parties merge/split into field armies, and how do command, wages, speed, morale, supply and commanders change?
48. What can an NPC learn from a raid or betrayal, and how should witnesses, scouts, spies, reports, rumours and merchant networks influence retaliation?
49. Which resources replenish naturally, which are extracted from finite deposits, and which can expand through new settlements, trade or investment?
50. Which user-provided historical observations should become behavior examples for CPU rules, and which are analogy or fiction rather than asserted fact?

## Suggested immediate conversation order

The user has approved a hybrid household/workforce approach as the working baseline. Next, collect historical and tactical examples as the user is ready. In parallel, clarify one concrete noble appointment/revenue example and one merchant-credit scenario. Then define a small representative simulation joining household needs, production, a market/warehouse, a lord's obligation, a mobile party and an NPC reaction. Keep detailed formulas and content counts OPEN until the interactions make sense.


## Agreed direction from 2026-10-17 — keep detailed content questions open

- **Historical treatment:** fictional alternate-history Deccan setting, not a strict reenactment. No requirement to feature Shivaji, Maratha history or exact real-person biographies. Invented Deccan kingdoms/clans/leaders may coexist with broadly inspired empires such as a Mughal-style power. Exact names, count, boundaries and chronology still need a focused design pass; do not block the first RTS prototype on them.
- **Campaign geography:** prefer an authored, persistent strategic map for the main campaign, with named cities, villages, forts, roads, rivers, terrain, factions, characters and relationships represented as data. Exact geography and the eventual map extent are still open. Build one compact, convincing starting region first, then expand using the same data-driven structures. Random/generated maps are an optional later skirmish feature, not the main campaign foundation.
- **Content versus prototype:** the feature register preserves long-term ambitions, but the first playable proof should demonstrate responsive RTS controls/combat and the beginning of the settlement/campaign connection. Broader map content and detailed systems are added incrementally after the benchmark works.
