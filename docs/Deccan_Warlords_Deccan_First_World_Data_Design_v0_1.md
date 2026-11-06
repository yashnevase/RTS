# DECCAN WARLORDS
## Deccan-First World, Geography & Simulation Data Design

**Document:** World Data Design Specification  
**Version:** 0.1 — working design baseline  
**Date:** 6 November 2026  
**Status:** Design direction consolidated; historical population and balance values remain to be researched and approved.  
**Relationship to project brief:** Additive decision document for the existing *Deccan Warlords: Codex Project Brief*. Where this document changes the original all-India map scope, this newer Deccan-first direction takes precedence after the user confirms it.

---

# 0. Purpose and scope

This document turns the current game vision into a structured plan for the world data and simulation rules. It covers the geography, regions, settlements, political entities, characters, families, clans, relationships, personality, attributes, skills, troops, economy, governance, military logistics, AI and long-term campaign evolution.

It is deliberately **not** a finished census of every historical person, clan, village, fort or troop. That information must be researched region by region and tied to dated sources. This document defines what information the game needs, how it is connected, how it affects gameplay, and how to add it without rewriting the simulation.

## 0.1 Current design direction

1. **Build a detailed Deccan-centred campaign first.** The first map should cover the southern and central Indian theatre around the Deccan and its connected regions, rather than attempting equally detailed coverage from Delhi to Bengal immediately.
2. **Include the peninsula southward to the southern tip.** The map should not stop at Maharashtra or the Deccan Plateau. It should include the important connected regions of Karnataka, Telangana, Andhra, Tamil country and Kerala.
3. **Include the central frontier needed to make the Deccan believable.** Include the Narmada/Tapti approaches, southern Madhya Pradesh, the Gondwana belt, Berar/Vidarbha, Khandesh and other relevant gateways. The final northern edge should be a shaped geographic boundary, not an arbitrary straight line.
4. **Reserve northern India for modular future expansion.** Delhi, Punjab, most of Rajasthan, the Ganga plain and Bengal do not need full settlement density in the first release. They can be added later as regional data packs connected to the existing world graph.
5. **Do not create a pre-existing Maratha kingdom at the 1622 start.** Maratha/Marathi-related identities, houses and military service networks can exist in the world, with different families serving different rulers. A later independent polity may emerge through player or NPC actions; it must not be forced by a hard-coded historical script.
6. **Treat family, clan, culture, language, religion, political allegiance and social position as separate concepts.** They influence one another through contextual rules, but none should be treated as interchangeable.
7. **The world runs independently of the player.** Characters age, form families, change patrons, acquire estates, lose wars, die and are replaced by new generations over a long campaign.

## 0.2 What the game is

- A Bannerlord-style 2D campaign-map sandbox.
- A world of moving parties, settlements, forts, trade routes, armies, factions, families and political relationships.
- Pausable real-time movement with speed controls; encounters and decisions are resolved through menus and simulation systems.
- A deterministic, data-driven simulation core. The same initial seed and player commands should reproduce the same simulation outcomes.
- A 200–300-year-capable living world, with scenario starts and a minimum playable historical period around 1600–1700.
- A strategy game where the player can trade, travel, serve a ruler, become a mercenary, raid, govern, build a clan, marry, inherit, rebel, found a kingdom or become a kingmaker.

## 0.3 What the first world build is not

- It is not a complete modern map of India with every contemporary administrative boundary.
- It is not a rigid historical reenactment that forces every historical outcome.
- It is not a single-faction-per-culture design.
- It is not a fixed list of seven permanent kingdoms for every year from 1585 to 1785.
- It is not an exhaustive roster of every historical person in the first data pass.
- It does not need manual RTS battles, 3D roaming, arena or smithing systems to establish the campaign world.

---

# 1. Map scope: Deccan-first, with future expansion built in

## 1.1 Recommended first campaign extent

Use a **Deccan and connected peninsular India** map. As a provisional GIS working envelope, begin testing around:

- **North:** the southern Madhya Pradesh / Narmada–Tapti–Satpura / Vindhya approaches, with selected northern gateways where needed for historical campaigns.
- **South:** the southern tip of the peninsula, including the Kerala and Tamil regions.
- **West:** the Arabian Sea, Konkan, Goa and the relevant southern Gujarat/Khandesh approaches.
- **East:** the Bay of Bengal coast through the Andhra and selected southern Odisha corridor.

A rough initial bounding rectangle for GIS experiments may be approximately **8°N–24.5°N and 70.5°E–87.5°E**, but this is **not a locked final map boundary**. The final boundary should be shaped to preserve important connected regions and avoid cutting through a strategically important river basin, fort network or polity. The map may include a small buffer outside the playable boundary for incoming armies, caravans and political pressure.

## 1.2 Regions to include in the detailed first map

The following are working macro-regions. They are not meant to be modern states, and they do not imply one unified historical ruler.

| Macro-region | Geographic and gameplay content to represent |
|---|---|
| Southern Madhya Pradesh and Narmada frontier | Narmada valley approaches, Satpura/Vindhya routes, forest corridors, gateways into Malwa and Gondwana |
| Khandesh and Tapi basin | Tapi valley, Burhanpur approach, frontier forts, river crossings, routes between north and the Deccan |
| Berar and Vidarbha | Fertile plains, Wardha/Wainganga/Penganga basins, market centres, forts and Gondwana connections |
| Gondwana and central Indian forest belt | Forest and hill regions, local Gond polities and chiefs, forts, passes, routes and resource settlements |
| Ahmadnagar–Marathwada region | Ahmadnagar, Daulatabad/Deogiri, Parenda, Naldurg and associated towns, villages, estates and routes |
| Western Maharashtra plateau | Pune and surrounding countryside, Bhima basin, hill systems, fort networks, local estates and market villages |
| Konkan and northern Kanara coast | Narrow coastal belt, Sahyadri escarpment, ghats, ports, creeks, island forts and coastal routes |
| Goa and central/western coast | Portuguese-held and locally controlled coastal sites, hinterland routes, ports and trade connections |
| Bijapur and northern Karnataka | Bijapur, Gulbarga/Kalaburagi, Bidar, Raichur, Mudgal, the Krishna–Tungabhadra frontier and related fort networks |
| Telangana and Golconda | Golconda, Warangal, Bhongir and other fortified centres, tank irrigation, dry-farming regions and eastern trade access |
| Krishna–Godavari and coastal Andhra | River valleys, deltas, ports, market towns, routes inland, coastal trading establishments and regional rulers |
| Southern Karnataka and Mysore uplands | Mysore, Seringapatam/Srirangapatna, plateau routes, hill and forest corridors, Keladi/Ikkeri connections where appropriate |
| Rayalaseema and Tungabhadra frontier | Dry plateau, rocky terrain, forts, river crossings, military corridors and successor-state politics |
| Tamil country and Coromandel | Gingee/Senji, Thanjavur, Madurai and other Nayak-era centres; Kaveri basin, eastern ports and inland routes |
| Malabar and Kerala coast | Calicut, Cannanore, Cochin, Quilon and Venad-area centres; pepper trade, backwaters, coastal routes and Western Ghats passes |
| Southern tip and cross-peninsula routes | Cape Comorin/Kanyakumari area, routes connecting Malabar and Coromandel, southern coastal and inland settlements |

The first implementation does not need every macro-region to have equal detail. The Deccan heartland and its immediate frontiers should be densest, while distant southern or eastern regions can have fewer simulation objects at first. But the dataset format must support the same depth everywhere.

## 1.3 Future expansion packs

Later additions should extend the same world rather than create a second incompatible map.

Potential expansion packs:

- **North and Mughal heartland:** Delhi, Agra, upper Ganga-Yamuna plain and additional Punjab approaches.
- **Rajasthan and western India:** Rajput states, desert routes, Gujarat beyond the initial southern gateway.
- **Eastern India:** wider Odisha, Bengal delta and connected inland polities.
- **North-western frontier:** additional Punjab and north-western regions if the game scope expands.

A future region pack must add new region IDs, sites, routes, cultures, polities and scenario snapshots. It must not change the IDs of existing places or require a rewrite of movement, settlement, relation or faction systems.

## 1.4 Map completeness levels

Not every place needs the same level of simulation detail. Each region and settlement should declare a detail tier:

- **Tier A — fully simulated:** major cities, important forts, active ports, key villages, strategic passes and high-value market centres. Full population/economy/ownership/AI records.
- **Tier B — standard simulation:** ordinary towns, villages and forts. Core population, production, ownership, security and loyalty records.
- **Tier C — represented location:** small villages, minor forts, shrines, crossings, mines or landmarks. May use simplified production and limited AI.
- **Tier D — map feature:** unnamed terrain, forest, pass or route segment without a settlement-level population.

