# Asset attribution

## Exercise data & images — `assets/data/exercises.json`, `assets/images/exercises/`
Source: [free-exercise-db](https://github.com/yuhonas/free-exercise-db) by yuhonas.
License: **Unlicense** (public domain) — see `EXERCISES_LICENSE.md`. No attribution legally required, but the repo is credited here anyway.

## Food data & images — `assets/data/foods.json`, `assets/images/food/`
Source: [Open Food Facts](https://world.openfoodfacts.org/).
- Database: **Open Database License (ODbL)**.
- Images: **CC BY-SA**.
Both require attribution and, for images, share-alike on derivatives. Show a visible "Nutrition data & images © Open Food Facts contributors, ODbL/CC-BY-SA" credit somewhere reachable in the shipped app (e.g. Settings → About/Credits) before release.

## 3D gym equipment models — `assets/images/3d/gym-equipment/`
Source: [Low Poly Gym Set](https://vnbp.itch.io/low-poly-gym-set) by VNB-Leo (itch.io).
License: **CC BY 4.0** — commercial use allowed, credit required, no resale/republishing of the raw files. Credit "VNB-Leo" wherever the app credits third-party assets.
72 FBX models: barbells, dumbbells, kettlebells, benches, pull-up bar/stand, pull-down machine, rowing machine, exercise bike, treadmills, weight plates/stands, plus some non-gym decor props (desk, sofa, TV, plant — useful if you ever build a "gym lounge" scene).

**Static renders** (decision: 2026-08-21) live in `assets/images/3d/gym-equipment/renders/` — 21 pieces (barbell, barbell stand, benches, dumbbells x2, EZ bar, kettlebell, exercise bike, flat bench, pull-up bar/stand, Smith machine, rowing machine, treadmills x2, weight plate, weight stand, generic machine, pec deck, lat pulldown) rendered in Blender 5.2 headless (`--background`), 1024×1024 transparent PNG, camera auto-framed per-model via `bpy_extras.object_utils.world_to_camera_view` (iterative fit so both long thin bars and boxy machines fill ~80% of frame), materials overridden to the app's orange accent (`#FF7A30`, linear `(1.0, 0.197, 0.0254)`, roughness 0.35, metallic 0.15) for a consistent branded look across the whole set, `Standard` view transform (not AgX) to keep colors punchy/unclipped. These *are* registered in `pubspec.yaml` and usable directly via `Image.asset('assets/images/3d/gym-equipment/renders/{Name}.png')`.

The other ~51 FBX files (accessory sub-parts, duplicate variants, and non-gym decor — desk/sofa/TV/plant/etc.) are unrendered; re-run the render script (see scratchpad, not checked into the repo) against any of them if more equipment icons are needed later. Live/interactive 3D (glTF + `model_viewer_plus`) was considered but not chosen for v1.

## Regenerating or extending these sets
Scripts used to fetch these (not checked into the app) live in the session scratchpad; re-run against `assets/data/exercises.json` (already bundled, 873 exercises total — only 21 were downloaded as local images) or the Open Food Facts search API (`world.openfoodfacts.org/cgi/search.pl`) to pull more.
