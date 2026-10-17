# 20 — Feature register, player progression and fun-preservation plan

**Status:** Living scope register; features are not automatically v1 commitments  
**Date:** 2026-10-17  
**Purpose:** Keep the user's long-term game vision visible while delivering it in small, playable, testable slices.

## Product promise

DECCAN LORDS should feel like a proper real-time strategy game while giving the player the freedom and long-term story of a kingdom sandbox. It is not intended to be a simple AoE-style match with a reskinned setting, nor a pure Bannerlord clone with a settlement screen added.

The high-level format is already agreed: a fixed, date-specific world that can diverge into alternate history, a persistent strategic campaign, connected settlement/economic management and real-time tactical battles. The world must react to the player and CPU through common rules and varied data.

Use this document to avoid losing requested features. It is a roadmap and inventory, not a promise that every item ships in the first release.

## 1. Default player fantasy and progression

### Starting premise — PROPOSED

The default opening is a young heir/lord inheriting a modest local position: one or more villages and a small fortress/stronghold, with holdings, income, troops and authority appropriate to the chosen start scenario. A town or market centre and extra forts may or may not be part of the initial inheritance; the exact count is open. The father was an established warlord/noble with a network of allies and rivals; his former high authority has passed to a more experienced lord or otherwise become politically unavailable to the heir. The exact father event, date, kingdom, names and starting holdings await the user's master history and later historical research.

The opening should put the player in a world with real people, local needs and political pressure—not force a long tutorial before allowing play.

### Possible progression paths — long-term product goals

1. **Local lord:** govern inherited villages and fortress, protect routes and people, manage revenue and workforce, meet obligations and establish credibility.
2. **Trusted servant / warlord:** perform useful service or favours for a ruler, protect territory, deliver troops or supplies, win/avoid battles wisely, negotiate and build relationships.
3. **Regional power / court personality:** earn or negotiate greater responsibility, revenue rights, privileges, command and influence through reputation, resources, competence, allies and circumstances.
4. **Kingmaker / changing allegiance:** support a ruler or claimant, switch allegiance where plausible, help another kingdom/empire expand, bargain over appointments, join coalitions or resist a superior.
5. **Kingdom founder / independent ruler:** seek sufficient land, strategic holdings, troops, resources, political support, recognition and defensible authority to establish a new kingdom when the simulation's conditions permit.
6. **Emperor or equivalent supreme ruler:** potentially gain a recognized overarching position through the chosen political institutions, military power and coalition/elite support. This is a deep campaign ambition, not a guaranteed linear promotion path.
7. **Other viable play:** merchant-oriented regional power, mercenary commander, outlaw/bandit leader or recovery after defeat, if each path can be given meaningful systems and appropriate limits.

These paths should arise through choices and world conditions, not be separate scripted campaigns that duplicate the same systems. Becoming a king/emperor should not be a button or just an arbitrary XP level. Eligibility may depend on territory, strategic locations, political legitimacy/recognition, available funds, military strength, supporters, rivals and context-specific institutions. Exact thresholds are OPEN and should be based on the selected historical start and playtests.

### First hours and the fun rhythm

- The player can quickly inspect holdings, household/economic condition, treasury, army, obligations, nearby rulers and threats.
- Early choices produce visible consequences in a short play session: secure a village, meet an obligation, improve a route, resolve a shortage, trade goods, train a small force, negotiate a favour, patrol or respond to a raid.
- In the medium term, settlement prosperity, trade, recruitment and relationships open different opportunities.
- In the long term, successful expansion creates new responsibilities and enemies; defeat leaves recoverable but meaningful damage rather than automatically ending the whole sandbox.
- The player should be free to make unexpected strategies, but exploitable loops should not render all other options irrelevant.

## 2. Feature inventory and delivery scope

Labels:
- **Foundation:** required for the first playable identity or needed to support several other features.
- **Core campaign:** important to the intended full game but staged after the initial slice.
- **Advanced:** significant design/implementation cost; do after supporting systems work.
- **Optional / sensitive:** discuss tone, history, age-rating, balance and ethical consequences before implementation.
- **Future:** multiplayer or other unapproved expansions; not v1 scope.

