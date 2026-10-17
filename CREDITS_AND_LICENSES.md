# Credits and licenses

## M1 visual benchmark

The following texture maps are from [Poly Haven](https://polyhaven.com), licensed under [CC0 1.0](https://polyhaven.com/license). CC0 does not require attribution, but the source and creator are recorded here for project provenance. Retrieved 2026-10-17.

| Asset | Creator | Use in this project | Source |
| --- | --- | --- | --- |
| Brown Mud Dry | Rob Tuytel | Plateau ground soil maps | [Poly Haven](https://polyhaven.com/a/brown_mud_dry) |
| Sparse Grass | Amal Kumar | Plateau ground vegetation maps | [Poly Haven](https://polyhaven.com/a/sparse_grass) |
| Stacked Stone Wall | Dimitrios Savva | Fort and house stone maps | [Poly Haven](https://polyhaven.com/a/stacked_stone_wall) |

The village market house model is original project work created in Blender; its source is `assets/blender_source/village_market_house.blend` and its reproducible generator is `tools/generate_m1_market_house.py`. The Godot-ready GLB embeds the house's stone maps. Canonical source maps are also kept under `assets/textures/polyhaven/` for the ground, fort and asset provenance.

The quiet plateau wind loop is generated from deterministic procedural noise by `tools/generate_m1_ambience.py`; it contains no third-party recording. The M1 characters, terrain layout, wall, trees, rocks, HUD and prototype code are original project work. No external code packages or fonts were added.

The design documents and skill files are maintained in the companion RTS-Docs source repository and retain their original licenses and attributions where applicable.