Tier C and D objects can be promoted to A or B in later updates without changing their IDs.

---

# 2. Geography and campaign-map data

## 2.1 Three separate representations

The map should combine three types of data:

### A. Physical map layers

- Elevation / digital elevation model.
- Slope and ruggedness.
- Coastline, lakes, rivers and drainage basins.
- Land cover and vegetation classes.
- Forest and scrub areas.
- Climate zones, rainfall and seasonal flood tendency.
- Soil and agricultural suitability where reliable data exists.

### B. Historical and game geography

- Geographic regions and sub-regions.
- Mountain ranges, plateaus, valleys and plains.
- Ghats, passes, fords, bridges and ferries.
- Historic roads, tracks, trade corridors and caravan routes.
- Ports, harbours, anchorages and coastal hazards.
- Forts, fortified settlements, towns, villages, markets and resource sites.

### C. Campaign navigation graph

The simulation should not infer all movement from the painted map. Build a graph containing:

- Nodes: settlements, forts, passes, river crossings, ports, road junctions and other strategic points.
- Edges: roads, trails, terrain corridors, river crossings and sea routes where supported.
- Edge data: distance, terrain profile, normal travel cost, seasonal cost, carrying capacity, risk, toll, control and closure conditions.

The movement simulation uses this graph and/or a derived grid. The renderer displays a beautiful painted map. The visual art must never be the only source of movement truth.

## 2.2 Physical features that must matter

| Feature | Simulation effects |
|---|---|
| Narmada and Tapi valleys | North–south access routes, river crossings, fertile settlement zones and strategic frontiers |
| Satpura and Vindhya ranges | Route funnels, difficult movement and defensive terrain |
| Western Ghats / Sahyadri | Strong separation between plateau and Konkan, pass control, rain-shadow effects and fort locations |
| Konkan strip | Coastal trade, narrow travel corridors, creeks, forest, high strategic value of passes and ports |
| Deccan plateau | Long-distance movement, dry-season water and supply concerns, black-soil agricultural zones and exposed routes |
| Godavari basin | Major east–west and north–south corridors, delta and inland trade connections |
| Krishna basin | Fertile plains, crossings, strategic river frontiers and routes into Telangana and Karnataka |
| Bhima basin | Western Deccan settlement and movement corridors |
| Tungabhadra / Raichur doab | Major conflict and movement zone between Deccan and southern powers |
| Kaveri basin and delta | Fertile agricultural and settlement concentration, irrigation and high-value routes |
| Telangana tank-irrigation regions | Seasonal water management, tank infrastructure and local agricultural variation |
| Malabar coast and backwaters | Pepper trade, coastal movement, ports and monsoon-sensitive maritime activity |
| Coromandel coast | Coastal trade, ports and links to southern/eastern polities |
| Gondwana forest and hill belts | Concealment, difficult movement, local political autonomy, ambush and resource zones |
| Dry plateau and scrub | Water and food pressure, dispersed settlements and long supply lines |

## 2.3 Terrain classes and movement costs

The original project brief already proposes relative starter movement costs. Preserve them as initial tunable values, not as final balance:

| Terrain | Initial cost multiplier | Notes |
|---|---:|---|
| Road or track | 0.6 | Faster; may be taxed, controlled or ambushed |
| Plain / farmland | 1.0 | Baseline movement |
| Dry scrub | 1.2 | Thin forage and variable water availability |
| Light forest | 1.5 | Concealment and slower movement |
| Hills | 1.8 | Defensive advantages and route constraints |
| Desert / arid zone | 2.0 | Water and supply pressure; higher risk for large parties |
| Dense forest / jungle | 2.5 | Slow movement, concealment and ambush opportunities |
| Marsh / delta | 2.5 | Seasonal flood and marsh penalties |
| Mountains | 3.0 | Only selected passes may be available to large parties |
| River | Blocked by default | Cross only at ford, bridge, ferry or approved crossing node |

Additional modifiers must be data-driven: monsoon, party size, pack animals, carts, cavalry share, scouting, local guides, road condition, supply state, weather and whether an edge is controlled or blockaded.

## 2.4 Geography data fields

Each region should include:

- Stable ID and display names / historical name variants.
- Parent region ID and macro-region ID.
- Geometry reference or polygon file reference.
- Coordinate system and map projection metadata.
- Terrain composition and elevation summary.
- Main water systems and natural features.
- Climate profile and seasonal risk profile.
- Resource and agriculture suitability tags.
- Strategic corridor and chokepoint IDs.
- Historical claims with date range, source ID and confidence.

Each route edge should include:

- Stable ID; from-node and to-node IDs.
- Route type: road, track, pass, ford, bridge, ferry, coast or sea lane.
- Length in kilometres, not screen pixels.
- Movement cost and seasonal modifiers.
- Capacity / maximum practical army class.
- Risk and visibility profile.
- Ownership or control reference, if any.
- Toll and blockade rules.
- Source / date / confidence fields.

## 2.5 Geographic coordinates and rendering

- Store source geography in latitude/longitude using a declared geographic datum, normally WGS84 when compatible with source data.
- Convert to a chosen projected game coordinate system during map processing.
- Do not use screen pixels as the canonical geographic coordinate.
- Pick the final projection after a test renders the whole first map and checks distance/shape distortion. The exact projection remains a technical decision for the map milestone.
- Maintain a stable transform between GIS coordinates and game-world coordinates.
- Store map art/tile scale separately from simulation scale.

## 2.6 Data-source and licensing policy

Potential starting resources include Natural Earth for broad physical features (public-domain data), OpenStreetMap for modern reference features (ODbL, with attribution and share-alike obligations that must be checked for the planned use), and Copernicus DEM for elevation (verify the exact product and licence/availability for each downloaded resolution). Historical gazetteers, inscriptions, archaeological inventories and academic works are needed for historical names, forts, roads and settlements.

Do not assume that an open website means every image, map tile, database or historical map can be redistributed in a commercial game. Record source, licence, attribution text, download date and transformations for every imported dataset. Prefer raw data over screenshots or copyrighted map artwork.

---

# 3. Political world model

## 3.1 Do not hard-code seven equal kingdoms

The earlier idea of a small roster of major powers is useful for managing scope, but the Deccan-first campaign should not force every polity into the same type or size. Use political entity types and power tiers.

Possible polity types:

- Empire.
- Sultanate / kingdom.
- Regional kingdom.
- Principality.
- Chiefdom / tribal polity.
- Provincial government / subah / governorship.
- Vassal state or tributary ruler.
- Clan-led estate network.
- Merchant company / overseas trading power.
- Pirate or coastal enclave.
- Rebel faction.
- Mercenary company.

A polity can have a sovereign ruler, a nominal overlord, a local governor, autonomous vassals, changing alliances and internal faction groups. Sovereignty, de facto control and revenue rights must be represented separately.

## 3.2 Core Deccan-era political actors to research

For the first detailed historical snapshot around 1622, the project should investigate the following as major actors or regional powers. The exact borders, rulers, subordinate relations and settlement ownership must be checked for the chosen date.

- **Mughal imperial authority:** northern pressure, frontier commands, imperial governors, mansabdars and campaigning forces. The first map can represent the southern Mughal frontier in detail and the distant imperial centre as an external political authority until the northern expansion pack exists.
- **Ahmadnagar / Nizam Shahi:** a central Deccan sultanate with court factions, commanders, local revenue holders and contested territories.
- **Bijapur / Adil Shahi:** a major Deccan sultanate with its own court, commanders, military households, frontier interests and local service networks.
- **Golconda / Qutb Shahi:** a major eastern Deccan power with important trade and fortified centres.
- **Mysore / Wodeyar:** a southern kingdom whose exact influence and subordinate relationships vary by scenario date.
- **Other regional powers:** Gond ruling houses and chiefdoms; Keladi/Ikkeri; Nayak polities such as Gingee, Thanjavur and Madurai; Kerala and Malabar rulers including Venad-area powers; local chiefs, deshmukhs, desais and zamindars; and other date-appropriate formations.
- **Portuguese overseas power:** coastal territorial and fortified possessions and trading privileges, not a generic all-powerful inland colony.
- **English East India Company:** represent its date-appropriate factories, merchants, privileges, ships and coastal footholds. Do not treat a trading factory as equivalent to a sovereign territorial colony.

The Dutch and French can be added as separate scenario-specific trading powers later if desired. They should not be forced into every start date.

### 1622 snapshot caution

