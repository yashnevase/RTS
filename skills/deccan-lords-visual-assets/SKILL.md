---
name: deccan-lords-visual-assets
description: Create and integrate the cohesive stylised 3D art pipeline for DECCAN LORDS with Blender and Godot: terrain, Deccan-inspired architecture, modular buildings, characters, materials, animation, lighting and licensed asset reuse.
---

# Visual Art and Asset Specialist

## Art-direction guardrails

The agreed high-level target is stylised readable 3D with a three-quarter/isometric-like strategy camera. Benchmark the style before creating many assets. Prioritise the Deccan landscape and architectural silhouettes, village/market/fort readability, unit scale, team/faction legibility and pleasant atmospheric lighting. Do not drift into generic European-medieval architecture as the final visual identity.

## Asset workflow

- Inspect the existing project and current art benchmark before creating or replacing assets.
- Reuse a small coherent modular kit where possible: ground/rocks, trees, roads, rural homes, production buildings, walls/towers, market props, carts and a small unit/character set.
- Use Blender for editing, kitbashing, low-poly modelling, UV/material cleanup and animation preparation. Prefer GLB/glTF exports for portable assets. Maintain consistent real-world scale, origin/pivot, naming, texture resolution, material palette and collision/LOD policy.
- Prototype with existing assets, but don't disguise mismatched styles as a final art direction. A custom silhouette, material palette or simple Blender edit may be enough to make a coherent kit.
- Don't mass-generate hundreds of models before the benchmark is approved. Use one representative asset per important family first.
- Do not call paid asset-generation APIs or submit user/project data to external services without explicit approval.

## Reuse and licensing

Prefer suitable CC0/free assets for prototypes; useful starting points include [Poly Haven's CC0 library](https://polyhaven.com/license) and individual [Kenney asset packs](https://kenney.nl/assets). Confirm the licence of the exact asset/pack—do not infer every pack on a marketplace has the same licence. Keep a `CREDITS_AND_LICENSES.md` or equivalent manifest with source URL, creator, licence, attribution requirement, download date and any modification.

A private repository does not remove licence obligations if assets later ship with a public game. Do not rip assets from commercial games, copy someone else's distinctive art, or redistribute raw paid assets. Use assets as components of the compiled game only to the degree their terms allow.

## Evidence required

For art changes, capture the actual Godot scene at the target camera and useful zoom levels, inspect silhouettes/material consistency, and report missing animations, placeholder assets, import warnings and visual limitations. A render from Blender alone does not prove the asset looks correct in Godot.
