# 19 — Campaign progression and feature register

**Status:** Long-term design register. Items are not automatically part of the first release. High-level campaign format is LOCKED; content, chronology and most detailed rules remain PROPOSED, OPEN or RESEARCH.

This file exists so the ambitious vision stays visible while implementation proceeds in small, playable steps. The register is a planning map, not a commitment to build every listed feature before release.

## 1. Player fantasy and campaign progression

**Setting decision:** fictional alternate-history Deccan, not a strict historical reenactment. The player does not need to encounter real historical heroes or follow the Maratha/Shivaji story. Fictional kingdoms and clans may be mixed with broadly inspired imperial powers. Selective research improves believable geography, architecture, economy and military logistics; exhaustive historical verification is not a gate for the RTS prototype. See the vision and decision log for exact boundaries of this decision.

### Starting point

The player starts as a lord/clan leader who inherits holdings appropriate to the selected date, polity, rank and scenario. Possible holdings include villages, a small fort, a town, a private force, clan property, income rights, obligations, allies, rivals and debts. Every noble does not automatically receive a town, fort and several villages.

The opening should quickly give the player a meaningful choice: what to secure first, which obligations to honour, who to approach, what to build or improve, and whether to prioritise revenue, reputation, local welfare, military readiness or independence.

### Long-term routes (campaign possibilities, not mandatory linear ranks)

A player may pursue several overlapping careers:
- **Local lord:** strengthen inherited holdings, improve settlement prosperity, protect people and routes, gain prestige and increase practical authority.
- **Royal/imperial servant:** serve a chosen ruler, complete favours or assignments, contribute troops/revenue, negotiate for privileges and appointments, rise in court influence and political importance.
- **Warlord/coalition leader:** recruit or command forces, gather other lords, lead campaigns, raid/intercept supply, defend or capture strategic locations and build military reputation.
- **Independent power:** switch allegiance, support a rival claimant, leave service, secure supporters, establish a new kingdom or seek imperial authority if the political conditions allow.
- **Builder, trader or political broker:** invest in production, market access, caravans, merchant relations, credit, negotiations and alliances to build influence beyond battlefield victories.

These routes should emerge from shared systems rather than separate fixed story campaigns. They must remain plausible for the selected historical/alternate-history rules. Whether a player can become a king or emperor should depend on a coherent, data-driven legitimacy/support/territory/institution model—not a single arbitrary level-up or universal vote mechanic. Exact conditions remain OPEN pending the master history and game tests.

## 2. Clan, family, companions and administration

- The player belongs to a family/clan with identity, relationships, obligations and potential succession consequences.
- Companions are meaningful characters with skills, abilities, traits, ambitions, relationships and possible personal parties.
- Companions or trusted nobles may be appointed to administer a town, fort, region, caravan, garrison or party where the political system permits it.
- Delegation should let the player set a clear policy/budget/goal and receive useful reports. The appointee should manage routine work within those limits, with visible outcomes and a way to intervene.
- A trusted administrator may improve productivity/security/logistics according to skills and context, while rival interests, debt, loyalty or poor ability may create different outcomes.
- Do not implement unlimited companions by default. The intended freedom is to find or persuade additional noble actors where the world supports it; use meaningful roster/administration constraints where needed to preserve trade-offs and performance.

## 3. Settlement, households and economy

**Working baseline:** hybrid households/workforce simulation. Households and homes matter; the player assigns labour by job/category rather than ordering every individual villager.

Long-term possibilities:
- Villages, towns and fortified sites with different storage capacity, defensive value, population, tax base, services and production specialisations.
- Household needs, housing tiers, population growth, migration, prosperity and local security.
- Farm/crop choices, forestry, mining, stone, livestock, water use, craft workshops and period-appropriate manufacturing or processing.
- Production inputs/outputs, inventories, warehouse allocation, construction materials, tool/weapon stocks, livestock and goods transport.
- Markets, prices, local demand, seasonal/terrain constraints, trade routes and caravans that can be escorted, delayed, intercepted, robbed or rerouted.
- Tax settings, tribute/service obligations, wages, maintenance and spending that influence both current funds and future prosperity.
- Roads, bridges, passes and strategically placed forts that protect multiple villages or important routes.
- Optional build/upgrade/downgrade decisions that shift capacity, workforce and demand. Avoid requiring the player to manually micromanage every household.
- Prosperity attracts new families only when housing, work, food/security and other modeled constraints permit; growth should not create free infinite labour or wealth.