The first scenario must be date-specific. Historical overviews report Berar absorbed by Ahmadnagar in 1574 and Bidar conquered by Bijapur in 1619. Therefore, do not automatically model Berar and Bidar as two fully independent sultanates in the 1622 snapshot. Their former territories, local elites, forts and claims may still need separate records even when their sovereign controller has changed. The exact status of every district and fort must be verified individually. Sources also use different dates for the final Ahmadnagar collapse (for example, capture of Ahmadnagar is dated 1633 in one overview, while the project brief currently uses 1636 for the final fall). Record the specific event being dated—fort capture, dynastic termination, annexation or final military settlement—rather than forcing one date onto all of them.

## 3.3 Local polities must be real simulation actors

Gond, Bhil and other forest/hill communities should not be generic obstacles or anonymous population modifiers. Where evidence supports a ruling house, polity or chief, represent it as an actor with:

- Land and settlement claims.
- Local alliances and rivalries.
- Military capacity and recruitment networks.
- Tribute, negotiation and autonomy relationships.
- Internal succession and family structures where records support them.
- Regional knowledge and terrain familiarity.
- The ability to become stronger, weaker, divided, incorporated or independent.

Do not collapse every community sharing a broad identity into a single kingdom. For example, Gond political formations in the central Indian region should be investigated as separate, historically situated polities rather than one unified Gond empire.

## 3.4 Polity data fields

Each polity should store:

- ID, name, name variants and polity type.
- Start/end date of existence where historically known.
- Capital / seat ID, current ruler ID and court ID.
- Culture, language and religious affiliations where supported.
- Territory claims, controlled regions and currently controlled settlements.
- Treasury, debts, revenue streams and expenditure priorities.
- Army and naval capacity, recruitment pool and military doctrine tags.
- Governance style, tax policy, succession rules and offices.
- Vassals, tributaries, overlords, allies, rivals and treaties.
- AI personality / strategic preferences.
- Stability, legitimacy, elite cohesion, war exhaustion and administrative reach.
- Historical source claims, confidence and scenario-specific overrides.

## 3.5 Ownership is not one field

A place can have multiple relevant authorities. Keep these separate:

- `sovereign_polity_id`: formal or claimed sovereign.
- `controller_polity_id`: who currently controls it in the simulation.
- `owner_clan_id`: who holds the estate or hereditary right, if applicable.
- `governor_character_id`: who administers it.
- `revenue_beneficiary_id`: who receives income.
- `garrison_commander_id`: who commands the troops stationed there.
- `overlord_polity_id`: higher political authority, if any.

This supports jagir grants, salaries, tributary rulers, delegated governors, contested forts, revolts and royal confiscation without corrupting the underlying settlement record.

---

# 4. Culture, language, religion and social identity

## 4.1 Keep these dimensions separate

Each character and population group can have distinct fields for:

- Cultural identity / cultural group.
- Primary and secondary languages.
- Religion / religious affiliation.
- Regional identity / home region.
- Community or social identity, where appropriate and supported.
- Legal or political status (noble, service holder, merchant, artisan, cultivator, pastoralist, religious office, dependent, etc.).

A language is not a kingdom. A religion is not a faction. A cultural identity does not automatically determine allegiance. A clan may serve a ruler outside its home region.

## 4.2 Maratha and Marathi-related identity

For this game's data model, the user wants Maratha represented as a cultural/social identity available to characters and families, rather than as a pre-existing starting kingdom. Keep the following data separate:

- Marathi language and language proficiency.
- Maratha identity/community tags used by the game.
- Local region and home settlement.
- Family/clan identity.
- Actual employer, political allegiance and military service.

A character can be Maratha-identified and serve Ahmadnagar, Bijapur, Golconda, a local chief, the Mughals or a mercenary employer depending on date and biography. Do not assume all Marathi speakers are Maratha, or all Maratha-identified characters have the same religion, rank, profession or political loyalty. Historical labels and their scope must be checked in the regional research pack.

## 4.3 Cultural and religious effects

Culture, language and religion may affect:

- Language comprehension and persuasion difficulty.
- Local recruitment availability and troop equipment traditions.
- Familiarity with local customs and administrative practices.
- Marriage eligibility or diplomatic customs where documented for a scenario.
- Religious institutions, festivals, patronage and legitimacy.
- Public response to policies and appointments.
- Loyalty and unrest where the actual policy context creates friction.

They must **not** assign fixed intelligence, courage, honesty, greed, leadership, combat ability or moral worth. Such traits belong to individual characters and their life experiences, not to a population-wide stereotype.

## 4.4 Social status and caste-related data

If the project later includes caste or other historical social hierarchy, model it as a dated social institution and status system, not as a biological attribute or a universal character-stat modifier. It may affect historically specific access to offices, land rights, marriage rules, occupations, restrictions and social networks, but every rule must be sourced, regional, time-bounded and reviewed for harmful oversimplification. The user has not yet locked the exact level of caste simulation; keep it configurable and do not let it block the core game.

---

# 5. Characters: identity, life, attributes, skills and personality

Characters are the main agents of the world. A character is not merely a portrait attached to a party. Characters own relationships, have goals, remember events, join households, command parties, govern settlements, inherit titles and can die.

## 5.1 Character identity record

Each character should have:

- Stable `character_id` that never changes after creation.
- Primary display name and alternate / historical spellings.
- Optional title, honorific, patronymic, house or branch label.
- Date/year of birth and death, including uncertainty range when exact dates are not known.
- Gender / historically appropriate identity field where needed by the design.
- Culture, language, religion, region of origin and home settlement references.
- Family ID, family-branch ID and clan membership history.
- Current political office, employer, patron, party, location and household.
- Portrait / visual asset references (not stored in the historical facts file).
- Biography and source claims, clearly distinguishing fact from invented game content.

## 5.2 Life-cycle states

Possible character states include:

- Unborn / expected heir (only if future-family simulation needs it).
- Child / dependent.
- Adolescent / education and training phase.
- Adult / active character.
- Elder / reduced or changed role depending on health and skill.
- Captured / imprisoned / ransomed.
- Wounded / recovering.
- Missing / fate unknown.
- Dead.

The exact age thresholds should be scenario- and culture-aware where required, rather than assumed universal. For game balance, a default adulthood threshold can exist, but it must be configurable.

## 5.3 Core attributes

Use six broad attributes as the character's underlying aptitudes. These are not the same as skills.

| Attribute | Meaning | Skills it can support |
|---|---|---|
| Might | Physical power, strength and capacity for demanding tasks | Melee combat, heavy equipment, carrying capacity, endurance checks |
| Agility | Balance, coordination, speed and handling | Riding, athletics, weapon handling, mounted manoeuvres |
| Endurance | Health, stamina and resistance to physical strain | Marching, recovery, hardship, fatigue resistance |
| Insight | Observation, judgement, pattern recognition and situational awareness | Scouting, tactics, investigation, ambush detection |
| Learning | Ability to acquire and apply technical or administrative knowledge | Medicine, engineering, logistics, stewardship, languages |
| Presence | Social confidence, authority and ability to influence others | Leadership, persuasion, negotiation, diplomacy and command |

Recommended data scale: 0–100, with 50 representing an ordinary adult baseline for generated characters. The exact distribution, minimums, maximums and growth rates are balancing decisions, not historical facts. Avoid making every important character a 90+ all-rounder.

Attributes should change slowly. Training, experience, age, illness, injury and exceptional events may change them, but ordinary daily activity should primarily affect skills and experience rather than constantly moving base attributes.

## 5.4 Skill catalogue

Skills are learned capabilities. Keep them individually stored so a character can be a brilliant merchant and poor commander, or an effective scout but weak court negotiator.

### Military and command

| Skill | Main effects |
|---|---|
| Tactics | Battle planning, engagement choice, deployment advantage, ambush response and retreat decisions |
| Leadership | Party cohesion, morale, discipline, recruitment confidence and ability to retain followers |
| Infantry Command | Effectiveness of infantry formations and infantry-heavy parties in auto-resolve |
| Cavalry Command | Mounted formation coordination, pursuit and mobility tactics |
| Ranged Command | Archer / matchlock / artillery coordination when those troop types exist in the scenario |
| Riding | Personal mounted travel, mounted combat capability and horse handling |
| Weapon Mastery | Personal combat contribution in any later tactical battle mode; limited influence in campaign auto-resolve |
| Siegecraft | Siege preparation, assault planning, siege timing and defensive response |
| Engineering | Siege works, fort improvements, equipment construction and repair |

### Campaign and fieldcraft

