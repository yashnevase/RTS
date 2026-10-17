# DECCAN LORDS — Living Game Bible

**Working version:** 0.1 — Vision Capture  
**Date:** 15 October 2026  
**Status:** Active discovery; mechanics are not final unless explicitly marked **LOCKED**.

> **Source-of-truth rule:** Keep this folder in the game's Git repository. Edit the Markdown files as the canonical source because they diff cleanly, are easy for humans and coding agents to read, and support relative links. The DOCX/PDF/XLSX in `exports/` are v0.1 snapshots; Markdown is canonical and may be newer. When they disagree, the latest dated decision in `design/12_decision_log.md` wins.

## Start here

1. [Vision and design pillars](design/00_game_vision.md)
2. [Opening and player journey](design/01_player_journey_and_opening.md)
3. [World, geography and historical scope](design/02_world_and_historical_scope.md)
4. [Settlements, population and economy](design/03_settlements_population_economy.md)
5. [Military, parties, logistics and sieges](design/04_military_logistics_sieges.md)
6. [Politics, factions, companions and NPC decision-making](design/05_politics_factions_npc_ai.md)
7. [Living world, events and consequences](design/06_emergent_world_events.md)
8. [UI, accessibility, art, animation and audio](design/07_ui_ux_art_audio.md)
9. [Technology and AI-assisted development](design/08_technical_architecture.md)
10. [Future multiplayer direction](design/09_multiplayer_future.md)
11. [Scope and delivery approach](design/10_scope_roadmap.md)
12. [Open questions](design/11_open_questions.md)
13. [Decision log](design/12_decision_log.md)
14. [How v1.0 of the earlier GDD relates to this vision](references/13_prior_gdd_notes.md)
15. [Core gameplay loop: competitive RTS vs kingdom sandbox](design/15_core_loop_and_competitive_sandbox.md)
16. [Jev and agent-harness research](references/15_jev_harness_research.md)
17. [Connected economy, noble service, merchant networks and military recovery](design/16_connected_economy_politics_and_ai.md)
18. [Historical pattern intake: first story draft](design/17_historical_pattern_intake_story_draft_01.md)
19. [Recommended game format and AI-assisted production pipeline](design/18_game_format_and_ai_production_pipeline.md)
20. [Campaign progression and feature register](design/19_feature_register_and_campaign_progression.md)
21. [External Godot RTS resource evaluation](references/20_external_godot_rts_resources.md)

## Codex skill pack

- [Godot-native DECCAN LORDS skills and installation helper](../skills/README.md)
- [Recommended game format and AI-assisted production pipeline](design/18_game_format_and_ai_production_pipeline.md)

## Related agent instructions

At repository root, read `AGENTS.md`, `PROJECT_CONTEXT.md`, and `CHATGPT_VSCODE_WORKFLOW.md` before delegating work to Codex.

## Status labels

- **LOCKED** — explicitly agreed by the user after discussion; change only via a recorded decision.
- **PROPOSED** — a recommendation to evaluate, not yet a commitment.
- **OPEN** — requires discussion or evidence.
- **DEFERRED** — intentionally outside the current build, but may be considered later.
- **REJECTED** — considered and explicitly not pursued for the stated version.
- **RESEARCH** — depends on historical, technical, or market verification.

## Core collaboration rules

- Capture the user's intent before prescribing a mechanic.
- Do not silently turn examples into commitments.
- Separate historical fact, user recollection, design inference, and fictional alternate history.
- Each substantial system eventually needs: purpose, player actions, state/data, formulas, transitions, UI feedback, CPU behavior, edge cases, performance expectations, and acceptance tests.
- AI agents must not invent missing rules. They should report ambiguity and follow the latest decision log.
- Prefer a small, integrated vertical slice over a duplicate full game built in one stack and rewritten in another.

## Exported snapshots

- [Human-readable Word snapshot](exports/DECCAN_LORDS_GAME_BIBLE_v0.1.docx)
- [Printable PDF snapshot](exports/DECCAN_LORDS_GAME_BIBLE_v0.1.pdf)
- [Decision and system tracker workbook](exports/DECCAN_LORDS_DECISION_TRACKER_v0.1.xlsx)
- [Original GDD v1.0 preserved for reference](references/earlier_gdd_v1.0_original.txt)

**Editing recommendation:** modify the Markdown sources first, record the change in the decision log, then regenerate the exported Word/workbook snapshots when helpful. The exports are convenience copies, not independent sources of truth.
