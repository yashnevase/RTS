# Deccan Warlords — data cleanup report

Date: 2026-11-06. Stage: Prompt 1 only. Branch: `data-cleanup`.

Cleanup is complete with **zero validation errors** and **two explicit warnings**, both for the unresolved Panhala region. No game implementation or Phase A design-lock documents were written. The ownership patch remains unapplied. Historical completeness and scenario activation are not implied by passing structural validation.

## Safety and provenance

The supplied folder was not a git repository. Initialized `main`, committed all 59 untouched supplied files as `8b32e03`, confirmed the baseline commit succeeded, and created `data-cleanup`. All subsequent work is reviewable against that baseline. There were no pre-existing working-tree edits to overwrite.

`data_audit.md` inventories every original file with SHA-256, record count and master relationship. Loose packs were moved with `git mv` into `archive/original_packs`, with their bytes unchanged; an index README identifies retained files. A migration QA comparison verified all 32 retained original archive files against baseline bytes. The authoritative master moved into `/data`, templates into `/templates`, and the reference design into `/docs`.

Removed the extracted `.DS_Store`; there is no extracted `__MACOSX` directory. The untouched original zip contains 77 OS-metadata entries internally. They remain inside that archived zip to honor the untouched-original requirement; no validator or runtime opens the zip. Removing those internal entries would change the source artifact.

## Counts before and after

“Before” means the supplied authoritative master, not a sum of overlapping loose packs.

| Dataset | Before | After | Explanation |
|---|---:|---:|---|
| Sites | 65 | 65 | Original Batch 1 = 58; clean/v2 = 57; master = 57 + 8 additions |
| Forts | 23 | 23 | Master and loose clean forts are byte-identical at baseline |
| Regions | 19 | 19 | Boundaries remain unresearched stubs/scaffolds |
| Passes | 5 | 5 | No new historical route claims |
| Crossing candidates | 13 | 13 | Later attestations remain distinct from 1622 activity |
| Corridor hints | 5 | 5 | Naming normalized, no geometry/edges invented |
| Clans | 13 | 13 | No new patrons or genealogy |
| Families | 13 | 13 | No invented members or heads |
| Polities | 3 | 3 | Existing actor scope unchanged |
| Sources | 57 | 94 | 37 missing fort-citation IDs added as stubs |
| Navigation nodes | 0 | 65 | Structural stubs under already-referenced node IDs |
| Characters | 0 | 1 | Minimal stub under the already-referenced Janjira commander ID |
| Active entity declarations, excluding review | 216 | 319 | Existing IDs retained; 103 structural/catalogue records added |
| Doubt input entries | 76 | 81 constituent issues | All 76 supplied entries preserved, plus 5 cleanup issues |
| Unique doubt IDs | 38 | 43 | Collisions grouped under their unchanged original IDs |
| Unapplied proposals | 15 | 15 | Seven fort + eight site proposals; frozen document |

The validator checks 362 declarations: 319 entities plus 43 doubt records. Of those, 120 are explicitly `status: stub` (51 sources, 65 nodes, 3 polities, 1 character). The remaining 19 region records are still draft/inferred scaffolds, not verified historical boundaries. Two doubt records are resolved, 41 remain open; grouped records can contain several independent questions.

## Repairs

