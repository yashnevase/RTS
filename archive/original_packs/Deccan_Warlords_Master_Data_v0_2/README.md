# Deccan Warlords master data v0.2 (Region Pack 01, draft)
Built by merging Batch 1 (v2), Item 01 (new sites), Batch 2A (forts), Items 2, 3, 5 and the stubs.
Counts: {'sites': 65, 'forts': 23, 'passes': 5, 'crossings': 13, 'corridors': 5, 'clans': 13, 'families': 13, 'sources': 57, 'doubts': 76}

NOT APPLIED: Item 04 ownership patch (review/item04_ownership_patch_NOT_APPLIED.json). It left almost every owner blank
and its two filled forts (Chavand, Janjira) conflict with Batch 2A notes. Decide manually.

Changes made during merge:
- site_korlai: primary name set to Korlai (was a diacritic variant)
- added 8 sites from Item 01
- site_chakan.owner_clan_id: clan_bhosale -> clan_bhosale_shahaji
- site_pune.owner_clan_id: clan_bhosale -> clan_bhosale_shahaji
- site_pune.revenue_beneficiary_id: family_bhosale_main_line -> family_bhosale_shahaji_line
- site_supe.owner_clan_id: clan_bhosale -> clan_bhosale_shahaji
- site_supe.revenue_beneficiary_id: family_bhosale_main_line -> family_bhosale_shahaji_line

Known gaps: 49 sites have no sovereign; clan seats and members mostly empty; passes and crossings have no coordinates;
crossings are 19th-century ferries kept as inactive candidates; Panhala has no region; no characters yet.
