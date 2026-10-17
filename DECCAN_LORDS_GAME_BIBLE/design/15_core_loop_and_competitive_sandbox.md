# 15 — Core gameplay direction: competitive RTS vs living kingdom sandbox

**Status: HIGH-LEVEL CAMPAIGN FORMAT AGREED; detailed modes and pacing remain OPEN**  
**Created:** 2026-10-16  
**Purpose:** Preserve the user's two connected ambitions without prematurely forcing them into one ruleset.

## What the user is trying to combine

The game should have:
- A readable, repeatable strategic foundation: resources, territory, armies, settlements, geography, faction differences, clear cause and effect, and opponents pursuing understandable goals.
- A persistent-feeling world: lords remember relationships, factions rise or decline, rulers face internal rivalry, trade and supply matter, and wars change political arrangements over time.
- Long-session play: peaceful settlement development, production, growth, diplomacy, fortification and recovery.
- Strong military play: maneuver, raids, defense, sieges and battles that reward skill.
- A possible future competitive identity, not only a single-player story sandbox.

The user's Bannerlord analogy is central: many entities use a common simulation and the same categories of actions, but cultures, geography, statistics, resources, military traditions, ambitions, relationships and current events create distinct strengths and choices. The engine should be general; data and interaction create variety.

## Two different experiences are currently under consideration

### A. Living campaign / kingdom sandbox

A historical starting state seeds a broad, fixed map with named powers, lords, holdings, resources, roads and political relationships. The world advances and changes through the shared simulation. The player starts as a young heir with limited authority and can rebuild, serve a ruler, negotiate, trade, raid, fight, become independent or pursue greater power. NPCs continue making decisions, so different runs may produce different histories.

This experience favors persistent consequences, asymmetric geography, negotiation, recovery, faction survival and stories that emerge over many sessions.

### B. Competitive skirmish / RTS

Players begin from carefully designed and competitively checked scenario conditions, pursue readable objectives, gather resources, develop capabilities, control geography and defeat rivals. Matches should reward player skill, planning and adaptation rather than long-term campaign wealth or an arbitrary initial advantage.

This experience favors clear win conditions, balanced or intentionally asymmetric factions, readable counters, responsive controls, predictable core rules, fair information and bounded match duration.

The user has observed the appeal of classic AoE/Rise of Nations-style repeatable matches and wants to preserve that potential. A competitive mode, release date and specific ranked format are not approved yet. The campaign/settlement/tactical-battle combination is the agreed high-level primary format; exact scenes, transitions and first-release scope still need a technical prototype.

## Updated working recommendation from the user's historical-pattern discussion — PROPOSED

Current direction to evaluate: **a fixed, researched world that evolves into an alternate history, with settlement development, strategic movement and diplomacy, and real-time tactical battles**. The strategic campaign is the primary design target; it should combine a Bannerlord-like political/party layer with Manor Lords/Anno-inspired settlements and economy, and AoE-style real-time battle clarity. A competitive skirmish ruleset remains a possible later mode, not a v1 promise.

Recommended flow: strategic campaign map → local settlement management or strategic orders → mobile party encounters → a dedicated tactical battle/siege when appropriate → casualties, inventory, morale, holdings and relationships written back to the same campaign state. Distinct Godot scenes can share the same persistent state. Do not attempt a seamless continent-to-village-to-battle world as the initial architecture.

The world should start from a **date-specific authored political state**, not merge all factions from 1500–1800 into one ahistorical starting roster. It may diverge from history as the simulation evolves. A smaller vertical slice validates the rules; it does not cancel the long-term map ambition.

The art recommendation to test is stylised, readable 3D with a three-quarter/isometric-like camera, reusable models/rigs, coherent Deccan-inspired architecture, atmospheric lighting and strong combat feedback. This is not locked until a representative visual benchmark is built and reviewed.

See [Recommended game format and AI-assisted production pipeline](18_game_format_and_ai_production_pipeline.md) for the full proposal, staged feature scope, versioned tool recommendations and automation guardrails.

## Agreed high-level direction: one persistent campaign foundation, with optional later rulesets

The user approved the high-level hybrid direction. The architecture to test is:

- Share core entity schemas and rules where appropriate: settlements, households, goods, armies, terrain, movement, combat primitives, faction identity and orders.
- Use a **campaign layer** to add persistent economy, household development, relationships, noble hierarchy, long-term goals, supply networks and changing political control.
- If competitive play proves valuable, create a **scenario/skirmish ruleset** using the same underlying components where practical, but with its own start conditions, resource pacing, matchmaking/balance requirements, time constraints and victory conditions.
- Keep cooperative/persistent multiplayer deferred until the single-player loop and competitive/campaign identity are better understood.