| Skill | Main effects |
|---|---|
| Scouting | Party detection radius, map visibility, route discovery, ambush detection and tracking |
| Survival | Reduced hardship losses, foraging, water management and survival in difficult terrain |
| Logistics | Food consumption efficiency, supply planning, wagon/pack organisation and long-march readiness |
| Navigation | Route choice, coastal / river / sea navigation when enabled, and reduction of travel errors |
| Tracking | Follow parties, identify movement, estimate army size and investigate raiders |

### Economic and administrative

| Skill | Main effects |
|---|---|
| Trade | Market information, bargaining, trading margin and caravan management |
| Stewardship | Household, party, garrison and estate administration; storage and workforce organisation |
| Governance | Tax administration, settlement stability, public works and local policy execution |
| Finance | Loans, credit, interest agreements, treasury management and investment decisions |
| Craft / Production Knowledge | Workshop efficiency and production-chain decisions if workshops are included |

### Social and political

| Skill | Main effects |
|---|---|
| Persuasion | Negotiation checks, recruiting companions, convincing characters and resolving disputes |
| Diplomacy | Treaties, alliances, tribute, marriage negotiations and relations between polities |
| Intrigue | Informants, plots, covert action, identifying conspiracies and counter-intrigue |
| Courtcraft | Navigating factional politics, patronage, petitions and office competition |
| Languages | Ability to communicate across language groups; model as language-specific proficiency where feasible |

### Medical and specialist

| Skill | Main effects |
|---|---|
| Medicine | Wound survival, recovery speed, disease treatment and casualty outcomes |
| Quartermastery | Food variety, stock planning, supply allocation and waste reduction |
| Intelligence / Investigation | Evidence gathering, rumour checking and event discovery; keep distinct from general Insight attribute |

The skill catalogue can grow, but add a new skill only when it creates a distinct player decision or NPC capability. Avoid dozens of nearly identical skills that only add menu complexity.

## 5.5 Skill levels and effects

Recommended skill scale: 0–100. Use named proficiency bands for UI, for example:

- 0–19: novice.
- 20–39: basic.
- 40–59: capable.
- 60–79: expert.
- 80–94: master.
- 95–100: exceptional.

These are presentation bands, not locked balance values. A skill should use a diminishing-returns curve so a character with 90 skill is excellent but not twice as effective as a character with 45.

Each skill definition must specify:

- Attribute contribution.
- Experience sources.
- Passive effects.
- Active action checks.
- Soft caps and diminishing-return curve.
- Relevant party / settlement / personal contexts.
- Tests for low, average and high proficiency.

Examples:

- Scouting affects detection and route information; it does not directly add raw troop strength.
- Leadership affects morale and cohesion; it does not automatically grant unlimited party size.
- Logistics reduces waste and increases planning quality; it does not create food from nothing.
- Diplomacy improves the chance and terms of negotiation; it does not override another character's personality, commitments or political interests.
- Medicine improves the chance of survival and speed of recovery; it does not guarantee that every casualty survives.

## 5.6 Personality and nature

Personality is different from skill. A skilled diplomat may be greedy and disloyal; a courageous commander may have poor tactics. These traits should guide AI decisions and responses.

Use a 0–100 scale with 50 neutral/ordinary. Candidate personality dimensions:

| Trait | Low tendency | High tendency |
|---|---|---|
| Ambition | Content with current status | Seeks higher office, land and power |
| Courage | Avoids personal danger | Accepts personal and military risks |
| Aggression | Prefers restraint | Prefers pressure, raids and conflict |
| Prudence | Acts quickly with limited caution | Checks risk, supplies and consequences |
| Greed | Less motivated by wealth | Strongly motivated by money, land and spoils |
| Generosity | Keeps resources close | Gives gifts and shares rewards readily |
| Honour / Promise-keeping | Easily breaks commitments | Strongly values obligations and reputation |
| Loyalty | Changes allegiance readily | Remains committed despite pressure |
| Mercy | Prefers lenient treatment | More willing to use harsh punishment |
| Patience | Wants immediate results | Can sustain long-term plans |
| Suspicion | Trusts readily | Expects deception and seeks information |
| Sociability | Avoids social contact | Builds networks and relationships |
| Pragmatism | Follows principle or custom | Chooses what seems useful in context |
| Religious Zeal | Low personal emphasis | Strong personal commitment to religious observance |
| Tolerance / Pluralism | Less comfortable with difference | More willing to accommodate other practices |

These are candidate dimensions, not an instruction to reduce personality to stereotypes. Traits must be assigned to individual characters from their biography, events and generation rules. Culture, language, religion, caste or ethnicity must not automatically assign a personality value.

## 5.7 Character needs and condition

Track changing state separately from identity/personality:

- Health and injury.
- Fatigue and recovery.
- Hunger / supply status when travelling.
- Stress or morale where useful.
- Wealth and debts.
- Renown / fame.
- Political influence.
- Reputation and honour score.
- Prisoner / ransom status.
- Current ambitions and active plans.

These state values can change during play. Attributes, skills and personality are more persistent.

## 5.8 Character memory

Every important character should retain a compact history of meaningful events:

- Promises made and kept or broken.
- Gifts, loans, favours and debts.
- Betrayals, insults, executions, imprisonment and ransom.
- Marriage alliances and family deaths.
- Battles fought together or against each other.
- Grants, promotions, demotions and revoked estates.
- Failed petitions and denied requests.
- Betrayal or loyalty during crises.

Use an event ledger, not an unbounded text diary. Each memory has an event ID, participants, date, importance, emotional interpretation, relation changes and expiration/decay rules where appropriate. A lord should remember a serious betrayal far longer than a minor market disagreement.

## 5.9 Character generation

Generated NPCs should be produced from transparent weighted rules:

- Region and settlement background.
- Household / family / clan status.
- Profession and education.
- Age and generation.
- Available mentors and training.
- Life events and opportunities.
- Small seeded variation.

Generation should create plausible distributions, not carbon copies. A rural household, a court noble, a caravan merchant and a forest chief should have different opportunity histories, but individuals within each group must still vary.

---

# 6. Families, houses, branches and succession

## 6.1 Family is not the same as clan

Use these separate concepts:

- **Family:** a genealogical and household relationship network: parents, children, spouses, siblings, guardians, adoption and acknowledged heirs.
- **House / lineage:** a named dynastic or extended family line, potentially with multiple branches.
- **Branch:** a sub-line of a house that may hold different estates or political loyalties.
- **Clan:** a political, military and patronage organisation. It may include multiple related branches, allied families, retainers and household officers.
- **Polity:** a sovereign or semi-sovereign political organisation that may contain many clans and families.

A surname alone does not prove that two characters belong to the same branch. A family may split politically, and a clan may include members who are not close blood relatives.

## 6.2 Family links

Use explicit relationship edges:

- Biological parent.
- Adoptive parent.
- Legal / acknowledged parent.
- Spouse or consort.
- Former spouse.
- Sibling / half-sibling.
- Guardian / ward.
- Heir-designate.
- Adopted heir.
- Dynastic or lineage claim.

Each link should have start/end dates, confidence, source and legitimacy/status where relevant. Avoid inferring parentage from surnames.

## 6.3 Succession and inheritance

Separate inheritance of:

- Personal wealth.
- Household property.
- Hereditary land rights.
- Jagir or temporary revenue assignment.
- Office or military command.
- Clan leadership.
- Polity sovereignty.

These need not pass to the same person. A ruler may name an heir, a court may support another candidate, a senior clan branch may challenge the succession, and a sovereign may revoke a temporary grant.

Succession rules should be attached to the relevant office, household or polity. Support multiple patterns: hereditary succession, designation, election/selection by elite council, military seizure, regency, adoption or negotiated settlement. Each scenario determines which rules are active for a particular polity.

## 6.4 Marriage as a relationship and political system

Marriage can create:

- Family links and descendants.
- Kinship ties between houses.
- Diplomatic openings and obligations.
- Claims or inheritance consequences, where configured.
- Rivalry between competing branches.
- New household and succession risks.

Marriage should not automatically guarantee a political alliance or permanent loyalty. The people and clans involved retain their own interests.

## 6.5 Long campaign generations

For a 200–300-year world:

- Historical characters age and die naturally according to configured life and health systems.
- Children can mature and become playable heirs if the player has a valid succession path.
- NPC houses must generate new generations.
- New companions, merchants, commanders and local leaders must enter the world.
- Extinct houses, extinct branches and revived houses should be handled explicitly.
- Character IDs are never reused.
- Avoid infinite uncontrolled character growth: use household relevance, active roles, historical importance and simulated/off-screen resolution to manage population.

---

# 7. Clans, noble houses and service networks

## 7.1 Clan data

A clan should include:

