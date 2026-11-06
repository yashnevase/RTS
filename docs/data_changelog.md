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