1. **Missing sources:** added all 37 exact IDs referenced by forts. Copied full original fort-note context. Nine titles contain only labels already present verbatim in those notes; the other 28 titles remain null. These labels are not verified full bibliography. All 37 new authors, years and URLs remain null. No bibliography was inferred from identifier spelling.
2. **Chaul revenue:** `site_chaul` and, when validation exposed the same issue, `fort_chaul` had `polity_portuguese` in the family/clan beneficiary field. Set only those beneficiary fields to null. Preserved their exact old values in linked doubts and kept all original notes. The final beneficiary schema remains an explicit review decision.
3. **Panhala:** both region IDs remain null. Site notes explicitly prohibit assigning an adjacent region; fort notes identify only the southern pack edge. Added one linked doubt. These produce the two warnings.
4. **Eight tiers:** two provisional market towns and six villages received Tier B under design §1.4's ordinary town/village classification. Record confidence and field confidence are `inferred`; prior confidence is retained in notes. This is a simulation-detail classification, not proof that a provisional modern anchor existed in 1622. IDs: `site_panhala`, `site_velhe`, `site_malavli`, `site_tikona_peth`, `site_gunjavane`, `site_donaje`, `site_korlai`, `site_murud`.
5. **Normalization:** all entity and consolidated doubt records have `id`, `record_version`, `source_ids`, `confidence`, `status`. Fort `coordinates` became `coordinate`; corridor `waypoints` became `waypoint_ids`, and `1622_status` became `active_in_1622`. Added empty `associated_fort_ids` where absent. Evidence-specific nested season/capacity descriptions retain their original names and text. Mutated existing entities advance record versions; first-time source metadata starts at version 1.
6. **Structural dangling references:** created 65 node anchors linked to their existing sites, without edges, distances or surveyed coordinates. Added `character_siddi_ambar_sanak` as a minimal stub, copying the supplied name and fort citations; birth/death stay null. Spelling and biography remain in review.
7. **Doubts:** replaced `all_doubts.json` with `review/doubts.json`. Reused `D1`–`D13` IDs across packs caused collisions. Grouped each unchanged ID, retaining origin-labelled questions and full original records in `legacy_entries`; no doubt or historical disagreement was removed. Checked every loose-pack doubt for exact preservation. Resolved only `S1` and `doubt_item4_missing_sites_v2`, with the reason that the canonical files are now available and references are checked. Other questions about endpoints and seats remain open.

## Ownership patch: exact pending decisions

No sovereign or controller field changed anywhere. The following table describes supplied data/proposals; it does not verify their historical claims.

| Entity | Current sovereign / controller | Item 04 proposal | Decision required |
|---|---|---|---|
| Chavand | null / null | Nizam Shahi / Nizam Shahi | Retain unknown/inactive, or approve the proposed reading after resolving the fort-note warning? |
| Janjira | null / null | Nizam Shahi / Nizam Shahi | Resolve the supplied Nizam Shahi scholarly reading versus the fort's conflicting UNESCO summary; decide each field separately. |
| Udgir | null / null | null / null | Retain unknown, or provide dated evidence establishing sovereign and local control separately. |
| Torna | null / null | null / null | Retain unknown; a 1646 commandant cannot establish 1622 ownership by itself. |
| Jivdhan | null / null | null / null | Retain unknown until the supplied chronology discrepancy is resolved. |
| Hadsar | null / null | null / null | Retain unknown/inactive; the later treaty does not settle 1622 command. |
| Dabhol | Adil Shahi / null | controller null only | Confirm whether this asset was an active fort in 1622 and establish its commander; no sovereign override was proposed. |

All eight proposed site overrides also remain unapplied; they propose leaving sovereign/controller null. Janjira's named governor and garrison commander remain distinct from polity sovereignty/control.

Frozen patch SHA-256: `5ec7d4e1e5a95f2df0b269631760e1168436af122d4c9e7916d7d80ccfe82d34`. Verified byte-identical to baseline.

## Validator and verification

Selected **Python + jsonschema** because it validates portable JSON Schema without choosing the game stack. The user approved this dependency. Setup and schema conventions are in `tools/validate_data/README.md`; versions are frozen in `requirements.lock`. npm runs the two Python commands and adds no JavaScript dependencies.

Schemas derive from the supplied templates and real master fields. They validate shapes, standard metadata, confidence/status, and ownership ID prefixes. The second pass checks unique declared IDs across files, all live foreign keys (including nested source, site, fort, clan, family, polity, character and node references), ownership target types, coordinate bounds, and temporal order. Unknown JSON datasets fail rather than escaping validation.

The six confidence values follow design §16.3. Workflow status uses §16.2 plus `stub`, explicitly required by this cleanup prompt and already present in the supplied registry. Review doubts use `open`/`resolved`. These are data-cleanup contracts awaiting Phase A ratification.

The frozen Item 04 file is a proposal document whose IDs refer to existing targets, not duplicate entity declarations; it is not rewritten to add entity metadata. Its targets, sources, ownership values and assessment enums are checked separately. Original doubt `legacy_entries` are preserved evidence, not active records/foreign keys. No historical examples from `/templates` are loaded.