- Stable clan ID and name variants.
- Founding date / end date if known.
- Main house and branch IDs.
- Clan leader and council / senior members.
- Related families, marriage links and cadet branches.
- Home region and ancestral seat.
- Current patron / employer / political allegiance.
- Holdings, hereditary rights and revenue claims.
- Retainers, companions, household troops and parties.
- Treasury, debts, influence and renown.
- Internal cohesion, ambition, loyalty and rivalry.
- Clan-to-clan relations and past feuds.
- Succession rules and internal faction structure.

A clan's service relationship with a ruler must have dates and terms. It can be:

- Permanent or hereditary vassalage.
- Service contract.
- Mansab / office appointment.
- Jagir or revenue assignment.
- Tributary relationship.
- Military alliance.
- Temporary mercenary contract.
- Hostage / guarantee relationship.
- Rebellious or independent status.

A clan may have a patron but still maintain local hereditary rights and family branches elsewhere.

## 7.2 Initial Deccan research candidates

The following are **candidate houses and names for the historical research pack**, not a finalized roster, complete genealogy or fixed political allegiance:

- Jedhe.
- Jadhav / Yadavrao.
- Bhosale / Bhonsle (spellings and branch identities must be sourced).
- Nimbalkar / Nimbhalkar.
- More.
- Ghorpade.
- Ghatge.
- Daphale / Dafle.
- Mane.
- Mohite.
- Mahadik.
- Shirke.

For each, research:

1. Exact branch and spelling in the selected period.
2. Known members and date ranges.
3. Ancestral and current seats.
4. Documented service to Ahmadnagar, Bijapur, Golconda, local rulers or other patrons.
5. Hereditary rights, estates, forts and revenue claims.
6. Marriage and kinship connections where supported.
7. Whether the source is contemporary, later genealogy, gazetteer or disputed tradition.

Do not make all houses loyal to one sultanate. Do not merge branches just because surnames match. Do not fabricate family trees to fill empty slots.

## 7.3 Clans outside the Deccan

As the map is populated, research regional houses and local ruling lineages for:

- Gondwana / central Indian polities.
- Karnataka and Keladi / Mysore spheres.
- Telugu Nayaka and other Andhra/Telangana regions.
- Tamil Nayak and southern houses.
- Kerala and Malabar polities.
- Local coastal, port and island powers.

Use locally meaningful political units and titles. A Deccan deshmukh, a Tamil Nayaka, a Gond ruler, a Kerala chief and a merchant household should not be forced into one identical social template.

---

# 8. Relationships: people, families, clans, factions and settlements

## 8.1 Relationship types are separate graphs

Do not use one universal relation number for everything. The simulation should maintain different relationship networks:

1. Character ↔ character.
2. Family / house ↔ family / house.
3. Clan ↔ clan.
4. Character ↔ clan / family.
5. Clan ↔ polity / patron.
6. Polity ↔ polity.
7. Settlement ↔ ruling authority / governor / local community.
8. Character or clan ↔ settlement notables and population groups.

Relationships can be asymmetric. Lord A may respect Lord B while Lord B distrusts A.

## 8.2 Character-to-character relationship dimensions

Use a compact set of dimensions rather than a single opaque value:

| Dimension | Meaning | Gameplay use |
|---|---|---|
| Trust | Belief that the other will keep agreements | Contracts, loans, secret plans, following orders |
| Respect | Regard for ability, rank or conduct | Support, rivalry, command acceptance, court status |
| Affection / Kinship | Personal attachment | Family support, marriage, loyalty, grief |
| Fear | Expectation of punishment or force | Compliance, intimidation, desertion and revolt risk |
| Grievance | Unresolved harm or insult | Revenge, refusal, feud, betrayal |
| Obligation | Favours, debt or promises owed | Requests, repayment, support and bargaining |
| Rivalry | Competition for status, wealth or office | Court plots, elections, succession and challenge |

Values can use -100 to +100 where meaningful, or 0–100 where the dimension is naturally non-negative. The exact representation must be consistent in schemas. Do not store obligations only as a numeric relationship: loans, promises and contracts need their own records.

## 8.3 Clan and family relationships

Clan relations should include:

- Goodwill / cooperation.
- Rivalry / feud.
- Trust / reliability.
- Marriage and kinship links.
- Debt, favour and compensation claims.
- Land or title disputes.
- History of shared service, betrayal and conflict.

Clan leaders can have positive personal relationships while their houses remain rivals, or vice versa.

## 8.4 Polity-to-polity relations

Keep diplomacy distinct from personal affection:

- Diplomatic stance.
- Strategic trust.
- Threat perception.
- Territorial claims / disputes.
- Treaty status.
- Tribute and vassal obligations.
- Trade dependence.
- Recent war / peace history.
- Dynastic marriage links.

A treaty is a formal object with start date, end date, terms, guarantees and breach consequences. It must not be represented only as a high relation score.

## 8.5 Settlement loyalty and local legitimacy

For each settlement, track different local factors:

- Loyalty to current sovereign.
- Confidence in the governor.
- Security and bandit pressure.
- Tax burden and unpaid obligations.
- Food availability and prosperity.
- Local representation and elite cooperation.
- War damage and occupation memory.
- Cultural / religious policy friction when supported by actual context.

Loyalty is not simply the average culture difference from the ruler. A local population may accept a ruler from another background if governance is stable, taxes reasonable, security good and local elites respected; the reverse may also occur.

## 8.6 How relationships change

Every significant action should create a dated event with affected entities and relation changes. Examples:

| Event | Likely effects |
|---|---|
| Keep a promise | Trust and respect increase; obligation cleared |
| Break a promise | Trust drops; grievance rises; future negotiations harder |
| Pay a debt on time | Trust rises; credit reputation improves |
| Default on a loan | Trust and reputation fall; creditor may seek legal or political action |
| Grant a jagir or estate | Clan / character support may rise; treasury and rival expectations affected |
| Revoke a grant | Grievance, rivalry and rebellion risk may rise; sovereign control may improve if justified |
| Help in battle | Respect, trust and personal obligation may rise |
| Abandon an ally | Trust collapses; feud and revenge risk rise |
| Execute a character | Fear may rise among some actors; grievance and feud among relatives, allies and followers may rise sharply |
| Marry into a house | Kinship and diplomatic ties appear; does not guarantee loyalty |
| Pay ransom | Trust or respect may improve; treasury changes; hostage memory remains |
| Protect a village from raiders | Local loyalty and reputation improve |
| Impose destructive taxation | Revenue rises temporarily; prosperity and loyalty may decline over time |

Do not use fixed universal deltas for all cases. Effects should be scaled by severity, context, existing ties, personality, witnesses, promises and whether compensation is offered.

---

# 9. Skills, attributes and trait effects on simulation

## 9.1 General calculation pattern

For a decision or action, calculate an effective capability from:

- Base attribute.
- Relevant skill.
- Trait fit.
- Experience / preparation.
- Equipment or resources.
- Context (terrain, weather, local knowledge, support).
- Health, fatigue and morale.
- Random variation from the seeded generator, only where the action needs uncertainty.

Do not multiply every factor together in a way that creates runaway numbers. Use bounded modifiers, soft caps and explicit tests.

## 9.2 Personality affects the choice; skill affects execution

Example:

- A cautious commander with high Tactics may identify a good ambush but choose not to risk it if the escape route is poor.
- An aggressive commander with low Tactics may attack anyway and suffer losses.
- A greedy governor may favour higher extraction even when it damages long-term loyalty.
- A patient and prudent merchant may wait for a price opportunity; a reckless merchant may overextend on credit.
- A loyal clan leader may remain in service despite low personal reward, while an ambitious one may demand promotion or change patrons.

This distinction is essential. Personality should not become another word for skill.

## 9.3 Example effects map

| Capability | Main world systems affected |
|---|---|
| Leadership | Party morale, cohesion, recruitment confidence, desertion and command capacity |
| Tactics | Auto-resolve advantage, ambush planning, retreat and target selection |
| Scouting | Detection, tracking, fog of war, route information and ambush warning |
| Logistics | Supply consumption, provisioning, march reliability and siege endurance |
| Stewardship | Estate administration, stores, household and garrison organisation |
| Governance | Tax collection quality, public works, local stability and corruption control |
| Trade / Finance | Price information, bargaining, credit, investment and debt management |
| Diplomacy / Persuasion | Treaties, marriage proposals, petitions, faction votes and recruitment |
| Intrigue | Informants, rumour verification, plot detection and covert operations |
| Medicine | Wounded recovery, disease outcomes and casualty survival |
| Engineering / Siegecraft | Fort improvement, siege preparation, assault works and repair |
| Survival | Attrition, water and foraging losses in difficult terrain |

