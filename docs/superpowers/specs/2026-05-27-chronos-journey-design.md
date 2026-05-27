# Chronos — A Journey Through Time

**Type:** Interactive scroll-driven storytelling experience (Flutter Web)
**Purpose:** Portfolio showcase piece — replaces the existing crypto landing page with an animation-rich, immersive web experience that demonstrates Flutter Web capabilities.

---

## Concept

An epic scroll-driven narrative through 13.8 billion years of cosmic history, from the Big Bang to the far future. The user scrolls and the story unfolds — animations, color shifts, text reveals, and interactive moments all tied to scroll position. The journey ends with a portfolio pivot: the cosmic experience gracefully reveals itself as a portfolio intro.

**Tone:** Balanced — awe and wonder backed by real scientific facts. Short poetic headlines paired with one mind-blowing paragraph per era.

**Aesthetic:** Cinematic Dark — deep blacks, subtle nebula glows, elegant white typography. The void is the canvas. Content emerges from darkness.

---

## The 9 Eras

| # | Era | Time | Visual Identity | Interactive |
|---|-----|------|-----------------|-------------|
| 1 | The Big Bang | 13.8B years ago | White-hot radial explosion from pure black | — |
| 2 | Cosmic Dark Ages | 13.5B years ago | Near-total darkness, faint hydrogen wisps | — |
| 3 | First Stars & Light | 13.2B years ago | Pinpricks of cool blue-white igniting | Tap to ignite stars |
| 4 | Galaxies Form | 10B years ago | Purple-blue spiral arms coalescing | Drag to rotate galaxy |
| 5 | Our Solar System | 4.6B years ago | Warm golden sun, orbital rings | — |
| 6 | Life Begins | 3.8B years ago | Organic greens/teals, cell-like forms | — |
| 7 | Age of Giants | 230M years ago | Earthy greens, misty silhouettes | Hover to reveal creatures |
| 8 | Rise of Humanity | 300K years ago | Warm amber firelight, civilization spark | — |
| 9 | The Future → Portfolio | Now → ∞ | Dark cosmos dissolves into light, portfolio reveal | Portfolio CTA |

### Color Temperature Arc

Cold white (Big Bang) → Total black (Dark Ages) → Cool blues (Stars/Galaxies) → Warm amber (Solar System/Humanity) → Light (Future/Portfolio)

Era 9 is the only era that breaks into light — the visual payoff of the entire journey.

### Per-Era Color Palettes

**Era 1 — The Big Bang:** `#ffffff`, `#ffcc00`, `#ff6600`, `#220000`, `#000000`
**Era 2 — Cosmic Dark Ages:** `#000000`, `#020208`, `#0a0a1a`, `#1a1030`
**Era 3 — First Stars:** `#050520`, `#0a0a30`, `#c8dcff`, `#ffffff`
**Era 4 — Galaxies:** `#0a1030`, `#150a30`, `#9678ff`, `#6496ff`
**Era 5 — Solar System:** `#050515`, `#1a1000`, `#ffcc44`, `#ff9900`
**Era 6 — Life Begins:** `#001a0a`, `#003a20`, `#00ff96`, `#00c8ff`
**Era 7 — Age of Giants:** `#1a2a15`, `#2a3a20`, `#96c864`, `#c8a050`
**Era 8 — Humanity:** `#1a0a00`, `#2a1500`, `#ff9932`, `#ffcc66`
**Era 9 — Future:** `#0a0a2e`, `#1a1a40`, `rgba(255,255,255,0.6)`, `#f0f0f0`

---

## Interaction Model

**Primary:** Scroll-driven. The user's scroll wheel IS the timeline. All animations, transitions, and text reveals are pure functions of scroll position.

**Interactive moments (3 eras):**
- **Era 3 — Star Igniter:** Tap/click on dark regions to ignite stars. Each tap blooms a new star with a glow animation.
- **Era 4 — Galaxy Rotator:** Drag/swipe to rotate a spiral galaxy. Rotation angle tracked via Provider.
- **Era 7 — Creature Revealer:** Hover (desktop) or tap (mobile) to reveal dinosaur silhouettes emerging from fog with scale comparisons.

**Navigation:** Thin progress bar at top showing overall journey completion + current era name with crossfade transitions. Clickable for quick navigation.

---

## Architecture

### Approach: ScrollController + per-era AnimationControllers

A single `ScrollController` on a `CustomScrollView` drives the entire journey. Each era is a full-viewport widget receiving a normalized `0.0 → 1.0` progress value. All visual changes are pure functions of this progress — no imperative animation triggers.

`CustomPainter` subclasses handle particle effects (stars, nebulae, cells, orbits). Painters repaint on progress changes via `shouldRepaint`, no widget rebuilds during scroll.

