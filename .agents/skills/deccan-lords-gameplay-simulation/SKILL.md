---
name: deccan-lords-gameplay-simulation
description: Design or implement DECCAN LORDS gameplay rules and Godot simulation systems: households, production, trade, characters, factions, politics, parties, armies, combat, logistics and explainable CPU behavior.
---

# Gameplay and Simulation Specialist

## Before changing code

Read the relevant Game Bible document and latest decision-log entries. Separate:
- locked player-approved rule;
- proposed design;
- open question;
- historically sourced claim;
- user observation/interpretation;
- implementation inference.

Do not invent historical labels, starting holdings, probabilities, costs, tax rates, victory conditions or formulas. When exact values are open, use a clearly labelled tunable placeholder only if the task requires it, and document the placeholder.

## Architecture

- Keep persistent campaign/simulation state separate from Godot Nodes used for visuals and UI.
- Prefer typed, data-driven definitions for goods, buildings, unit roles, factions, terrain effects and event types when they reduce duplication.
- Represent state changes as explicit commands or domain methods with validation, rather than arbitrary UI callbacks mutating unrelated data.
- Use stable entity identifiers and versioned save data for long-lived entities.
- Use common rules and different actor/faction/settlement data. Avoid bespoke scripts per lord or culture.
- Separate skills, personality traits, goals, relationships, beliefs, information and obligations. They should not collapse into one generic friendship or intelligence score.
- Use deterministic seeded randomness for reproducible scenarios. Randomness must not replace causal logic.
- Use aggregate household/workforce simulation for ordinary residents and finer character simulation where personal agency matters; do not create complex autonomous logic for every resident by default.

## Simulation behavior

A useful NPC decision should be traceable to: actor goals, current resources, legal/political obligations, geography, risk, relationships, known information, alternatives and expected outcomes. NPCs must not see hidden player state unless the rules give them a way to learn it. Record the major decision and its reasons in debug output where practical.

For economy and warfare changes, test both sides of the transaction: money and goods sources/sinks, labour gained/lost, upkeep, casualties, travel time, inventories and persistence. Check repeated loops for exploits (for example, unlimited buying/selling, loans without repayment, loot duplication or levy disband/refill loops).

## Scope and tests

- Implement one connected behavior at a time.
- Write tests for normal, boundary, invalid and recovery cases.
- Test at least one CPU-controlled actor under the same world rules when changing a shared system.
- Do not add runtime LLM inference, multiplayer networking or external services unless explicitly approved.
- If a mechanic depends on historical evidence not yet supplied or verified, preserve it as open and make the gameplay abstraction explicit.
