# M1 preview handoff

Run `npm run dev` and open http://127.0.0.1:5173. The preview provides drag pan, pointer-centred wheel zoom, fit-region control, settlement/fort filters, name/ID search and a historical-record inspector. All 65 sites and 23 forts use their canonical coordinates.

The user approved Vite, React, React DOM, PixiJS and React definitions. The UI currently uses JSX. Core TypeScript checks cover map projection and camera utilities, while the JSX renderer is checked by the production build.

Build, 21 tests and data validation pass. Two Panhala region warnings persist. The production bundle triggers a large-chunk advisory. Browser visual inspection and a measured 60fps benchmark are pending user review, so full M1 acceptance remains pending. Terrain is the low-resolution Natural Earth crop documented in M1_terrain.md. More detailed terrain, final artwork and tile streaming remain future map work.

## Revised regional atlas

The camera opens around Pune. Campaign mode shows selected seats, one or two nearby forts where supported and the satellites of the current district. The district list handles places at nearly coincident coordinates. Register mode retains all 88 canonical places. Two separately sourced orientation landmarks show Portuguese Goa and the northern Mughal approach at Burhanpur. They are display records, outside the active historical dataset. Historical notes link to the UNESCO records for [Old Goa](https://whc.unesco.org/en/list/234/) and [Burhanpur](https://whc.unesco.org/en/tentativelists/6731/).

The supplied Deccan Warlords art study provides the title, fictional journal portrait, paper texture and illustrated settlement/fort symbols. Symbols represent place types. A shared silhouette is not a reconstruction of the individual place. Campaign membership is a display decision. District links do not assign ownership, production quantities or traversable roads.

Chrome inspection on 2026-11-07 verified the rendered canvas, selection of Saswad, all 90 register entries (88 Pack 01 records plus two reference landmarks), the 23-fort filter, Portuguese Goa, the northern frontier and Janjira's unknown sovereign/controller. The default view is captured in [M1-district.png](screenshots/M1-district.png). A 100-frame idle headless software-rendered sample measured 57 fps. It does not certify sustained 60 fps during pan/zoom on target hardware. Full M1 performance acceptance is still open.
