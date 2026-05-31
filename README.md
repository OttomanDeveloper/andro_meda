# 🌌 Chronos — A Journey Through the History of the Universe

[![Live Demo](https://img.shields.io/badge/Live-Demo-brightgreen)](https://ottomandeveloper.github.io/andro_meda/)
[![Flutter](https://img.shields.io/badge/Built%20with-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**Chronos** is a scroll-driven, single-page experience that animates the entire
history of the cosmos — from the Big Bang to the present day and beyond — across
**nine hand-painted eras**, ending in a developer portfolio reveal. Every scene
is drawn with Flutter `CustomPainter`s and animated from a single ticker, so the
whole journey is pure Dart with no image-based animation.

It's a showcase of what Flutter can do for rich, interactive, fully responsive
storytelling on the web (and mobile, and desktop).

> 👉 **[Experience it live](https://ottomandeveloper.github.io/andro_meda/)**
>
> 💻 Best viewed on a **desktop browser** — the cursor-driven parallax and
> hover-to-reveal moments need a mouse, and the wide scenes have room to breathe.
> It stays fully responsive on tablet and phone, just without the pointer effects.

---

## 🎬 A Flutter animation showcase

Everything in the timeline is drawn and moved in pure Dart. No GIFs, videos,
Lottie files, or pre-rendered sprites, just `Canvas` calls running every frame.

- **More than 30 `CustomPainter`s** render every star, galaxy, planet, creature,
  and particle by hand.
- **One `Ticker`** drives all of it. It feeds a single `time` value through a
  `Provider`, and only the on-screen era listens, so dozens of scenes hold 60fps
  without dozens of `AnimationController`s.
- **Scroll is the timeline.** Page position maps to progress through each era,
  so you scrub 13.8 billion years by scrolling.
- **Procedural, not keyframed.** Flames flicker, galaxies wind, comets follow
  real conic-section orbits, and dinosaurs walk, all from math.

It is built to show how far Flutter's rendering and animation can go on the web.

## ✨ Features

- **Nine custom-painted eras** — Big Bang → Cosmic Dark Ages → First Stars →
  Galaxies → Solar System → Life Begins → Age of Giants → Rise of Humanity →
  The Future, then a portfolio reveal.
- **Scroll is the timeline** — your scroll position drives every animation and
  era transition; a tap-to-jump progress bar lets you skip around.
- **Hand-built scenes** — supernovae, colliding galaxies, orbiting planets and
  rogue comets, single-celled life, fighting dinosaurs, an ice-age mammoth hunt,
  a forest sabertooth ambush, a campfire that grows into a city skyline.
- **Interactive moments** — drag to spin galaxies, tap to ignite stars, tap (or
  hover) to reveal the dinosaur titans.
- **Fully responsive** — purpose-built mobile, tablet, and desktop behavior with
  touch-first interactions and width-aware layouts.
- **Performant by design** — one `Ticker` feeds a `Provider`; only the
  on-screen era subscribes to per-frame updates (visibility-gated via
  `EraScope`), and each era is wrapped in a `RepaintBoundary`.

## 🛠️ Tech Stack

| Area | Choice |
| --- | --- |
| Framework | [Flutter](https://flutter.dev) (Web, Android, iOS, desktop) |
| Language | Dart |
| State | [`provider`](https://pub.dev/packages/provider) — **no `setState`**, all state flows through `ChangeNotifier`s |
| Rendering | `CustomPainter` / `Canvas` for every scene |
| Fonts | [`google_fonts`](https://pub.dev/packages/google_fonts) |
| Links | [`url_launcher`](https://pub.dev/packages/url_launcher) |
| CI / Deploy | GitHub Actions → GitHub Pages |

## 🏗️ Architecture

The whole experience is one long `SingleChildScrollView`. Each era is a
`SizedBox` that is twice the viewport tall, so scrolling reveals a tall scene a
viewport at a time.

```
Ticker (JourneyPage)
  └─ AnimationProvider.time        // global clock, ticks every frame
ScrollController
  └─ ScrollProvider               // overall + per-era progress, current era
MouseRegion
  └─ CursorProvider               // pointer-driven parallax (desktop)

Each era:
  EraScope        // subscribes to time/cursor ONLY when its era is on-screen
    └─ EraWrapper // headline + description + background gradient + parallax
        └─ CustomPaint layers (StarField, Nebula, scene painters, InfoLabels…)
```

Key ideas worth reading the code for:

- **`EraScope`** (`lib/components/journey/era_scope.dart`) — visibility gating.
  Only the active era (and its neighbors) rebuilds per frame, so 9 animated
  scenes don't all run at once.
- **`EraWrapper`** (`lib/components/journey/era_wrapper.dart`) — shared title /
  description / entrance animation, with responsive scale factors.
- **`InfoLabelPainter`** (`lib/components/painters/info_label_painter.dart`) —
  shared floating epoch annotations that flip inward on narrow screens.

## 📁 Project Structure

Every `CustomPainter` lives in its own file under a `painters/` folder; widget
files never contain a painter.

```
lib/
├── main.dart                   # App entry — providers + JourneyPage
├── core/
│   ├── hooks/hooks.dart        # Barrel export used across the app
│   ├── provider/               # ScrollProvider, AnimationProvider, CursorProvider
│   └── utils/                  # AppSettings, AppColors, AppText, Responsive
├── pages/
│   ├── journey/
│   │   ├── journey_page.dart   # The scrolling journey scaffold
│   │   └── painters/           # CursorTrailPainter
│   ├── eras/                   # One widget per era (the nine scenes)
│   │   └── painters/           # One painter per file, per era scene (22 of them)
│   └── portfolio/              # Final developer reveal screen
├── layouts/                    # Per-breakpoint layouts (mobile/tablet/desktop)
└── components/
    ├── journey/                # ProgressBar, EraWrapper, EraScope
    ├── interactive/
    │   ├── *.dart              # StarIgniter, GalaxyRotator, CreatureRevealer
    │   └── painters/           # Their painters (galaxy spiral, titan dust, …)
    └── painters/               # Shared, reusable painters (StarField, Nebula, …)
```

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `3.27+` (Dart `3.12+`)
- A browser (Chrome recommended) for the web target

### Run it

```bash
# 1. Clone
git clone https://github.com/OttomanDeveloper/andro_meda.git
cd andro_meda

# 2. Install dependencies
flutter pub get

# 3. Run on the web
flutter run -d chrome
```

> On Flutter web, if CanvasKit fails to load from the CDN, run with
> `flutter run -d chrome --no-web-resources-cdn` to serve CanvasKit locally.

### Other targets

```bash
flutter run                 # any connected device / emulator
flutter build web --release
flutter build apk --release
```

## 🧪 Development

```bash
flutter analyze     # static analysis (must be clean)
dart format .       # formatting (CI checks this)
flutter test        # smoke tests
```

Please read **[CONTRIBUTING.md](CONTRIBUTING.md)** before opening a PR — it
covers the project conventions (notably: **state goes through Provider, never
`setState`**) and how scenes are built.

## 🤝 Contributing

Contributions are welcome! New eras, richer scenes, performance work, and
accessibility improvements are all great places to start. See
[CONTRIBUTING.md](CONTRIBUTING.md) to get started. Found a security issue?
Please follow the [Security Policy](SECURITY.md).

## 📄 License

Released under the [Creative Commons Attribution 4.0 International License
(CC BY 4.0)](LICENSE). You're free to use, share, and adapt this work — even
commercially — as long as you give appropriate credit to **Muhammad Usman**,
link to the license, and indicate any changes.

## 👤 Author

**Muhammad Usman** — Senior Flutter Developer

- GitHub: [@OttomanDeveloper](https://github.com/OttomanDeveloper)
- LinkedIn: [ottomancoder](https://www.linkedin.com/in/ottomancoder/)
- YouTube: [@OttomanCoder](https://www.youtube.com/@OttomanCoder)

If this project helped or inspired you, please consider giving it a ⭐.
