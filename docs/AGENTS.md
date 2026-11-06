# Standing engineering rules

- Read DECISIONS.md and the applicable specs before work. This design is a REVIEW DRAFT until the user replies exactly DESIGN LOCKED. No game implementation before that gate.
- Work one approved milestone at a time; report and stop for inspection. New scope goes to backlog.md.
- Never invent historical facts. Unknown stays null with a doubt. Separate fictional/gameplay assumptions from sourced history. Preserve conflicting evidence.
- Never change stable IDs; deprecate instead. Never apply frozen review patches without explicit authorization.
- Deterministic simulation: seeded versioned RNG streams only, no Date.now() or Math.random(); stable iteration, fixed-point authoritative arithmetic and recorded commands.
- Simulation core never imports rendering, UI, DOM or browser storage. Worker and headless tests share the same engine.
- Every task ends with npm test and npm run validate-data passing. Zero errors does not mean historical completeness; report warnings.
- Small commits, one concern each. Ask before adding dependencies. Do not overwrite user changes.
- Culture/religion do not encode inherent morality or ability. Individual motives and memories drive decisions; historical traits require provenance or explicit assumptions.
- Save migrations preserve original saves. Console mutations use logged commands and flag modified saves.
- Respect licences, preserve asset provenance, and review historical costume/architecture. Audio deferred.
- When requirements conflict or an OPEN decision blocks implementation, ask; do independent authorized work first.
