# Design decisions — review draft, 2026-11-06

Status: DESIGN LOCKED for the agreed scope, 2026-11-07. User approval: “lock the dwsign agreed proceed”. M0 authorized; subsequent milestones require review. OPEN historical and feature decisions below remain unresolved and cannot be silently implemented.

Latest agreement: initial playable horizon is 50 years, with explicitly fictional supporting NPCs permitted under separate provenance. These accept the recommendations in the immediately preceding exchange. Region Pack 01 is the first polished campaign. No historical characters or facts may be overwritten by fictional generation.

| Decision | Basis and reason |
|---|---|
| Personal project | Explicit user decision; still track asset permissions. |
| Deccan-first historical sandbox | Explicit user direction; history establishes starting conditions, outcomes emerge. |
| Polished Region Pack 01 campaign first | User decision, 2026-11-07: finish a small campaign before geographic expansion. Scope is smaller; quality and complete career loops remain the goal. |
| Maratha nobles, houses and identities, no scripted empire | Explicit user direction; political allegiance remains separate. |
| Individual motives and event memories | Explicit user direction; culture/religion can influence individuals without determining morality. |
| TypeScript strict, PixiJS, React, Vite workspaces | Engineer selection delegated by user; fits campaign canvas, menus and headless simulation. Dependencies still need approval when added. |
| Campaign first, optional separate RTS later | Proposed sequence accepted as the basis for this draft; auto-resolver remains reference. |
| Developer console | Explicit user request; inspection, cheats and reproducible experiments. |
| Painted portraits, settlements and parchment UI | User art direction; exact treatment awaits samples and approval. |
| Audio deferred | Explicit user instruction. |

## OPEN — do not implement assumptions

1. RESOLVED 2026-11-07: Region Pack 01 first. Exact playable boundary and activation list still require geographic/historical review; membership in the input pack does not establish scenario readiness.
2. RESOLVED: 50-year initial playable horizon; long soak tests remain technical validation, not a promised launch duration.
3. Exact 1622 actor roster and playable versus external status, especially English Company and Portuguese establishments. Requested coverage includes Mughal, Mysore, Adil Shahi, Nizam Shahi, Qutb Shahi and distinct local/tribal actors; these are research targets, not new verified records. Avoid importing later colonial arrangements into 1622.
4. Naval travel scope; naval combat stays later.
5. Final culture/community/tag taxonomy and caste/social hierarchy depth.
6. RESOLVED permission: clearly fictional supporting NPCs allowed. Exact generation/population rules still require design before M4.
7. Player lineage, death, adoption, marriage eligibility and succession rules. Adult-only marriages recommended; historical claims require evidence.
8. Chaul revenue-right schema; Panhala region; all ownership-patch decisions in cleanup report. Keep unknowns null and patch unapplied.
9. Art sample selection, portrait identity consistency and historical costume review.
10. Exact troop trees, world density, attribute growth and family rules remain research/design decisions.

## Contradictions resolved or preserved

- Earlier assistant called this straightforward and implied fictional NPC permission: both overstatements. Polished graphics and believable simulation require repeated testing; NPC permission remains OPEN.
- “Fixed world” means stable geography and starting records; control, wealth, family membership and borders can evolve.
- Randomness is seeded and saved, so surprising outcomes remain reproducible.
- Requested historical realism does not justify inventing unrecorded personalities. Historical character traits need provenance or an explicit gameplay-assumption layer.
- Audio is deferred despite the original M7 audio proposal.
- Art is generatable; finished atlases, animation and consistent expressions still require review and integration.