## 4. Merchant and credit network

Merchants are persistent world actors, not decorative shop menus. Candidate state includes inventory, available capital, routes, business partners, obligations, credit, trust, friends/rivals and information sources.

Possible interactions:
- Buy, sell, request goods, arrange a caravan, ask for escort, negotiate a contract, borrow to fund a project, repay/refinance debt, default or resolve a dispute.
- Merchant prices/credit/terms reflect liquidity, scarcity, risk, route security, history of repayment, demand and relationships.
- Traders may prefer safer routes, reduce service, ask for protection, finance one side, or share reports with people they trust.
- A lender can gain leverage or lose capital from bad debts; a debtor can gain short-term capacity but suffer reputational or political consequences.

Exact interest, credit, price and default rules require research and abuse-case tests. Avoid unlimited buy-sell loops or loans with no meaningful cost.

## 5. Political and social simulation

Candidate systems:
- Kingdoms/realms/empires, rulers, lords, clans, dynasties, houses, councils/courts where historically suitable, estates, fortresses, settlements, military parties and merchant groups.
- Flexible noble-service arrangements: salary, revenue rights, administration, remittance, privileges, service obligations and inherited/occupied/granted holdings may vary by polity, rank and circumstance. Only the mix-and-match high-level principle is locked.
- Favour/quest/contract requests, gifts, promises, compensation, marriage/dynasty where appropriate, alliance, trade agreement, non-aggression/peace, tribute, vassalage/service, war, support for a claimant and allegiance change.
- Relationship dimensions kept separate where meaningful: trust, reliability, fear, gratitude, rivalry, shared interest, family tie, debt, reputation and current political alignment.
- Public standing, legitimacy, elite backing and practical power can differ. A ruler may have a formal title but weak control of remote holdings; a lord may have limited title but strong local support or strategic assets.
- Culture/religion/local identity influence loyalties and policy outcomes contextually. Do not hard-code each culture/religion as permanently hostile to another.
- Political requests and events should have readable stakes and optional explanations, not unending dialogue or meaningless click-through.
- Courts and noble personalities compete for prestige, influence, rights and appointments. Delegation can increase the ruler's capacity while also creating powerful subordinates.

## 6. Military, parties, patrols and tactical combat

- Recruit from appropriate pools: trained soldiers, temporary levies, household/estate obligations, mercenaries, allied contingents and other researched sources.
- Army composition affects wages, supply, speed, morale, training, quality, upkeep and effectiveness; numbers alone should not decide every battle.
- Manage personal retinue/party, garrisons, patrols, escorts and large campaign armies. Parties may merge/split if command, logistics and political rules permit.
- Real-time tactical battles: select units, issue move/attack/hold/retreat commands, arrange formations, exploit terrain/cover/elevation/line of sight, guard flanks and protect vulnerable groups.
- Units should communicate orders and outcomes through animation, UI and sound; battle readability and responsive control are core quality gates.
- Fortifications/walls/gates/towers, field camps, relief armies, supplies, artillery/siege equipment and siege duration are long-term possibilities, scaled to research and the chosen release.
- Army members need wages, food/supply, rest, training, morale and recovery. Recovery at home, camp or barracks can be improved by safe facilities/upgrade.
- War should alter campaign state: casualties/lost labour, equipment, treasury, captured or destroyed stock, reputation, loyalties, damaged holdings, prisoner/ransom policies if included, route security and political arrangements.
- Outposts/forts may protect several villages and roads; storehouses and military stocks can be raided or captured. Fort building should be strategic and readable, not a repetitive wall-placement burden.

## 7. Information, intelligence and world response

Potential features include patrol reports, scouts, spies, rumours, letters/orders, merchant reports, missing caravans, intercepted supplies, false reports, informants, assassination or sabotage, ransom, captured characters, revenge and political consequences.

Start with a basic and legible information model:
- What an actor actually knows or believes.
- How they learned it, source reliability and how old it is.
- How the actor values the report, goal and risk.
- Which actions are possible under time, distance, resource and political constraints.

