# 05 — Politics, factions, companions and NPC decision-making

## Political fantasy

The player begins as a local hereditary lord in a hierarchy of overlapping clan, village, fort, regional, kingdom and imperial power. Authority is not merely a map color: it may depend on allegiance, revenue, military obligation, recognition, relationships, prestige, fear, family ties and a ruler's ability to protect subordinates.

The exact number and names of political levels are OPEN. The game should not force a single linear promotion path if the player can become a rival, mercenary or outlaw.

## High-level agreement: mixed noble-service arrangements

**LOCKED at the structural level only:** noble authority and revenue arrangements should be able to vary with kingdom/institution, rank, circumstances and the ruler's policy. Do not force every noble into one universal salary model or one universal land/revenue model. A single relationship may combine several components, such as salary, authority to administer territory, revenue rights, remittance, privileges and military/service duties.

This does **not** lock the historic names, the legal meaning of landholding, who owns or appoints what, numerical shares, rank ladders, or any particular period's institutions. Those remain OPEN until the start date and historical context are researched.

## Reusable entities, different outcomes

The world should use a common simulation engine rather than bespoke implementations for each lord, clan, kingdom or faction. Variety comes from combinations of:

- **Role and authority:** local noble, clan leader, governor, Sultan/king, emperor, civic or religious authority where relevant, mercenary leader, bandit chief, companion.
- **Personal traits:** ambition, risk tolerance, caution, greed, generosity, trustworthiness, pride, patience and military confidence—only where each trait creates a distinguishable effect.
- **Interests and goals:** protect a holding, gain rank, accumulate wealth, serve an overlord, expand, defend a community, gain independence, avenge an insult or replace a superior.
- **Context:** geography, climate, roads and passes, local resources, population, treasury, army, supply, allies, threats, current wars and available opportunities.
- **Relationships and history:** clan ties, overlord/vassal links, promises, gifts, betrayals, favors, grudges, past outcomes and confidence in information.
- **Culture and faction profile:** names, appearance, colors, architecture, relevant customs, institutions, military traditions and diplomacy preferences supported by research.

The same underlying decision framework can therefore produce different outcomes from different data. Avoid creating a unique hard-coded AI for every named character. Use reusable templates, profiles, relationship links and shared rules; reserve scripted exceptions for specific authored scenarios and document their purpose.

## Relationships

Candidate relationship dimensions:
- Personal relations / trust.
- Allegiance to current superior.
- Fear and estimate of military strength.
- Ambition and risk tolerance.
- Greed / material motivation.
- Reputation for keeping promises, generosity, cruelty or reliability.
- Kinship, clan ties and past events.
- Memory of a bounded set of recent meaningful actions.
- Knowledge confidence: what the NPC believes about the player and other lords.

Avoid duplicate stats that all mean “friendliness.” Each variable should have a distinct mechanical effect and visible explanation where possible.

## Political actions — candidate list

Gifts, tribute, requests for support, hiring service, treaties, alliance, non-aggression, military access, trade contracts, promises, betrayal, spying, rumor, bribery, protection, vassalage, rebellion, secession, surrender, succession or election by nobles, and recognition of a new ruler. Marriage, dynasty and succession scope need special treatment and may belong in a later version.

## Companion and governor ambition

The user wants companions with statistics who can be assigned to lead parties or take responsibility for territories and perhaps become allied lords/kings later. This is a major feature because delegated companions can change the scale of the world. V1 must define whether companions can only command parties or can independently govern and found higher political entities.

## Candidate AI decision architecture

**PROPOSED: use explainable, data-driven AI first.**
- Utility scoring ranks valid options based on goals, personality, resources, relations, threats, opportunity and expected payoff.
- A planner (for example, goal-oriented action planning) can assemble steps toward goals such as raising an army or capturing a pass.
- Tactical behavior trees/state machines handle immediate unit/army execution.
- Bounded randomness and seeded testing provide variation while keeping scenarios reproducible.
- A memory/state system records significant interactions and consequences.

ML is not rejected forever. It should only enter runtime decision-making when a specific measurable problem is defined, and its behavior can be tested, bounded and kept fair. ML might first assist with offline balance analysis, playtest clustering or content generation.

## Political hierarchy / player progression

Potential path: minor heir → recognized local lord → regional power/vassal or independent claimant → king/ruler of a realm → emperor or leader of a multi-king coalition. The user has suggested requiring a minimum number of holdings, forts, allied rulers and political recognition for higher status. All exact prerequisites, votes, titles, inheritance rules and consequences are OPEN.

## AI personality without chaos

Different lords can share the same algorithm but have different goals, fears, budgets, geography, allies, memories, military doctrine and risk preferences. Their actions should be driven by explainable state and constraints, not arbitrary hidden advantages. Randomness should select among plausible options, not replace planning.

## Connected-system extension

The cross-system design expands noble appointments/revenue obligations and merchant social networks, credit, debt disputes and information sharing. It also sets out a structured method for capturing the user's future historical observations as testable NPC-behavior scenarios. See [Connected economy, noble service, merchant networks and military recovery](16_connected_economy_politics_and_ai.md). Exact historical institutions and formulas remain open.