### A. Map, settlements and construction

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Fixed, date-specific strategic geography | Hand-authored/researched major terrain, rivers, passes, routes and locations; world evolves into alternate history | Foundation; full footprint staged |
| Villages, towns, cities, forts and castles | Different populations, functions, capacity, security, resources and political value | Foundation / core campaign |
| Starting holdings by status | Default heir begins with village(s) and fortress; town and additional holdings depend on scenario/rank | Foundation |
| Settlement local view | Inspect population groups, buildings, work, storage, needs and security; persists when leaving/returning | Foundation |
| Build, upgrade, repair and destroy | Farms, homes, workshops, storehouses, roads, walls, towers, fortifications and related facilities | Core campaign; limited building set in first slice |
| Geography-shaped fort design | Hill/mountain forts, passes and defensive positions differ in visibility, access, capacity and supply | Core campaign |
| Defensive network and coverage | A well-placed fort may protect multiple villages/routes; distance, terrain and response time affect help | Core campaign |
| Settlement growth/decline | Prosperity can attract households and new functions; insecurity/devastation can cause losses, migration or ruins, then recovery | Core campaign |
| Livestock and transport | Animals/worked carts can support food, production and cargo with capacity/speed/cost trade-offs | Advanced |
| Road and infrastructure network | Movement time, trade volume, supply, security and settlement connectivity react to roads/bridges/passes | Core campaign |

### B. Households, manpower, cultivation and production

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Hybrid household/workforce model | Household/housing groups represent people; player assigns labour by category, not every individual | Approved baseline; foundation |
| Housing and household needs | Housing tiers, food/basic demands, services, security and prosperity affect migration/growth/loyalty | Foundation in simplified form; deeper tiers later |
| Labour assignment | Allocate available workforce among farming, woodcutting, mining, crafts, construction, service and military | Foundation |
| Terrain-appropriate production | Soil/water/weather/season/forest/deposits/access determine suitable work and output | Foundation with 2–3 activities |
| Finite and renewable resources | Deposits, cultivation, natural renewal, depletion/recovery and extraction policy affect future production | Core campaign |
| Workshops/factories/craft production | Multiple facility types and conversion chains, historically appropriate to chosen period | Core campaign |
| Research/innovation | Represent period-appropriate engineering, administration, craft, agricultural and military improvements; not a modern generic tech tree unless designed | Advanced |
| Tax/revenue and prosperity | Household welfare, output, tax burden, upkeep, treasury and political obligations interconnect | Foundation, tune later |
| Population/manpower replenishment | Growth and recovery happen under rules, not infinitely and instantly after casualties; new households/persons may arrive over time | Core campaign |

### C. Goods, merchants, trade and finance

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Inventory/storehouses | Goods have quantities and transfer rules; capacity, access, loss and security differ by location | Foundation |
| Markets and buy/sell | Buying/selling changes stocks and money; local availability and transport cost can affect price | Foundation with simplified price bands |
| Production and logistics chains | Source → transport → storage/market/army/household; visible shortages and bottlenecks | Foundation/core |
| Persistent merchants | Actors with capital, inventory, routes, preferences, relationships, friends/rivals and risk tolerance | Core campaign |
| Loans and repayment | Loans fund investment/war; terms, trust, due date, repayment/default and reputation create consequences | Core campaign after market/treasury exists |
| Trader contracts/quests | Buy/sell/deliver/protect/build tasks increase or harm relationships with different stakeholders | Core campaign |
| Caravans and guarded trade | Mobile cargo parties travel, can be escorted/intercepted/looted and can change route after danger | Core campaign |
| Trade alliances and permission | Treaties, access, tolls, embargoes or safe passage influence market links, based on chosen historical rules | Advanced |
| Investment and credit network | Traders may lend to or finance nobles; their own social links can spread influence and debt disputes | Advanced |

### D. Characters, companions, clans and delegation

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Lords, rulers, nobles and family/clans | Persistent named actors with rank, authority, holdings, goals and relationships | Foundation in simplified form |
| Attributes and skills | Skill affects capability; traits affect preference/risk; relationships, knowledge and obligations stay distinct | Foundation |
| Companions | Recruitment, skill specialisation, wages, loyalty, goals and assignments | Core campaign |
| Companion-led parties | Move, patrol, escort, scout, trade or campaign independently with orders and configurable autonomy | Core campaign |
| Delegated settlement/region management | A trusted companion/noble administers routine priorities within granted authority, salary/revenue terms and policy constraints | Core campaign |
| Family and clan networks | Kinship, inheritance, marriage, loyalty, rivalries, successors and political influence | Advanced |
| Recruitment and promotion | Character competence, opportunities and recognition can lead to responsibility; not one fixed ladder | Core campaign |
| Wages and upkeep | Companions, garrisons, parties and armies require costs; inability to pay affects morale/loyalty/availability | Foundation for armies, deeper later |
| Companion limits | Do not add an arbitrary tiny fixed companion cap without playtest; also do not promise literally unlimited agents before UI/performance/economy checks | OPEN |