The final numerical effects belong in separate balance configuration files and should be tested with simulation batches.

---

# 10. Troops, recruitment and upgrade trees

## 10.1 Troop data is separate from character data

A troop type is a military unit template. A character is an individual with biography, skills, personality and relationships. A troop stack is a count of soldiers of a particular type and condition.

## 10.2 Troop record fields

Each troop type should contain:

- `troop_id`, display name and alternate names.
- Culture / regional recruitment tags.
- Recruitment settlement types and notability / relation requirements.
- Tier and role.
- Upgrade parent and child choices.
- Recruitment cost and recurring wage.
- Training time and experience requirements.
- Equipment package IDs.
- Armour, weapon, mount and shield tags.
- Movement and carrying implications.
- Base combat values and morale profile.
- Supply consumption and mount upkeep.
- Specialisations and terrain familiarity tags.
- Historical confidence and scenario availability dates.

## 10.3 Main troop categories

- Levy / basic village infantry.
- Spearmen and polearm infantry.
- Sword / shield infantry.
- Heavy infantry.
- Archers.
- Matchlock / firearm infantry when date and region justify them.
- Light cavalry.
- Heavy cavalry.
- Horse archers / mounted ranged troops where historically appropriate.
- Scouts and messengers.
- Engineers and siege specialists.
- Guards / elite household troops.
- Irregular hill and forest fighters.
- Naval / marine troops only if sea warfare is implemented.

These are functional categories, not the final historical troop names. Specific troop trees must be researched for each region and date.

## 10.4 Recruitment and upgrade logic

- Villages provide a local recruitment pool based on population, prosperity, security, culture, current owner and available military tradition tags.
- Towns and forts may provide specialist or garrison recruitment.
- Better relations with local notables may unlock more recruits or better terms, if supported by the setting.
- Recruitment removes available population or recruits from the local pool; it cannot create unlimited soldiers.
- Upgrade requires experience, training time, money and any required mount/equipment.
- Upgrading consumes the previous troop stack and creates the next type.
- A troop tree may branch into different specialist roles; avoid a single mandatory path for every recruit.
- A defeated army loses trained soldiers, equipment, mounts, money, time and reputation. It must rebuild through recruitment and training rather than instantly respawning at full strength.

## 10.5 Troop skills and army composition

Troop effectiveness depends on:

- Troop type and training tier.
- Equipment quality and availability.
- Morale and cohesion.
- Commander skill and relevant traits.
- Army composition and unit synergy.
- Terrain, weather and visibility.
- Fatigue, food and supply.
- Experience and recent victories or defeats.

Cultural background may influence available troop traditions and recruitment pools, but it should not mean that one culture is innately better at a role.

---

# 11. Settlements, villages, forts and the local economy

## 11.1 Site types

The world should distinguish:

- Capital / major city.
- City.
- Market town.
- Small town.
- Village.
- Fort / hill fort / pass fort.
- Fortified town.
- Port / harbour.
- Trading factory / company establishment.
- Mining, forestry or production site.
- Religious / pilgrimage site.
- Strategic crossing / pass / ferry / bridge.
- Tribal or local chief's seat.

A fort and a nearby village can be separate sites with separate populations and owners, connected by a local administrative or protection relationship.

## 11.2 Settlement fields

- Stable ID and historical / alternate names.
- Coordinate and map node ID.
- Region and sub-region IDs.
- Site type and development tier.
- Population, household count and growth profile.
- Population group shares and local language/culture/religion tags where supported.
- Prosperity, loyalty, security, unrest and damage.
- Food, water, storage and market stock.
- Production buildings, workshops, mines and agricultural potential.
- Tax policy, tax base and revenue.
- Attached villages, estates, routes and resource sites.
- Fortification, garrison, commander and security radius where relevant.
- Sovereign, controller, owner, governor and revenue beneficiary as separate references.
- Historical source claims and scenario-specific status.

## 11.3 Settlement economy

A settlement's economy should operate through stocks and flows:

- Production per day or season.
- Local consumption.
- Storage capacity and current stock.
- Import and export demand.
- Market price and price trend.
- Taxes, tolls and fees.
- Workforce / household availability.
- Infrastructure and transport connection.
- Security and raid disruption.
- Seasonal conditions and harvest uncertainty.

A settlement should not produce every resource. Production is geographically and culturally contextual, and must be limited by workforce, water, land, tools and transport.

## 11.4 Ownership, local control and fort security

- A fort may protect several settlements and nearby routes, but its effective security radius depends on terrain, garrison, patrol strength, roads and commander competence.
- Patrols consume wages, food and mounts.
- Trade-route patrols improve safety probabilistically; they do not make routes invulnerable.
- A fort's owner, garrison commander and settlement governor may differ.
- A fort can become isolated if passes, supplies or nearby settlements are lost.

---

# 12. Economy, taxes, trade and state finance

## 12.1 Goods and production chains

Create goods in categories:

- Food and livestock.
- Agricultural produce.
- Raw materials: timber, stone, iron, copper, salt, fibres and other sourced resources.
- Manufactured goods: cloth, weapons, tools, pottery, processed foods and equipment.
- Luxury goods: precious stones, fine textiles, spices and high-value trade items.
- Military supplies: weapons, ammunition, mounts, tents, carts and siege materials.

Each good needs a base price, weight/volume, perishability, production inputs, regional availability, demand uses, storage properties and date range if historically constrained.

## 12.2 Supply and demand

Market price should respond to:

- Local stock versus target stock.
- Production and consumption.
- Caravan arrival and route disruption.
- War, raids, blockades and siege.
- Weather, harvest and seasonal access.
- Taxes, tolls, monopoly rights and trade licences.
- Nearby substitute goods and market connections.

Use bounded price curves and minimum stock safeguards. The game must avoid price explosions when stock reaches zero.

## 12.3 Revenue and finance

Track each revenue source visibly:

- Land tax and settlement revenue.
- Jagir / revenue assignment.
- Salary and office payment.
- Customs, tolls and port fees.
- Market and workshop income.
- Caravan and merchant profits.
- Tribute and treaty payments.
- Loot and ransom.
- War indemnity and spoils.
- Loans, interest and investment income.

Track spending separately:

- Troop wages and recruitment.
- Garrison / patrol / fleet upkeep.
- Court and household costs.
- Public works and settlement investment.
- Gifts, patronage and political payments.
- Siege and campaign expenses.
- Debt service and emergency relief.

No hidden gold. The player should be able to inspect income, expenses, debts, transfers and revenue beneficiaries.

## 12.4 Tax and revenue policies

Support the hybrid governance model already discussed:

- Local holder retains most fief income and pays an agreed share upward.
- Sovereign collects more central revenue and pays salary / allowance to office holders.
- Mixed arrangements by office, region, fief or scenario.

Policies are trade-offs. More central revenue can fund campaigns and public works, but may weaken noble incentives or increase administrative cost. Greater local autonomy can improve local initiative but reduce central control and encourage powerful lords to pursue private wars.

## 12.5 Loans and merchant relationships

Loans need explicit contracts:

- Lender and borrower IDs.
- Principal, interest, due date and repayment schedule.
- Collateral / guarantee, if any.
- Guarantor or patron.
- Default consequences.
- Reputation and relation effects.

A merchant can be a character, household or company. A trade relationship can become friendship, rivalry, debt or political support.

---

# 13. Military operations, movement, supply and sieges

## 13.1 Parties and armies

A party should have:

- Leader and optional companion officers.
- Troop stacks and count.
- Morale, cohesion and training state.
- Food, water where modelled, money and cargo.
- Mounts, pack animals and transport capacity.
- Speed and movement profile.
- Current goal and AI role.
- Detection and visibility profile.
- Relations and hostility rules.
- Recent battle, losses and recovery status.

A large army can be formed by merging parties, but the component parties and their leaders should remain trackable for later separation, loyalty disputes and supply division.

## 13.2 Army logistics

- Larger parties consume more supplies and may move slower.
- Cavalry and pack animals increase speed or carrying capacity in some conditions but require feed and care.
- Local forage depends on season, terrain, population and previous army activity.
- Armies passing through a region can reduce local food stock and damage prosperity if poorly managed.
- Long campaigns create fatigue, disease, desertion and financial pressure.
- Armies cut off from a route or port may lose supplies and face surrender or retreat.

## 13.3 Raids and irregular warfare

Any faction or player can choose raids, ambushes, night attacks, harassment and supply disruption if they have the capability and opportunity. Do not hard-code these as exclusive to one culture.

Effectiveness should depend on:

- Local knowledge and scouting.
- Mobility and troop composition.
- Terrain, concealment and weather.
- Surprise and intelligence.
- Escape routes and nearby safe bases.
- Enemy patrols, formation, vigilance and supply.