Spying, assassination, captive/slavery/forced-labour systems, religious conversion policy and detailed prisoner rules are not automatic v1 features. They need explicit history, ethics/tone, legal/licensing and gameplay design. Do not make them casual features only because they existed historically.

## 8. Long-session enjoyment and retention

The target is a game players can enjoy for many hours, not a realistic spreadsheet. Validate these design qualities repeatedly:
- **Short loop:** each few minutes the player can make a clear decision, see feedback and respond to a changing need or opportunity.
- **Medium loop:** a settlement improvement, safer trade route, fulfilled obligation, recruited party, battle or political relationship changes the player's position.
- **Long loop:** rebuild a clan, climb political power, establish a new kingdom, secure an empire, protect a trading network or survive an ambitious rival.
- **Emergence with causality:** stories arise from events/relationships/resources and can be explained afterward; random events add variety, not arbitrary punishment.
- **Automation through delegation:** capable administrators, companions and commanders can run routine tasks within player-set policy. The player still receives control over consequential decisions.
- **Low tedious micromanagement:** group repeat notifications; make routine orders reusable; provide priorities and summaries; use pause/slow/normal/fast controls where appropriate; keep deep detail optional.
- **Fair challenges and recovery:** setbacks should close some options while leaving meaningful ways to recover, negotiate, rebuild or change strategy. Permanent wipeouts and soft-locking need deliberate design.
- **Readable cause/effect:** explain shortage, revolt risk, trade disruption, unpaid troops, political anger and AI decisions in understandable language.
- **Variety across campaigns:** geography, start situation, actor traits, relationships, resource opportunities and initial political state should change viable strategies without requiring a different code path for every character.
- **Player authorship:** remember and surface important campaign events in a compact chronicle/news/letter system where useful; avoid interrupting play with endless popups.

These are hypotheses to validate through playtesting, not proven retention outcomes. Use observed confusion, session repetition, decision diversity and player comments as evidence rather than claiming “addictive” or “long-term enjoyable” by design alone.

## 9. Implementation register

| Area | First proof | Later expansion | Status |
|---|---|---|---|
| World/camera/identity | Small Deccan visual benchmark | Wider map, more terrain, locations and seasonal/weather variants | PROPOSED |
| Tactical RTS | Bounded battle, a few unit roles, move/attack/hold/retreat, basic CPU | More formations, siege, command hierarchy, varied factions | PROPOSED |
| Settlement | One settlement, households/workforce categories, 3 production activities, storage, basic market, tax/upkeep, notices and save/load | More goods/chains, household tiers, dynamic markets, town specialisation | M3 prototype implemented; all quantities and formulas remain temporary tuning |
| Campaign travel | A few named map locations and one moving party | Broad fixed map, many parties, travel risk and routes | PROPOSED |
| Politics | One ruler/overlord relationship and one meaningful obligation/favour | Court, rank progression, changing allegiance, king/emperor legitimacy | Structure principles partly agreed; historical rules OPEN |
| Merchants | One trader, inventory, simple trade/escort event | Credit, loans, business network, contracts, rivals | PROPOSED |
| Army/world integration | One campaign encounter connected to a tactical battle | Patrols, coalition armies, recovery, sieges, logistics and captured stock | PROPOSED |
| AI | Goal/constraint/relationship data, logged choice reasons | richer planning, imperfect information, long-lived memory | Explainable rules first; ML not assumed |
| Family/clan | One player's clan identity and few companions if needed | Dynasty, marriages, succession, delegated estates and companion families | OPEN / RESEARCH |
| Intelligence | Visible patrol/scout report with freshness/reliability | spies, counter-intelligence, rumours, betrayal events | DEFERRED until core loop |
| Multiplayer | None in first proof | Co-op/competitive if product and networking justify it | DEFERRED |

## 10. Constraints before a mechanic is locked

For each candidate feature, record:
1. Player problem/fantasy it serves.
2. Required entities/data and state changes.
3. Normal, boundary and failure outcomes.
4. What the CPU knows and why.
5. Effects on economy, politics, military, population and save/load.
6. UI feedback and how a new player understands it.
7. Historical sources or explicit fiction boundary when relevant.
8. Tests that detect exploits or regressions.
9. First-release priority and dependencies.

Do not finalize every detailed mechanic before the master history is reviewed. Use this register to preserve the vision, while the M0–M7 pipeline determines implementation order.