### E. Politics, law, diplomacy and reputation

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Mixed noble appointments | Salary, land administration, revenue rights/retention/remittance, privileges and service vary by polity/rank/circumstance | High-level structure LOCKED; exact history OPEN |
| Service and favours | Orders, quests, campaigns or help can build trust/reputation and unlock opportunity | Core campaign |
| Policies and obligations | Taxes, levies, garrison obligations, autonomy, local control and revenue remittance create trade-offs | Core campaign |
| Diplomacy and treaties | Peace, war, tribute, trade, alliance, vassalage, safe passage and faction relationships | Core campaign, staged |
| Allegiance and court politics | Serve one superior, change allegiance, become a court influence or kingmaker under plausible rules | Core campaign |
| Kingdom founding and imperial authority | Requires a context-sensitive combination of holdings, resources, support, power and recognition | Advanced campaign goal |
| Reputation and memory | Characters remember important actions/promises, debts, support, betrayal, protection and conflict | Core campaign |
| Cross-cultural/religious governance | Identity, institutions and policy can affect legitimacy/cooperation/unrest; never reduce behavior to simplistic fixed stereotypes | Research/core campaign |
| Succession and marriage | Inheritance, marriage alliances, heirs and faction support | Advanced; historical design first |
| Assassination and spies | Intelligence, covert action, counter-intelligence, discovery and consequence | Optional/advanced; requires explicit design and counterplay |

### F. Army, battle, patrol, siege and warfare

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| RTS battlefield controls | Select units, issue movement/attack/hold/retreat orders, formations and targeting with clear feedback | Foundation |
| Unit roles and composition | Infantry, missile troops, cavalry and period-appropriate specialist roles; faction variation by data | Foundation subset; expand later |
| Formations and positioning | Spacing, facing, terrain, flank/rear, cover, chokepoints and command responsiveness matter | Foundation/core |
| Training and upgrades | Recruit, train or promote troops over time using manpower, money, facilities and equipment | Core campaign |
| Garrison, patrol and guard | Protect settlement/road/fort/convoy areas; patrol coverage and response time matter | Core campaign |
| Mobile parties and army merge/split | Parties move separately and can combine into campaign armies with command, supply and coordination trade-offs | Core campaign |
| Supply and wages | Food, equipment, ammunition/period-appropriate munitions, wages and transport constrain force and campaigns | Foundation in simplified form |
| Rest, healing and recovery | Troops recover at suitable home/camp/barracks and may train/upgrade; rates depend on safety/time/resources | Core campaign |
| Raid, loot and resource transfer | Raid changes inventories, money, production, security, relations and retaliation; loot is transferred, not magically created | Core campaign |
| Captured commanders/prisoners | Ransom, exchange, release or detention, with consequences | Advanced |
| Siege and relief | Encirclement, food/supply, artillery/engineering if period-appropriate, relief army, interception and capture outcomes | Advanced |
| Execute, forced labour or slavery | Historically and ethically sensitive; do not implement without separate explicit design/tone decision, representation and consequence analysis | Optional/sensitive |
| Tactical AI | Threat selection, formation/positioning, morale, fallback, support and objectives | Foundation simple version; advanced later |
| Campaign battle resolution | Tactical results update campaign people, stores, economy, settlement damage, recovery and politics | Foundation for integrated loop |