### State Management

**No `setState` anywhere.** All state flows through Provider:

- `ScrollProvider` (global) — scroll offset, current era index, per-era progress, era label
- `StarIgniterProvider` (scoped to Era 3) — which stars are lit
- `GalaxyRotatorProvider` (scoped to Era 4) — rotation angle
- `CreatureRevealerProvider` (scoped to Era 7) — which creatures are revealed

Scoped providers use `ChangeNotifierProvider` at the era widget subtree level.

### Project Structure

```
lib/
  main.dart
  core/
    hooks/
      hooks.dart               # Single barrel export
    provider/
      scroll_provider.dart     # Scroll state, era progress
    utils/
      app_color.dart           # abstract class AppColors — per-era palettes
      app_text.dart            # abstract class AppText — era content
      app_asset.dart           # abstract class AppAsset
      app_settings.dart        # abstract class AppSettings
      responsive.dart          # Responsive widget (mobile/tablet/desktop)
  pages/
    journey/
      journey_page.dart        # CustomScrollView assembling all eras
    eras/
      big_bang.dart
      dark_ages.dart
      first_stars.dart
      galaxies.dart
      solar_system.dart
      life_begins.dart
      age_of_giants.dart
      humanity.dart
      future.dart
    portfolio/
      portfolio_reveal.dart
  layouts/
    eras/
      desktop.dart
      tablet.dart
      mobile.dart
    portfolio/
      desktop.dart
      tablet.dart
      mobile.dart
  components/
    journey/
      progress_bar.dart        # Top bar + era label
      era_wrapper.dart         # Shared era scaffold
    interactive/
      star_igniter.dart
      galaxy_rotator.dart
      creature_revealer.dart
    painters/
      star_field_painter.dart
      nebula_painter.dart
      particle_painter.dart
      orbit_painter.dart
```

### Pattern Compliance

- `abstract class AppColors { const AppColors._(); ... }` with `static const Color` definitions
- `abstract class AppText { const AppText._(); ... }` with era titles, descriptions, facts
- `Responsive(mobile: ..., tablet: ..., desktop: ...)` for every section
- All sizing via `MediaQuery.sizeOf(context)` percentages — zero hardcoded pixels
- `Consumer<ScrollProvider>` for reactive scroll state
- Single `hooks.dart` barrel export for all imports
- `const` constructors everywhere
- `isMobile` / `isTablet` flags on components
- `GoogleFonts.russoOne` for era titles, `GoogleFonts.roboto` for body text

---

## Performance

- `CustomPainter` with `shouldRepaint` tied to progress changes only
- `RepaintBoundary` around each era to isolate paint regions
- No widget rebuilds during scroll — all visual changes in paint layer
- Lazy initialization of painters for off-screen eras
- Reduced particle density on mobile/tablet

---

## Responsive Behavior

- **Desktop (≥ 1100px):** Full visual experience, all interactive moments, hover effects on Era 7
- **Tablet (650–1100px):** Same journey, slightly simplified particle counts, touch interactions
- **Mobile (< 650px):** Touch-optimized interactions (tap replaces hover for Era 7), reduced particle density, adjusted typography scale

---

## Portfolio Pivot (Era 9)

The dark cosmos dissolves into light — the only era that transitions to a bright background. Text reads something like:

> "13.8 billion years of cosmic evolution. Stardust became atoms. Atoms became life. Life became conscious. And consciousness learned to create."
>
> "This experience was crafted by **Muhammad Usman**."

Followed by: portfolio links, social links, contact. Clean, minimal, light background — the visual contrast with the preceding 8 dark eras makes this section hit hard.

---

## Dependencies

**Keep:**
- `provider` — state management
- `flutter_svg` — SVG assets
- `google_fonts` — typography (Russo One + Roboto)
- `url_launcher` — portfolio external links

**Remove:**
- `scrollable_positioned_list` — replaced by `CustomScrollView` + `ScrollController`
- `cupertino_icons` — not needed for this design

**No new dependencies.** All animations, painters, and interactions built with Flutter SDK only.

---

## Content Per Era (Headlines + Facts)

Each era contains:
1. A **poetic headline** (large, cinematic typography)
2. A **timestamp** (small, letter-spaced, above headline)
3. One **paragraph** of mind-blowing scientific context (2-3 sentences max)

Example for Era 1:
- Timestamp: `13.8 BILLION YEARS AGO`
- Headline: `Everything Began`
- Fact: `In a fraction of a second, the universe expanded from smaller than an atom to larger than a galaxy. The temperature was 10 trillion degrees. Every particle of matter that would ever exist was created in this moment.`

Full content for all 9 eras will be written during implementation.
