# Data cleanup changelog

2026-11-06. Each heading corresponds to a separate concern / git commit; use git log for exact commit IDs.

## Restructure and audit

Initialized git and committed untouched inputs (`8b32e03`), then created `data-cleanup`. Moved authoritative master data to /data, starter templates to /templates, and the design reference to /docs. Archived loose packs, stubs and the untouched zip via git mv. Removed tracked .DS_Store. No historical values changed in this commit. See data_audit.md for original hashes and counts.

## Validator foundation

Selected Python + jsonschema because it checks portable JSON Schema without introducing the game stack. Dependency explicitly approved by the user. Added strict schemas derived from the supplied settlement/clan/family/region/polity templates and actual master shapes, with canonical coordinate and navigation names. Added cross-file ID/reference, ownership type, enum, coordinate and temporal checks. Review proposals are documents targeting existing entities, not duplicate entity declarations. They are checked without applying them. Archive/templates are never scanned. Baseline defects are expected to fail until the following repair commits.

## register missing fort source stubs

Added 37 exact referenced source IDs as status=stub. No bibliographic facts were inferred from identifier spelling; original fort-note context is copied in full. Titles/URLs stay null where no exact linkage was supplied. Sources: source_ahmadnagar_fort_asi, source_ahmadnagar_mughal_recovery_eaton, source_apics_korlai_sociohistory, source_asi_daulatabad_ncf, source_asi_panhala_inscription_review, source_census_aurangabad_daulatabad, source_dgll_korlai_lighthouse, source_dharashiv_gov_paranda, source_fortsmaharashtra_tikona, source_history_udgir_barid_shahi, source_hpip_chaul_revdanda, source_imperial_gazetteer_daulatabad, source_imperial_gazetteer_mughals_deccan, source_imperial_gazetteer_purandar, source_imperial_gazetteer_udgir, source_india_cine_hub_panhala, source_kolaba_gazetteer_janjira, source_latur_district_ausa, source_latur_district_udgir, source_maharashtra_ahead_lohagad_2015, source_maharashtra_ahead_rajgad_2015, source_maharashtra_gazetteer_mughals_deccan, source_maharashtra_tourism_panhala, source_maharashtra_tourism_purandar, source_maharashtra_tourism_rajgad, source_maharashtra_tourism_torna, source_marathi_vishwakosh_shivneri, source_morrelle_naldurg_2022, source_osmanabad_gazetteer_history, source_osmanabad_gazetteer_naldurg, source_poona_gazetteer_chakan, source_poona_gazetteer_places, source_poona_gazetteer_saswad, source_pune_district_shivneri_tourism, source_solapur_gazetteer_places, source_solapur_tourism_bhuikot, source_unesco_konkan_2024.

## clear mistyped Chaul revenue beneficiary

Set only site_chaul.ownership.revenue_beneficiary_id from polity_portuguese to null (record_version 2). Retained original revenue-privilege notes and added doubt_cleanup_chaul_revenue_type with the exact old value. Did not convert a revenue privilege into sovereignty/control. The family/clan beneficiary contract is provisional pending user review.

## flag unresolved Panhala region membership

Kept both Panhala region_id values null, following the supplied site warning. Added an explicit linked doubt instead of inventing a geographic assignment.

## infer eight missing development tiers

Assigned Tier B to the two market_town and six village records under §1.4 standard town/village simulation. Set confidence=inferred and field_confidence.development_tier=inferred, preserving prior confidence in notes and all historical cautions. This does not approve activation of provisional anchors. IDs: site_panhala, site_velhe, site_malavli, site_tikona_peth, site_gunjavane, site_donaje, site_korlai, site_murud.

## normalize metadata and resolve structural references

Every active entity now has id, record_version, source_ids, confidence and status; stub remains an explicit permitted workflow status alongside §16.2 statuses. Fort coordinates → coordinate; corridor waypoints → waypoint_ids and 1622_status → active_in_1622; missing associated_fort_ids → []. All values are preserved, and nested season evidence retains its distinct source wording. Added 65 structural node stubs using existing IDs and one minimal Janjira commander stub using the existing referenced ID and supplied name. Added linked doubts. No Item 04 proposal applied.

## Consolidate doubts without changing legacy IDs

Merged 80 input doubt entries (76 supplied plus 4 cleanup entries) into 42 unique-ID review records. Reused D1–D13 IDs are grouped by unchanged ID, with origin-labelled questions and complete verbatim originals in legacy_entries. All archived loose doubts were checked for exact preservation. No issue was dropped. Resolved only S1 and doubt_item4_missing_sites_v2 because the actual v2 and master files are now present; historical uncertainty remains open. A collision aggregate may close only when every constituent issue is resolved. The old all_doubts.json is replaced by doubts.json; baseline preserves its original bytes.

## Clear second mistyped Chaul beneficiary

The validator found the same polity_portuguese beneficiary error on fort_chaul, beyond the named site defect. Set that field to null, incremented record_version, preserved the original value in doubt_cleanup_chaul_fort_revenue_type, and kept all sovereignty/controller values unchanged.

## Retain supplied source labels

Copied nine source labels already visible verbatim in the fort notes into stub title fields (e.g. Marathi Vishwakosh, Poona Gazetteer, and ASI's 1963–64 archaeology review). These labels are explicitly not verified full bibliographic titles. The other 28 new stub titles remain null; every new author, year and URL remains null. No source research or identifier expansion was used.
