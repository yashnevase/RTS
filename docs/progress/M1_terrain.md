# Pack 01 terrain provenance

The preview uses Natural Earth I with Shaded Relief at 1:50m, version 3.2.0. Natural Earth publishes its raster data in the public domain. The preview shows physical reference geography using a contemporary land cover composite. It makes no claim about historical land cover, routes, control or playable boundaries.

- Product and version: https://www.naturalearthdata.com/downloads/50m-raster-data/50m-natural-earth-1/
- Licence: https://www.naturalearthdata.com/about/terms-of-use/
- Archive: https://naturalearth.s3.amazonaws.com/50m_raster/NE1_50M_SR.zip
- Acquired 2026-11-07. Archive SHA-256 `ae930744c0cf3d10e73c292726b74c81a40490a75829f8299dec9069e5d0e934`.
- Derived WebP SHA-256 `34c4598b604b6b961a5acf31dd332a43c0ea3ebd255a1baa487721dd63dee7e9`.

The source world file places the upper-left pixel centre at −179.983333°, 89.983333°, with pixels spaced 1/30° apart. Crop pixel edges are 71.5°E to 78°E and 16°N to 21.5°N. The preview applies an equirectangular projection with longitude scaled by cos(18.75°). For this crop, scale variation on parallels is under 2%. This is display geometry. Future travel calculations need their own distance model.

```sh
magick NE1_50M_SR.tif -crop 195x165+7545+2055 +repage -filter Mitchell -resize 400% -modulate 86,76,100 -quality 88 pack01.webp
```

The 780×660 raster is an interpolated single regional preview texture. Its underlying 195×165 samples limit useful zoom detail. Attribution displayed in the preview is “Made with Natural Earth.”

## Current Maharashtra and Goa relief

The active basemap covers 72–82° E and 14.75–22.5° N. This is the geographic display envelope. Region Pack 01 contributes the playable-area research records. The previous Natural Earth I crop is retained for provenance only.

The 3640×2820 WebP uses Mapzen Terrarium elevation tiles at zoom 9 from https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}. Decode metres as R×256+G+B/256−32768, resample Mercator rows to latitude, and shade neighboring land heights with an ochre ramp. Land/sea mask from Natural Earth 1:10m land (public domain), https://github.com/nvkelso/natural-earth-vector/blob/master/geojson/ne_10m_land.geojson. Terrain data courtesy of Mapzen and the U.S. Geological Survey (SRTM/GMTED2010), and NOAA (ETOPO1). See https://github.com/tilezen/joerd/blob/master/docs/attribution.md for full attribution. No modern political borders are imported.
d664fab551964bd169295774ee51dbb78b72ebb18e55ffbfea1564151f54e43e  apps/game/public/terrain/maharashtra-goa.webp

Input zoom 9 comprised 180 adjacent elevation tiles. Each contains 256×256 samples. Land colors derive from elevation and a diagonal height difference for relief. Texture is local, so the running atlas needs no third-party tile service.
