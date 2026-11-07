# Art and audio — review draft

Direction proposed for approval: painted historical realism with restrained Deccan manuscript ornament, warm parchment, basalt grey, muted indigo, cloth red and brass accents. Avoid copying another game's layouts/art and avoid fantasy armor or generic European medieval architecture. Audio work is deferred by user instruction.

Generate a comparison sheet containing a fictional noble portrait with neutral/pleased/angry expressions, a merchant portrait, fort and village icons, a campaign-map crop and a dialogue panel. This is concept art, not authenticated costume research or real historical likeness. Named historical portraits require reference/provenance review; unknown faces must be labelled interpretive.

| Asset | Proposed export size (TUNABLE) | Rules |
|---|---|---|
| Main portrait | 1024×1024 source, 512px UI | Fixed camera, light and framing; neutral reference controls all expressions |
| Expression set | Same canvas and silhouette | Neutral, pleased, concerned, angry; preserve identity, clothing and lighting |
| Map portrait token | 128×128 | Circular frame only in UI; readable silhouette, zoom-gated |
| Settlement/fort icon | 256×256 RGBA | Common oblique angle, anchor baseline, tier distinctions; test at 32px |
| Panel background | 1920×1080 | Low-detail text area; typography rendered by UI |
| Goods/action icons | 64×64 or vector | Common weight; texture never obscures meaning |
| Terrain tiles | See MAP_PIPELINE | Physical and decorative information kept distinct |

Asset manifest: stable asset_id, path, checksum, creator/tool, prompt, reference assets, generation date, licence/terms snapshot, attribution, historical confidence, review status and allowed uses. Do not claim generated art is source evidence. Image generation can drift; approve a reference sheet, derive variants from it and inspect the actual small-size crops. Production must support placeholder silhouettes and replaceable atlases without changing entity IDs.

Art approval is a separate visual decision before polished-map production. Mockup beauty alone does not prove runtime readability or performance. Maintain a small approved palette/style reference and reject inconsistent costume, lighting and architecture.
