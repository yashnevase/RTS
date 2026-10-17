# 06 — Living world, events and consequences

## Intended world behavior

The simulation should feel active even when the player is not watching a specific lord. NPC rulers may develop settlements, tax heavily, recruit, raid, negotiate, fight, change allegiance, respond to the Sultan's strength and take opportunities created by distance or terrain.

## Time and simulation levels — OPEN

We need to decide whether time advances continuously, in discrete days/ticks, or through a hybrid. Long-term population and politics likely need a different update cadence from tactical battles and visual animation. Avoid making every lord run expensive full-detail logic every rendered frame.

Possible tiered update concept:
- High frequency: local combat and movement.
- Periodic: economy, household needs, supply consumption and settlement updates.
- Daily/strategic turn: diplomacy, lord goals, recruitment and world events.
- Event-driven: immediate reactions to battle outcomes, betrayal, capture, famine, treaty or succession.

This is a technical/design proposal, not a final time model.

## Events should have causes

Candidate events include shortages, succession disputes, letters from superiors, tribute requests, border raids, requests for troops, a rival seeking an alliance, suspicious convoy movement, a lord asking for aid, a village refusing tax, changing monsoon conditions, bandit activity or an opportunity to attack an exposed enemy.

Events should reference actual world state and offer a small set of understandable responses. Avoid random pop-ups disconnected from the simulation.

## Consequence chain example (illustrative)

High taxation + failed harvest + weak local protection → household distress → migration/unrest → lower productive labor and tax base → weakened garrison/recruitment → neighbor sees an opportunity → raid or political demand. A player who stored grain, reduced taxes, negotiated help or protected the road could avoid or alter the chain.

The exact numerical formulas are not yet defined.

## Predictable rules, unpredictable outcomes

The player should learn reliable relationships, but not know every opponent's exact next move. Keep sources of uncertainty grounded: incomplete information, competing goals, random events within plausible ranges, delayed messages, weather variation and other agents' strategic choices.

## Reproducibility and debugging

Store random seeds for test scenarios where possible. Log important AI choices with inputs, candidate actions, scores and selected action. A developer/debug view should explain why a lord chose war, retreat, alliance or development. This makes emergent behavior tuneable instead of mysterious.

## Connected-system extension

The cross-system design connects market/household changes, merchant credit, mobile parties, raids, imperfect information, retaliation and recovery. Events should arise from actual state and actors should respond only to information they could plausibly possess. See [Connected economy, noble service, merchant networks and military recovery](16_connected_economy_politics_and_ai.md); the examples are illustrative, not locked events or formulas.
