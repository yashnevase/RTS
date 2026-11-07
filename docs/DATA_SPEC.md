# Data specification — review draft

Current executable schema authority: tools/validate_data/schemas/*.schema.json. This draft preserves the cleaned schema; new tables below are proposed contracts, not invented historical content. Final social, family and revenue contracts remain OPEN.

Every entity: id:string, record_version:positive integer, source_ids:string[], confidence:high|medium|low|contested|fictional|inferred, status:draft|researched|reviewed|approved|fictional|deprecated|stub; notes optional. Date-dependent records use nullable valid_from/valid_to with ordered years. Unknown historical fields stay null and link to a doubt. Field confidence may refine record confidence.

| Entity | Required domain fields / references |
|---|---|
| Region | name, parent_region_id?, macro_region_id?; geometry/terrain profiles await research |
| Site | name, site_type, coordinate, region_id?, route_node_id, development_tier A–D, ownership, population, economy, security, attachments |
| Fort | name, fort_type, coordinate, region_id?, protects_site_ids, ownership, garrison ranges and provenance |
| Pass/crossing/corridor | connections or waypoint_ids, source evidence, active_in_1622 narrative, season/capacity caveats; candidates are not traversable edges |
| Node | existing node ID, site_id, metadata; structural stub does not prove navigation |
| Clan/family | name, nullable leaders, member/branch IDs, dated patronage; no inferred genealogy |
| Polity | name, polity_type, metadata; ruler/capital/territory require dated evidence |
| Character | identity and metadata; full schema extends template with nullable biography and separate gameplay assumptions |
| Source | title?, author?, year?, url?, licence?, metadata; stub reference is not verification |
| Doubt | unchanged id, severity, entity_ids, question, resolution?, open/resolved, legacy_entries retained |

Ownership retains seven separate fields: sovereign_polity_id, controller_polity_id, owner_clan_id, governor_character_id, revenue_beneficiary_id, garrison_commander_id, overlord_polity_id. Current beneficiary accepts family/clan only; a proposed revenue_right record would contain asset_id, beneficiary tagged reference, share, legal_basis, dates and sources. Do not migrate Chaul until approved.

Proposed simulation tables: goods(id,unit,base_price,storage_class); recipe(id,input quantities,output quantities,capacity unit); troop_type(id,recruitment_tags,stats,wage,equipment,upgrade_ids); route_edge(id,from_node_id,to_node_id,length_m,terrain_profile_id,season_profile_id,capacity,toll_right_id?); rule_profile(id,simulation_version,units,parameters); relation_memory(id,from_entity_id,to_entity_id,event_id,tick,dimension_effects,decay_profile_id); command(id,tick,sequence,issuer,type,payload). All receive metadata and typed foreign keys. Exact troop names/rules await approval and research.

Scenario manifest: id, schema_version, simulation_version, start_date with precision, world_id, included_pack_ids, snapshot_refs, seed, activation list, assumption_profile_ids. Base records are immutable historical inputs; dated snapshot overrides reference existing IDs and preserve sources. Runtime mutations become state/events, never edits to source JSON. Missing required ownership disables control-dependent actions or requires an explicitly labelled scenario assumption.

Stable IDs never change with names or allegiance; deprecate and link replacements. New packs append globally unique IDs and declare dependencies. Loader rejects duplicate declarations, unresolved references, unreviewed overrides and invalid activation. Archive and fictional templates never load. Keep historical claims and gameplay balance/traits in separate records so assumptions cannot become historical facts.

Saves contain schema/sim versions, pack hashes, state, tick/calendar, RNG streams, command sequence and event cursor. Migrations are pure, sequential and tested against fixtures; unsupported versions fail with a recovery message and keep the original save.
