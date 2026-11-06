# Design decisions — review draft, 2026-11-06

Status: NOT LOCKED. User authorized Phase A with “proceed”; implementation requires DESIGN LOCKED after review.

| Decision | Basis and reason |
|---|---|
| Personal project | Explicit user decision; still track asset permissions. |
| Deccan-first historical sandbox | Explicit user direction; history establishes starting conditions, outcomes emerge. |
| Maratha nobles, houses and identities, no scripted empire | Explicit user direction; political allegiance remains separate. |
| Individual motives and event memories | Explicit user direction; culture/religion can influence individuals without determining morality. |
| TypeScript strict, PixiJS, React, Vite workspaces | Engineer selection delegated by user; fits campaign canvas, menus and headless simulation. Dependencies still need approval when added. |
| Campaign first, optional separate RTS later | Proposed sequence accepted as the basis for this draft; auto-resolver remains reference. |
| Developer console | Explicit user request; inspection, cheats and reproducible experiments. |
| Painted portraits, settlements and parchment UI | User art direction; exact treatment awaits samples and approval. |
| Audio deferred | Explicit user instruction. |

## OPEN — do not implement assumptions

1. Exact v1 geography: Region Pack 01 first, or whole Deccan with sparse coverage? Recommendation: Pack 01 first, broader actors represented through dated external interactions.
2. First playable horizon: 50 years or 200–300? Recommendation: validate 50 first while preserving extensible chronology.
3. Exact 1622 actor roster and playable versus external status, especially English Company and Portuguese establishments. Requested coverage includes Mughal, Mysore, Adil Shahi, Nizam Shahi, Qutb Shahi and distinct local/tribal actors; these are research targets, not new verified records. Avoid importing later colonial arrangements into 1622.
4. Naval travel scope; naval combat stays later.
5. Final culture/community/tag taxonomy and caste/social hierarchy depth.
6. Generated fictional NPC permission and population rules. Previous assistant suggested approval, but user has not explicitly resolved it. Recommendation: allow clearly fictional supporting people without overwriting known historical figures.
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