Executed locally:

```text
npm test
Ran 16 tests — OK

npm run validate-data
Data validation: 0 errors, 2 warnings
362 records; 15 unapplied proposals; 120 explicit stubs
Counts: character=1, clan=13, crossing=13, doubt=43, family=13,
fort=23, node=65, pass=5, polity=3, region=19, route=5, site=65, source=94
Warnings: fort_panhala.region_id and site_panhala.region_id remain unknown.
```

`data_validation_result.json` contains machine-readable output. Tests intentionally corrupt copied data to check missing references across entity kinds, wrong ownership types, duplicate IDs across files, coordinate bounds, reversed dates, enum/metadata defects, proposal defects, invalid JSON and unregistered files. A CLI test proves broken references return a failing exit code. Validation is also tested to leave every input byte unchanged. A push/PR workflow runs both commands; hosted CI has not been executed.

Migration QA additionally verified all original master entity IDs survive, all 32 archived originals retain their bytes, and every original sovereign/controller value is unchanged.

## Remaining gaps and contradictions

- Zero errors means structural integrity, not historical completeness. Source bibliography/licences, region boundaries, population, noble genealogy, troop data, route geometry and verified scenario activation remain incomplete.
- Design §3.5 does not explicitly restrict revenue recipients to families/clans, while Prompt 1 calls the polity value invalid. Clearing it avoids an unsupported schema decision; shared revenue should not silently become political control.
- Design §16.2 omits `stub` but Prompt 1 explicitly requires it. Retained it as a transparent workflow status.
- Global unique IDs and never renaming legacy doubt IDs conflict because packs reuse D-numbers. The grouped-ID representation preserves both constraints and every original entry, but requires reviewing origin-specific issues together.
- Some earlier doubts claim the 57-site file is absent; it is present locally now. Some clan notes still say seats could not be linked when only earlier attachments were available; matching textual seats to existing records needs review, not silent substitution.
- Crossing candidates have later attestations, and several new-site anchors have no established 1622 existence. Tiers and reference stubs do not authorize historical activation.
- No safe runtime navigation graph exists yet: node stubs are structural placeholders only.
- The original zip's internal OS metadata remains intentionally untouched in the archive.
- The user's master plan leaves stack and v1 scope OPEN despite proposing detailed architecture and milestone tests. No stack or design lock is inferred from this cleanup's Python tooling choice.

## Numbered decisions needed before Prompt 2

1. **Revenue schema:** allow tagged polity/family/clan beneficiaries, or model shared revenue via separate revenue-right records? Apply the decision to both Chaul entities.
2. **Panhala region:** which researched region and pack boundary should contain both records? Until evidence supports it, both stay null.
3. **Ownership:** decide each row in the ownership table, especially Chavand, Janjira, Udgir and Torna. Keep unresolved values null; no blanket patch approval is assumed.
4. **Scenario activation:** should the unverified fort states and modern-only site anchors remain inactive until dated evidence arrives? The cleanup does not activate them.
5. **Clan seats and doubt collisions:** approve the lossless grouped legacy IDs, and review textual seat matches such as Phaltan/Mhasvad against existing site IDs before linking them.
6. **Stack:** TypeScript + PixiJS/browser, or a game engine such as Godot?
7. **V1 extent:** Region Pack 01 only, or the whole Deccan at lower density?
8. **First playable duration:** about 50 years with extension, or full 200–300 years initially?
9. **Portuguese and English establishments:** independent factions or external trade actors in v1?
10. **Naval travel:** included in v1? Naval battle scope remains separate.
11. **Maratha identity:** culture, community, tags, or a defined combination?
12. **Social hierarchy/caste simulation:** none, light or detailed?
13. **Fictional generated NPCs:** allowed, with explicit fictional provenance?
14. **Art route:** AI-generated plus cleanup, commissioned work, licensed packs, or a combination?
15. **Use/licensing:** commercial or personal project?

Stop point: review this report and the data diff, then answer these decisions before Prompt 2. Phase A must produce reviewable design docs and stop again. Game work remains gated on your exact `DESIGN LOCKED` reply after that review.
