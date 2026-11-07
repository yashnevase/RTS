# Map pipeline — review draft

Research envelope: latitude 8–24.5, longitude 70.5–87.5, not an approved final playable boundary. Exact v1 extent remains OPEN.

Candidate sources: Natural Earth physical geography, product-specific Copernicus/SRTM elevation, and OSM only where needed. Licence status must be checked at acquisition against primary terms; this document does not certify current permissions. Manifest records URL, product/version, downloaded date, checksum, licence text, attribution, redistribution terms and transforms. Personal use does not automatically authorize redistribution. Avoid importing OSM until its database obligations are understood for the chosen outputs.

Pipeline: acquire raw files outside runtime data → verify checksums/CRS/nodata → clip with buffer → test projection/distance distortion → derive slope/hillshade and terrain masks → review rivers/ghats against references → paint palette from physical layers → bake tile pyramid → build independently validated movement grid/graph → export manifests. GIS proves physical location, not historical political boundaries or period roads.

Proposed tiles: PNG/WebP color tiles, integer terrain grid separately, manifest with bounds/projection/scale/checksums. Tile size=512 pixels (TUNABLE), zoom pyramid selected from measured extent and target display density. Neighbor borders must sample shared source pixels to prevent seams. Edge graph uses metres, not pixels; edge crossing of rivers requires an explicit reviewed crossing. Existing corridor hints/nodes cannot silently become surveyed roads.

Rendering order: terrain, water, forests, physical lines, historical influence/claims, routes, settlements/forts, moving parties, fog, labels, selections. Show contested influence with texture/legend; do not draw invented precise historical frontiers. Label thinning uses stable priority plus collision layout. Portrait party markers appear only at useful zoom; distant markers keep readable silhouettes.

Animations: subtle water shimmer, banner motion, party travel interpolation, siege smoke, seasonal tint and later monsoon clouds. Reduced-motion switch disables nonessential movement.

Proposed budgets, all TUNABLE: 60fps target at 1920×1080; frame budget 16.7ms, renderer CPU ≤6ms; GPU texture cache ≤256MB; tile fetch/decode off critical input path; input response ≤100ms. Benchmark on a recorded integrated-GPU reference machine before declaring success. M1 verifies 65 sites/23 forts against input coordinates in an inspection layer; unverified scenario objects remain labelled rather than activated.
