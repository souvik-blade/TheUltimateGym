# Fitness Pro — project requirements

Living doc capturing product decisions as they're made, so future work (mine or yours) has context without re-deriving it. Update this file whenever scope changes.

## Product
A premium-feeling fitness app: glassmorphic UI, dark background, orange accent (`#FF7A30`/`#FFB07A`). Two core pillars:

1. **Workout** — exercise library, logging, tracking.
2. **Diet program** — personalized to the user's physiology, not generic meal plans.

## Decisions (2026-08-21)

### Diet engine: auto-calculated macros
- User enters **gender, age, height, weight, activity level, goal** (cut/maintain/bulk).
- App computes **BMR** via the **Mifflin-St Jeor equation** (the standard gender-aware formula — differs by sex because it uses a fixed sex-based constant term), then **TDEE** by multiplying BMR × activity factor, then daily macro targets (protein/carbs/fat) from TDEE + goal.
- Food logging tracks intake against those computed targets — not a static pre-built plan.
- **Built** (2026-08-22): `lib/features/diet/` — `BmrCalculator` (pure functions: BMR via Mifflin-St Jeor, TDEE via activity multiplier, macro split by goal), `UserProfile`/`MacroTargets` models, `DietCalculatorScreen` (form + results UI, reached from the home screen's "Diet program" card). Cut deficit is clamped to never go below BMR. Sex options are male/female/other (`other` averages the two Mifflin-St Jeor constants). 13 tests covering the math and the full fill-form-and-calculate UI flow, all passing (`test/features/diet/`).

### Scope (v1)
All of the following are in scope:
- Workout logging/tracking (sets/reps/weight history)
- Progress photos/measurements (body weight + measurement timeline)
- Streaks/gamification (daily streak, already mocked in `HomeScreen`)
- Social/community (following, sharing, leaderboards)

**Tension to resolve**: social/community needs a backend (accounts, shared data), but the backend decision below is local-only. Recommendation: build local-only first for workout/diet/streaks (fast to ship, no infra), and treat social as a phase-2 addition once a backend is introduced — don't block v1 on it.

### Backend: local-only for now
- On-device storage (`sqflite`, already a transitive dependency via `cached_network_image`'s deps — add directly, or use `hive`/`drift` if preferred) — no login, no server.
- Add a real backend (Firebase/Supabase) later if/when social features are prioritized.

### Platforms: Android + iOS
- Android verified working (Moto G64 5G, wireless debugging over Tailscale — see adb connection notes below).
- iOS needs a physical-device or simulator run for verification (not yet done this session).
- Web/macOS scaffolding exists (`flutter create` generated all platforms) but are **not** launch targets — don't invest further there beyond what's already in place.

## Assets gathered this session

### Exercises — `assets/data/exercises.json` + `assets/images/exercises/`
- Full metadata for 873 exercises bundled (`exercises.json`, public domain / Unlicense, source: [free-exercise-db](https://github.com/yuhonas/free-exercise-db)).
- 21 recognizable staple movements have local images bundled (squat, deadlift, bench press, pull-up, push-up, plank, lunge, curls, etc. — see `exercises_curated.json` for the list). The other ~850 exercises have metadata only; fetch their images from `https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/{path}` at runtime via `cached_network_image` rather than bundling all of them (full image set is ~98MB — too big to ship in the app binary).

### Food — `assets/data/foods.json` + `assets/images/food/`
- 23 common diet-relevant whole foods (chicken breast, salmon, eggs, oats, rice, quinoa, vegetables, fruit, nuts, dairy, etc.) with real nutrition data (kcal/protein/carbs/fat per 100g) and product images, from [Open Food Facts](https://world.openfoodfacts.org/) (no API key needed).
- **License obligation**: ODbL (data) + CC-BY-SA (images) — both require visible attribution before shipping. See `assets/data/ASSET_ATTRIBUTION.md`.
- For food search beyond this seed set, hit `world.openfoodfacts.org/cgi/search.pl` live (send a descriptive User-Agent per their API etiquette) rather than pre-downloading their whole corpus.

### 3D gym equipment — `assets/images/3d/gym-equipment/`
Sourced via headless Playwright (installed to scratch dir, drives system Chrome) since itch.io's download flow is JS-gated: [Low Poly Gym Set](https://vnbp.itch.io/low-poly-gym-set) by VNB-Leo, **CC BY 4.0** (credit required, no resale). 72 FBX models — barbells, dumbbells, kettlebells, benches, pull-up bar/stand, pull-down machine, rowing machine, exercise bike, treadmills, weight plates, plus some non-gym decor props. Poly Pizza (needs API key) and Kenney (JS-gated, no gym-specific content anyway) were dead ends — this pack is the better source: bigger gym-specific selection, real license terms, actually free.

**Rendered and wired in** (2026-08-21): 21 pieces baked to 1024×1024 transparent PNGs in `assets/images/3d/gym-equipment/renders/` via headless Blender 5.2 (installed via `brew install --cask blender`), recolored to the app's orange accent for a consistent branded look, registered in `pubspec.yaml`. Use directly via `Image.asset('assets/images/3d/gym-equipment/renders/{Name}.png')`. Full technical breakdown (camera-fit math, material/lighting settings, which 51 FBX files are still unrendered) in `assets/data/ASSET_ATTRIBUTION.md`.

## Tech stack (already scaffolded)
- Flutter project `glacy_ui`, packages: `google_fonts`, `lottie`, `flutter_animate`, `cached_network_image`, `phosphor_flutter`.
- Theme: `lib/theme/app_colors.dart`, `lib/theme/app_theme.dart` (Sora headings / Inter body, dark + orange).
- Reusable glass widgets: `lib/widgets/glass_card.dart`, `lib/widgets/app_background.dart`.
- macOS target needed `com.apple.security.network.client` added to entitlements (App Sandbox blocks outbound network by default, which broke `google_fonts`' runtime font fetch) — already fixed in both `DebugProfile.entitlements` and `Release.entitlements`.
- Android device connected over Tailscale via `adb pair`/`adb connect`, now fixed to port 5555 (`adb connect 100.121.216.42:5555`) for reuse across sessions.