Reusing a simulation foundation does not mean every number and mechanic must be identical in every mode. The design should share systems where that improves consistency, and intentionally separate mode-specific rules where fairness or pacing requires it.

## Why not lock a single "one-size-fits-all" mode now?

A long campaign allows uneven starting power, inherited lands, alliances, political betrayal, evolving wealth and recovery after defeat. A competitive match generally needs bounded time, fairness, legible starts and outcomes driven by player decisions. Trying to use identical progression and rules for both may weaken one or both.

Equally, building two entire games independently would waste time and create duplicated logic. The goal is to discover a shared core that can support both, then prove one main experience before implementing another.

## Faction identity without bespoke systems for each faction

A competitive roster can use the same underlying unit/building/economy interfaces with controlled modifiers, unlocks, costs, strengths, weaknesses and local advantages. A campaign faction can additionally have historically grounded starting territory, internal structure, diplomatic relationships, resources and evolving goals.

Faction differences must create strategic choices and counterplay, not just different colors and names. Any advantage should have a comprehensible source and a counter or opportunity cost. Home-terrain advantages should reward local knowledge while still leaving room for skilled adaptation and alliances.

## Historical start-date implications — initial research, not final roster

The world cannot simply combine every power from 1500–1800 as if they all existed in the same form at the same time. A chosen start date determines who exists as an independent power, who is a subordinate, what foreign trading presences exist, and which units, titles and technologies are plausible.

Reliable historical summaries give these useful anchors:
- The Bahmani state fragmented in the late fifteenth century into successor powers commonly identified as Ahmadnagar, Bijapur, Golconda, Bidar and Berar.
- Berar was absorbed by Ahmadnagar in 1574; Bidar was annexed by Bijapur in 1619.
- Mughal annexation of Ahmadnagar was completed in 1636; Bijapur and Golconda were conquered in 1686–87.
- Maratha power grew from the mid-seventeenth century and later became a major force in the Deccan and across much of the subcontinent.

Sources for this initial note:
- Roy S. Fischel, “Deccan Sultanates” (SOAS repository / *Encyclopaedia of Empire*): https://soas-repository.worktribe.com/output/379052
- H. Fukazawa, “Maharashtra and the Deccan: a Note,” *Cambridge Economic History of India*: https://www.cambridge.org/core/books/abs/cambridge-economic-history-of-india/maharashtra-and-the-deccan-a-note/6BD14DE79EA30B48A45308CE6227E3F5
- Metropolitan Museum of Art, *Sultans of Deccan India, 1500–1700*: https://resources.metmuseum.org/resources/metpublications/pdf/Sultans_of_Deccan_India_1500_1700.pdf
- Oxford Research Encyclopedia of Military History, “Warfare, State, and Society in Early Modern India”: https://academic.oup.com/edited-volume/63143/chapter-abstract/568215067

These anchors are not a completed historical database. Exact claims, dates, boundaries, titles, factions and events need to be researched and entered into a source ledger. Distinguish the Ahmadnagar Nizamshahi dynasty from the later Asaf Jahi Nizams of Hyderabad. Do not assume all European powers listed by the user had equal political or military presence at the same date and place; verify them for the chosen start year.

## Suggested order of discussion

1. **First: desired moment-to-moment play.** In an ordinary 10–15 minute stretch, what does the player inspect, build, command, plan or decide? What is enjoyable if no battle occurs?
2. **Second: desired campaign turn/time flow.** Does the world advance continuously, pause while menus are open, use a pause-able real-time model, or something else? How often do lords make strategic decisions?
3. **Third: historical starting state.** Choose a broad period and describe which major powers should exist at the start; then refine using the user's notes and independent research.
4. **Fourth: faction chart.** For each power: territory/geography, culture/customs, political structure, goals, strengths, weaknesses, allies/rivals, resources, troops and likely behavior.
5. **Fifth: competitive potential.** Decide whether the same game should support later skirmishes, what makes victory fair, and which campaign-only advantages must not carry into competitive matches.

Do not require the user to answer all questions in one turn. Treat these as conversation stages.

## Immediate decision

No genre, mode, exact map size, start date, or first-release feature list is locked by this document. The current working hypothesis is to design a **shared, data-driven simulation that can produce a persistent kingdom campaign**, while deliberately keeping open whether a separate competitive skirmish mode should be part of a later release.