Small forces may disrupt large armies but are not guaranteed to win direct battles. They may be caught, lose troops or suffer retaliation.

## 13.4 Sieges

A siege should track:

- Besieger and defender strength.
- Fortification type, condition and defensive works.
- Food and supply stocks on both sides.
- Relief army access.
- Siege equipment and engineering skill.
- Disease, morale and desertion.
- Assault attempts and casualties.
- Negotiation, bribery, betrayal and surrender conditions.
- Seasonal and weather impact.

A siege can last days or weeks in game time. The besieger can be forced to retreat if supply lines are cut, while the garrison can surrender if food, morale or defensive strength collapses.

---

# 14. AI, ambitions, plans and political memory

## 14.1 Deterministic utility AI first

The first version should use transparent scoring rules, not machine learning. For every decision, score candidate actions based on:

- Goals and current needs.
- Personality traits.
- Skills and available resources.
- Current relations and promises.
- Threat and opportunity.
- Geography and travel cost.
- Risk and expected rewards.
- Recent memories and past outcomes.

Use seeded randomness only to vary near-equal choices. Record why the action was selected so the developer can debug NPC behaviour.

## 14.2 Character goals and plans

Possible goals:

- Earn wealth.
- Gain office or promotion.
- Protect or expand family holdings.
- Improve clan influence.
- Serve a patron faithfully.
- Replace a ruler or dominate a court.
- Secure an heir or marriage alliance.
- Trade or acquire a monopoly.
- Take revenge.
- Protect a settlement or community.
- Become independent.

Goals should have priority, success conditions, deadlines, required resources, risk tolerance and cancellation conditions.

## 14.3 NPC actions

Examples:

- Travel to court, a settlement, a market or a battlefield.
- Recruit, train, merge or disband troops.
- Collect revenue, pay wages, request grants or petition a ruler.
- Patrol, escort a caravan, raid, besiege or relieve a fort.
- Negotiate treaties, trade, marriage or ransom.
- Invest in a settlement or workshop.
- Build alliances, seek promotion, challenge a rival or change allegiance.
- Arrange succession and protect family members.

Characters should physically move on the campaign map when the action requires travel. For remote messages, use a messenger / courier action with travel time, cost, interception risk and reliability. It must not be instant omniscient communication.

## 14.4 Recovery after defeat

A defeated lord or faction should need time and resources to recover:

- Replacements must be recruited and trained.
- Equipment and mounts must be obtained.
- Treasury and credit may be damaged.
- Captured or killed commanders may be unavailable.
- Local recruitment pools may be depleted.
- Political confidence and relations may fall.

Do not respawn elite armies instantly at full strength.

## 14.5 Long-term simulation and performance

- Use hourly ticks for movement and urgent party decisions.
- Use daily ticks for supplies, wages, market and settlement changes.
- Use weekly or event-driven ticks for faction strategy and diplomacy.
- Use monthly / seasonal / yearly ticks for population, births, ageing, harvests and long-term plans.
- Use off-screen abstraction for distant low-priority activity while preserving important political outcomes.
- Maintain deterministic results when using simulation level-of-detail.

---

# 15. Historical scenarios and changing time

## 15.1 Scenario system

The same simulation engine should load different start snapshots. Preserve the original brief's scenario concept and begin with the approximately 1622 start as the first detailed playable snapshot, unless the user later changes it.

Potential scenario data already named in the project brief:

- c.1590.
- c.1622.
- c.1634.
- c.1680.
- c.1725.

A scenario must store:

- Start date and calendar convention.
- Starting sovereigns and office holders.
- Settlement and fort control.
- Clan / family / character states.
- Troop stacks and party locations.
- Treasury, stock, trade and debt state.
- Active treaties, feuds, wars and vassal obligations.
- Scenario-specific historical pressures and optional events.

## 15.2 History is a starting condition, not a guaranteed script

The world begins with evidence-based conditions, but the simulation determines what happens afterward. A historical state may survive longer, a local chief may expand, a clan may switch patrons, a player may prevent an annexation, or a new independent state may emerge.

Historical pressure can be represented as AI goals, threat estimates, financial incentives and event possibilities. A pressure must be optional or adjustable; it must not silently force the outcome.

## 15.3 Date-aware data

Every historical name, ruler, clan membership, settlement owner, border claim, treaty, troop type and title should have a valid date range or scenario availability. Do not assume that a 1680 political boundary existed in 1622.

When exact dates are uncertain, store a year range and confidence rather than inventing a precise date.

---

# 16. Data architecture and project folder plan

The original technical direction remains suitable: TypeScript simulation core, JSON data validated with Zod or JSON Schema, Python map processing, a 2D campaign renderer, automated simulation tests and versioned saves.

Suggested data structure:

```text
data/
  world/
    world.json
    macro_regions.json
    geographic_regions.json
    terrain_types.json
    natural_features.json
    routes.json
    map_layers.json
  identity/
    cultures.json
    languages.json
    religions.json
    social_institutions.json
  politics/
    polities.json
    offices.json
    treaties.json
    claims.json
  people/
    characters.json
    families.json
    family_links.json
    clans.json
    clan_memberships.json
    relationships.json
    memories.json
  settlements/
    sites.json
    settlement_economies.json
    holdings.json
    governance.json
  military/
    troop_types.json
    troop_trees.json
    equipment.json
    party_templates.json
    doctrine_tags.json
  skills/
    attributes.json
    skills.json
    traits.json
    effect_rules.json
  economy/
    goods.json
    production_chains.json
    market_profiles.json
    tax_policies.json
    loan_contracts.json
  events/
    event_definitions.json
    historical_pressures.json
  scenarios/
    1590/
    1622/
    1634/
    1680/
    1725/
  sources/
    source_registry.json
    historical_claims.json
```

## 16.1 Stable IDs

Examples:

- `region_deccan_western_plateau`
- `site_ahmadnagar`
- `fort_daulatabad`
- `polity_nizam_shahi`
- `clan_jedhe`
- `family_jedhe_main_line`
- `character_<stable_identifier>`
- `troop_deccan_village_spearman`
- `route_bhima_valley_to_pune`

IDs should be stable and language-neutral. Display names and spelling variants belong in fields. Never use a display name as the database primary key.

## 16.2 Record metadata

Every record should support:

- `id`.
- `record_version`.
- `valid_from` and `valid_to` where date-dependent.
- `source_ids`.
- `confidence`.
- `notes`.
- `status`: draft, researched, reviewed, approved, fictional, deprecated.

## 16.3 Historical confidence levels

Use a simple standard:

- `high`: directly supported by strong contemporary or scholarly evidence.
- `medium`: supported by credible secondary sources, but details or dates are incomplete.
- `low`: plausible but based on uncertain, conflicting or later traditions.
- `contested`: sources disagree materially.
- `fictional`: deliberately invented game content.
- `inferred`: created for simulation where direct evidence is missing; must not be presented as fact.

The user can override or correct source packs later. Preserve source notes rather than silently deleting conflicting evidence.

---

# 17. Example data contracts

The companion ZIP contains starter JSON examples for world, region, settlement, character, family, clan, relationship, skill, troop, polity and scenario records. These are **schema-shape examples**, not approved historical facts. The sample person and house are fictional.

## 17.1 Character sample concept

A character record should reference its family, branch, clan, home region, culture, language and current patron by ID. It stores attributes, skills and traits separately. Relationships are not embedded as a growing list of names; they live in a separate relationship graph.

## 17.2 Family and clan example concept

A family contains genealogy and household links. A clan contains political membership, offices, retainers, holdings and patron relationships. A character can have a family membership and a time-bounded clan membership; a clan can include multiple families.

## 17.3 Relationship example concept

A relationship record is directed and dated. It stores dimensions plus a reason/source event. Formal loans, treaties, marriage links and grants remain separate entities with their own terms and dates.

---

# 18. Historical population workflow

Do not populate the entire map in one pass. Work region by region using a repeatable dossier.

For every region:

1. Define its geographic boundary and sub-regions.
2. List major rivers, mountain ranges, passes, forests and coastal features.
3. Identify the date-specific political actors.
4. Research capital, major cities, market towns and important villages.
5. Research forts and their historical roles / networks.
6. Research clans, families, local chiefs and known branches.
7. Record documented offices, service relationships, estates and revenue rights.
8. Add cultures, languages, religions and local communities only to the level supported by sources.
9. Identify recruitment traditions, troop types, equipment and military roles.
10. Add trade goods, production and route links.
11. Build the scenario snapshot for each selected start date.
12. Review conflicts, uncertainty and date accuracy before approving the region pack.