### G. Environment, living-world simulation and information

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Weather and seasons | Affect cultivation, travel, visibility, supply and health when that adds meaningful choices | Core campaign; simplified early |
| Day/night and lighting | Atmosphere/readability, patrol visibility and tactical context if needed | Polish/core |
| News, letters and reports | Deliver requests, warnings, offers, reports and event consequences; may be delayed/inaccurate | Core campaign |
| Scouts, spies and rumours | NPCs act on information they plausibly know; information may be stale/incomplete or manipulated | Core campaign/advanced |
| AI memory and causal reactions | NPC reasons use goals, resources, relationships, risk, geography, obligations and knowledge | Core campaign |
| Rivalry and retaliation | Raids, debt disputes, broken treaties and betrayal can produce a bounded chain of consequences | Core campaign |
| CPU factions evolve | AI lords/kingdoms expand, negotiate, fight, recover, change allegiance and form new power structures using shared rules | Core campaign |
| Dynamic events | Events arise from world state and actors, with seeded randomness for uncertainty—not only scripted quests | Core campaign |
| Population/resource flows | Casualties, migration, new families, goods, cash, production and wealth have explicit sources/sinks and recovery rules | Core campaign |

### H. Presentation and usability

| Feature | Scope / intended behaviour | Priority |
|---|---|---|
| Distinctive Deccan/Indian art direction | Cohesive architecture, landscape, vegetation, materials, silhouettes, props, units and clothing | Foundation benchmark |
| Readable three-quarter 3D camera | Usable zoom/pan, command precision, terrain clarity and UI legibility | Proposed visual benchmark |
| Polished animation and VFX | Movement, impact, combat, construction, harvesting, weather and environment | Foundation prototype then continuous polish |
| Sound and music | Atmospheric ambience and layered interaction/combat feedback; avoid repetitive alerts/noise | Prototype and continuous polish |
| Notifications | Prioritised, grouped and actionable; urgent need/threat is clear without constant spam | Foundation |
| Save/load and stable UI | Preserve campaign state, handle edge cases and explain failure/recovery | Required before broad integration |
| Onboarding and accessibility | Progressive disclosure; clear commands, key bindings, text, contrast, speed/pause support | Required before public release |

### I. Deferred/conditional features

- **Competitive skirmish/multiplayer:** future possibility only; not an initial release requirement.
- **Large seamless world:** not a first architecture requirement. Strategic, settlement and tactical views can be different scenes over persistent state.
- **Full subcontinent content:** long-term map ambition; validate on a small vertical slice, keep data/model architecture able to expand.
- **Every population member as a deep individual AI:** not required. Household/workforce aggregates for most residents, individual agents for consequential characters.
- **Runtime LLM for CPU decisions:** not planned. Use deterministic/explainable simulation and limited seeded randomness; LLM is a development aid only.
- **All historical people and every feature in v1:** explicitly not assumed.

## 3. Technical architecture rules that support maintainability

- Separate domain/simulation state, data definitions, presentation/animation and UI.
- Use stable IDs for settlements, characters, factions, parties, goods, assets and events.
- Use configuration/resources for balance values and faction differences; avoid one script per named lord.
- Centralize command validation and state transitions so UI, CPU and automated tests use the same rules.
- Keep economy transactions auditable: every money/goods change has an explicit source, destination and reason.
- Make campaign-to-battle translation and battle-result application explicit and testable.
- Version save data and include validation/recovery behavior.
- Use typed GDScript, clear folder/domain boundaries, naming conventions, small scripts, documented public interfaces and tests for important logic.
- No third-party package/MCP/API is added without necessity, maintenance, licence, version compatibility, permissions and cost review.

## 4. Fun and quality gates

A feature is not accepted just because it compiles.

- **Control gate:** selection and command feedback are responsive; pathing doesn't jitter or silently fail; formations remain readable.
- **Strategy gate:** the action has a visible cost, risk and consequence; there is more than one reasonable response.
- **Simulation gate:** money/goods/manpower sources and sinks balance; save/load preserves the same state; important AI choices can be explained.
- **Campaign gate:** after battle or a political/economic event, the world changes and remembers consequences.
- **Usability gate:** a new player can identify the next useful action; notifications do not bury the player.
- **Polish gate:** actual scene screenshots/playtest are reviewed for visuals, animation, audio and responsiveness.
- **Regression gate:** run automated cases and a repeated seed scenario after core changes; keep known issues visible.
- **Scope gate:** each milestone finishes before the next starts. Don't add new layers to avoid polishing the current one.

## 5. External references

See [Reference research and reuse plan](19_reference_research_and_reuse_plan.md) for compatibility, licensing, and milestone-specific guidance for the Godot RTS skill, tutorial series and Open RTS project.
