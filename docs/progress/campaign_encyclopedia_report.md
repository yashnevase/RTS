# Campaign encyclopedia and encounter preview

Reviewed the user-provided Bannerlord screenshots and sampled the 21.58-second local recording. The campaign now draws the party moving on terrain without a route line. Each hourly worker snapshot carries the actual path segments travelled during that tick. The renderer follows those segments and turns an illustrated mounted rider as the heading changes. A pendulum-like gait and pennant motion are presentation effects. The coarse elevation, vegetation and provisional crossing grid still determines traversable routes.

Open **Encyclopedia** or press **N**. Search people, settlements and forts, and locate geographic entries on the map. The index contains 90 places, the player, a fictional supplier and the existing Siddi Ambar Sanak reference stub. Place images illustrate categories. The historical stub uses a placeholder because its source data does not establish an appearance. Live fields display market stock, the player’s company and the supplier relationship. The validated catalog remains bundled JSON. **Save** writes a versioned campaign snapshot to local browser storage. **Continue** restores it paused in the same browser and origin. Campaign changes are not written back into the historical data.

Fulfil the Saswad supply contract to raise supplier relation by 15 and qualify for reduced purchase prices there. Missing the deadline costs five relation. The market keeps a purchase/resale spread so the perk cannot generate coin through instant resale.

Arriving at a settlement opens a compact panel over the map with the actions available there. At Kondhana, choose **Investigate the raiders → Auto-resolve**. This one-time fictional encounter reads the travel cell’s terrain and applies a deterministic seeded outcome. Hills or woodland improve the defence. Guard losses and recovered coin carry into Party, Inventory and the saved campaign. Three starting guards and all combat values are preview tuning. Free-roaming 3D and tactical battle controls are future work. The RTS follow-up will use the same campaign encounter, terrain and roster inputs, with unit selection, movement, hold orders and formations.

## Generated art

The built-in imagegen tool created one transparent sheet. Cropped and resized exports are `apps/game/public/art/campaign-rider.webp` and `apps/game/public/art/saswad-supplier.webp`. Both figures are fictional.

Prompt: “One production game art sheet on a genuinely transparent background, two subjects with generous separate margins, no lettering. Left half: a whole dark bay horse with mounted fictional Deccan traveller, 17th-century inspired quilted ochre coat and wrapped dark indigo turban, side profile facing RIGHT seen from slightly elevated 3/4 campaign camera. All hooves visible, isolated silhouette suitable as a tiny strategy campaign sprite, crisp earthy painterly realism. Right half: a large upper body portrait of a distinct fictional Saswad grain merchant, middle aged with dark beard and simple dusty red turban and cream cotton angarkha, face looking slightly left with a practical thoughtful expression. No weapons on merchant, no buildings or shadows beyond either subject, no modern objects, no elaborate gilding. Both subjects entirely inside their half and separate.”

## Verification

Chrome verified encyclopedia category filtering, supplier entry, Kondhana travel and auto-resolution, guard losses, and save/reload restoration. [Encyclopedia screenshot](screenshots/encyclopedia.png) and [encounter screenshot](screenshots/encounter.png).

Tests cover interpolating along a bend, seeded encounter and terrain effects, relationship discounts and conservation of currency on a round trip. Production build and 36 tests pass. Data validation reports zero errors and the existing two Panhala warnings.