## 18.1 Regional dossier order

Recommended order:

1. Ahmadnagar and Marathwada.
2. Western Maharashtra plateau and Sahyadri fort network.
3. Khandesh, Berar and Vidarbha.
4. Konkan and Goa.
5. Bijapur and northern Karnataka.
6. Bidar, Gulbarga, Raichur and the Tungabhadra frontier.
7. Golconda and Telangana.
8. Gondwana / central Indian polities.
9. Andhra and Krishna–Godavari coast.
10. Mysore and southern Karnataka.
11. Tamil Nadu and Nayak polities.
12. Kerala and Malabar.
13. Southern Odisha and remaining edge regions.

The order can change if a desired scenario requires another region first.

## 18.2 Regional record checklist

For each named place, record:

- Historical name(s) and modern locator name.
- Coordinates and geometry source.
- Type and strategic role.
- First/last known date in the game period.
- Scenario-specific owner/controller/governor.
- Attached villages, passes, river crossings and routes.
- Local economy / resource tags.
- Fortification data if applicable.
- Related clans and characters.
- Population and culture claims only where supported.
- Sources, confidence and unresolved questions.

---

# 19. Testing and validation rules

Every data pack must pass automated checks before it can load.

## 19.1 Referential integrity

- Every region parent ID exists.
- Every route endpoint exists.
- Every settlement region ID exists.
- Every polity, ruler, clan, family and character reference exists.
- Every family link points to valid characters.
- Every clan membership has a valid clan and character / family reference.
- Every relationship entity exists and relation type is valid.
- Every troop upgrade edge points to valid troop types and does not create an accidental loop.
- Every scenario override references a base-world record.

## 19.2 Historical validation

- A character cannot hold an office before their birth or after their death.
- A clan or polity membership must fall within the relevant date range.
- A fort or settlement cannot appear before its earliest supported date without a lower-confidence placeholder.
- A scenario cannot assign a ruler who is not alive unless the record explicitly represents a regency, claim or posthumous title.
- Treaty dates, wars and ownership changes must not contradict one another silently.
- Conflicting facts produce review warnings, not silent overwrites.

## 19.3 Simulation tests

- A defeated party loses troops, supplies and resources and requires time to rebuild.
- A high Logistics skill reduces supply waste within bounded limits.
- High Leadership improves cohesion without making troops immortal.
- A promise breach damages trust and leaves a memory.
- A grant improves support for the beneficiary but has a treasury / rival cost.
- Excessive taxation can improve short-term cash but reduce long-term prosperity or loyalty in relevant conditions.
- A fort patrol consumes resources and has bounded coverage.
- Siege supply cut-off affects both besieger and defender.
- A character death updates heirs, household and clan succession.
- A clan can split or change patrons without changing its stable ID or rewriting its family genealogy.
- The same seed and command sequence reproduce the same results.

---

# 20. Decisions and open items

## 20.1 Proposed decisions in this document

- Deccan-first map, with the connected southern peninsula and a central frontier.
- North India becomes future modular expansion rather than mandatory first-release coverage.
- 1622 remains the first detailed reference scenario from the original brief unless changed later.
- No pre-existing Maratha faction in the opening scenario.
- Maratha / Marathi identity, language, house, clan and employer are separate fields.
- Family, clan, polity, culture, language, religion and social identity remain separate entities.
- Character attributes, skills, personality and current condition are distinct data layers.
- Relationships use directed graphs and event memories rather than one universal relation score.
- Historical data must have dates, sources and confidence.
- The sample JSON records are fictional examples only.

## 20.2 Still open — do not silently decide

- Exact northern and eastern boundary after GIS review.
- Whether the first playable scenario uses all 200–300 years or starts with a shorter scenario and lets the player continue.
- Exact list of starting political actors in 1622 and the degree of detail for each.
- Whether Portuguese and English Company establishments are treated as independent campaign factions from the first build or as external trade actors initially.
- Whether Dutch / French are included in later scenario packs.
- Exact culture taxonomy and whether Maratha is stored as culture, community, identity or a combination of tags in the final data model.
- Exact social hierarchy / caste simulation depth.
- Exact attribute and skill numerical ranges and growth formulas.
- Exact family age, marriage, adoption and succession rules.
- Exact troop trees and names for each region and start date.
- Exact settlement density and how many villages are fully simulated.
- Whether maritime travel and naval combat are included in the initial campaign release.
- Whether companions can establish independent NPC clans in the first vertical slice or a later milestone.
- Exact treatment of the player's lineage, child succession and game-over conditions.

## 20.3 Recommended immediate next work

Do not start by entering 500 settlements or hundreds of characters. First approve the scope and data vocabulary, then create the first region pack in depth.

The best first region is **Ahmadnagar–Marathwada and the connected Western Maharashtra / Sahyadri corridor**, because it lets us design and test:

- The Nizam Shahi and Bijapur frontier.
- Villages, market towns and forts.
- Maratha and other service families with different patrons.
- Clan and household relationships.
- Hill-fort security, passes and patrols.
- Recruitment and troop progression.
- Trade, tax and local revenue.

Once that region's data structure works, expand to Khandesh, Berar, Vidarbha, Konkan, Bijapur, Telangana and the southern regions.

---

# 21. Research references and provenance notes

These references support the geographic and historical framing used in this design. They do not replace region-by-region source review. The project should record exact page numbers and claim-level citations in its source registry as historical datasets are added.

1. **IGNOU, BHIC-133, History of India c.1206–1707, Unit on Vijayanagar and Deccan States.** Its geographical section describes the Deccan using the Narmada/Mahanadi north and north-east boundaries, Nilgiri/Pennar southern boundary, Western/Eastern Ghats and the Konkan strip; it discusses the Krishna–Godavari plains, Telangana, black soils, tank irrigation, the Tungabhadra doab and successor Nayak polities.  
   https://egyankosh.ac.in/bitstream/123456789/68904/3/Theme-I.pdf
2. **Carl W. Ernst, “Deccan: Political and Literary History,” Encyclopaedia Iranica.** Useful for the succession states of Ahmadnagar, Bijapur, Berar, Bidar and Golconda, Khandesh, Mughal involvement and key political transitions. The exact date and meaning of each conquest should be checked across sources before scenario data is finalised.  
   https://www.iranicaonline.org/articles/deccan/deccan-i-political-and-literary-history/
3. **Maharashtra State Gazetteer, “Medieval Administration and Social Organisation.”** Useful for regional political administration and a historical fort-network reference including Gawilgarh, Narnala, Ellichpur, Mahur, Daulatabad, Purandhar, Panhala, Parenda, Naldurg, Gulbarga, Mudgal, Raichur, Warangal and Golconda. Treat gazetteer statements as source claims to cross-check, not as unquestionable truth.  
   https://gazetteers.maharashtra.gov.in/cultural.maharashtra.gov.in/english/gazetteer/History%20Part/History_II/chapter_10.pdf
4. **Roy S. Fischel, “Deccan Sultanates,” Encyclopaedia of Empire / SOAS repository.** Useful overview of the Deccan sultanates and their varied elites and languages.  
   https://soas-repository.worktribe.com/output/379052/deccan-sultanates
5. **Shamrao Koreti, “Socio-Cultural History of the Gond Tribes of Middle India.”** A starting secondary source for the separate Gondwana political centres of Garha-Mandla, Deogarh, Chanda and Kherla; corroborate its claims with stronger regional and primary sources before final use.  
   https://www.ijssh.org/index.php?a=show&c=index&catid=74&id=994&m=content
6. **Natural Earth terms of use.** Its vector and raster datasets are public domain according to its terms.  
   https://www.naturalearthdata.com/about/terms-of-use/
7. **OpenStreetMap copyright and licence.** OSM data is ODbL and requires attribution; derivative database obligations need review before distribution.  
   https://www.openstreetmap.org/copyright
8. **Copernicus DEM documentation.** Verify product-specific availability and licence for the exact elevation product/resolution selected.  
   https://documentation.dataspace.copernicus.eu/APIs/SentinelHub/Data/DEM.html

## 21.1 Research caution

- The first map should use modern GIS only for physical coordinates and broad reference, not as a replacement for historical political boundaries.
- Historical maps are often schematic and may disagree on borders or place names.
- Gazetteers can contain valuable local details but may be late, colonial-era or based on inherited traditions.
- Genealogies may be incomplete, politically motivated or disputed.
- A historical claim must be dated. A clan's later power does not prove it had the same status, territory or allegiance in 1622.
- If evidence is uncertain, preserve uncertainty in the data rather than creating a confident but false fact.

---

**End of World Data Design v0.1**
