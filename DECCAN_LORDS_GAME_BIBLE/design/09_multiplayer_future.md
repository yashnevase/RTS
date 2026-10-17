# 09 — Future multiplayer direction

## Desired long-term experience

The user imagines shared sessions in a world containing many lords, kings and emperors. A real player could join as a lower lord; friends could join other positions; players might support a higher lord, vote for a leader, negotiate policy, join armies, form coalitions, attack rival players or AI powers, and eventually compete to become a king or emperor.

This is a strong long-term product vision, but not a confirmed v1 deliverable.

## Questions that make this a distinct game mode

- Can multiple human players be in the same clan/faction or only in separate lordships?
- Can a player join an existing session mid-campaign? What happens to the previous lord's state?
- Are votes binding, weighted by territory/standing, or purely political?
- Can a human ruler order an AI vassal? Can players refuse orders or rebel?
- What happens when the human king logs off, disconnects or becomes inactive?
- Is the world persistent between sessions or saved only by a host?
- How long are sessions expected to run?
- What prevents griefing, collusion, exploits, and one player locking others out of meaningful play?
- Which campaign rules must be deterministic or server-authoritative?

## Recommendation

Design the single-player state model so that key actions are explicit and systems are independently testable. Once the campaign is fun, select one target first: cooperative battle, competitive skirmish, or persistent political session. Do not attempt all three networking models at once.

## Status

**DEFERRED for implementation; retained as a design goal.** No network protocol, matchmaking, backend or multiplayer feature list is locked yet.
