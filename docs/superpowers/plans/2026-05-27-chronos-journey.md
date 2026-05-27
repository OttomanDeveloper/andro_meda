# Chronos — A Journey Through Time: Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the SafeAndromeda crypto landing page into an epic scroll-driven storytelling experience through 9 eras of cosmic history, ending with a portfolio reveal.

**Architecture:** Single `CustomScrollView` with `ScrollController` drives the entire journey. Each era is a full-viewport widget receiving a normalized 0.0→1.0 progress value from `ScrollProvider`. All visual effects use `CustomPainter` driven by progress — no `setState` anywhere. Interactive moments use scoped `ChangeNotifierProvider` per component.

**Tech Stack:** Flutter 3.44 (Web), Provider, CustomPainter, GoogleFonts, flutter_svg, url_launcher

---

## File Map

### Delete (old crypto site)
```
lib/pages/header/
lib/pages/info/
lib/pages/intro_token/
lib/pages/roadmap/
lib/pages/team/
lib/pages/bottom/
lib/pages/starter/
lib/layouts/header/
lib/layouts/team/
lib/layouts/info/
lib/components/header/
lib/components/team/
lib/components/info/
lib/components/social/
lib/components/pop_dialog.dart
lib/core/provider/nav_provider.dart
lib/core/utils/app_text.dart (rewrite)
lib/core/utils/app_color.dart (rewrite)
lib/core/utils/app_links.dart
lib/core/functions/url_opener.dart
```

### Create
```
lib/core/provider/scroll_provider.dart
lib/core/utils/app_color.dart (new content)
lib/core/utils/app_text.dart (new content)
lib/pages/journey/journey_page.dart
lib/pages/eras/big_bang.dart
lib/pages/eras/dark_ages.dart
lib/pages/eras/first_stars.dart
lib/pages/eras/galaxies.dart
lib/pages/eras/solar_system.dart
lib/pages/eras/life_begins.dart
lib/pages/eras/age_of_giants.dart
lib/pages/eras/humanity.dart
lib/pages/eras/future.dart
lib/pages/portfolio/portfolio_reveal.dart
lib/layouts/eras/desktop.dart
lib/layouts/eras/tablet.dart
lib/layouts/eras/mobile.dart
lib/layouts/portfolio/desktop.dart
lib/layouts/portfolio/tablet.dart
lib/layouts/portfolio/mobile.dart
lib/components/journey/progress_bar.dart
lib/components/journey/era_wrapper.dart
lib/components/interactive/star_igniter.dart
lib/components/interactive/galaxy_rotator.dart
lib/components/interactive/creature_revealer.dart
lib/components/painters/star_field_painter.dart
lib/components/painters/nebula_painter.dart
lib/components/painters/particle_painter.dart
lib/components/painters/orbit_painter.dart
```

### Keep (modify)
```
lib/main.dart — rewire providers, root widget
lib/core/hooks/hooks.dart — replace all exports
lib/core/utils/response.dart — keep as-is
lib/core/utils/app_settings.dart — update app name
lib/core/utils/app_asset.dart — keep, add new assets if needed
```

---

## Phase 1: Foundation — Strip Old, Build Core

**Goal:** Remove old crypto site code. Create new theme system, text content, scroll provider, and barrel exports. After this phase, the app boots with a black screen and `ScrollProvider` wired up.

### Step 1.1: Delete old page, layout, and component directories

Delete these directories and all files within them:

```
lib/pages/header/
lib/pages/info/
lib/pages/intro_token/
lib/pages/roadmap/
lib/pages/team/
lib/pages/bottom/
lib/pages/starter/
lib/layouts/header/
lib/layouts/team/
lib/layouts/info/
lib/components/header/
lib/components/team/
lib/components/info/
lib/components/social/
lib/components/pop_dialog.dart
lib/core/provider/nav_provider.dart
lib/core/utils/app_links.dart
lib/core/functions/url_opener.dart
```

- [ ] Delete all listed files and folders
- [ ] Verify `lib/core/utils/response.dart`, `lib/core/utils/app_asset.dart`, `lib/core/utils/app_settings.dart` still exist (these are kept)

### Step 1.2: Rewrite `lib/core/utils/app_color.dart`

Replace the entire file with per-era color palettes following the existing abstract class pattern:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

abstract class AppColors {
  const AppColors._();

  // Base
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color parent = Colors.transparent;

  // Progress bar
  static const Color progressBg = Color(0x33ffffff);
  static const Color progressFill = Color(0xaaffffff);
  static const Color eraLabelText = Color(0x99ffffff);

  // Era 1 — Big Bang
  static const Color bigBangCenter = Color(0xffffffff);
  static const Color bigBangMid = Color(0xffffcc00);
  static const Color bigBangOuter = Color(0xffff6600);
  static const Color bigBangEdge = Color(0xff220000);
  static const Color bigBangVoid = Color(0xff000000);

  // Era 2 — Cosmic Dark Ages
  static const Color darkAgesBg = Color(0xff000000);
  static const Color darkAgesDeep = Color(0xff020208);
  static const Color darkAgesWisp = Color(0xff0a0a1a);
  static const Color darkAgesHydrogen = Color(0xff1a1030);

  // Era 3 — First Stars
  static const Color firstStarsBg = Color(0xff050520);
  static const Color firstStarsDeep = Color(0xff0a0a30);
  static const Color firstStarsGlow = Color(0xffc8dcff);
  static const Color firstStarsBright = Color(0xffffffff);

  // Era 4 — Galaxies
  static const Color galaxiesBg = Color(0xff0a1030);
  static const Color galaxiesDeep = Color(0xff150a30);
  static const Color galaxiesArm = Color(0xff9678ff);
  static const Color galaxiesCore = Color(0xff6496ff);

  // Era 5 — Solar System
  static const Color solarBg = Color(0xff050515);
  static const Color solarDust = Color(0xff1a1000);
  static const Color solarSun = Color(0xffffcc44);
  static const Color solarFlare = Color(0xffff9900);

  // Era 6 — Life Begins
  static const Color lifeBg = Color(0xff001a0a);
  static const Color lifeDeep = Color(0xff003a20);
  static const Color lifeGreen = Color(0xff00ff96);
  static const Color lifeTeal = Color(0xff00c8ff);

  // Era 7 — Age of Giants
  static const Color giantsBg = Color(0xff1a2a15);
  static const Color giantsForest = Color(0xff2a3a20);
  static const Color giantsLeaf = Color(0xff96c864);
  static const Color giantsEarth = Color(0xffc8a050);

  // Era 8 — Humanity
  static const Color humanityBg = Color(0xff1a0a00);
  static const Color humanityDark = Color(0xff2a1500);
  static const Color humanityFire = Color(0xffff9932);
  static const Color humanityWarm = Color(0xffffcc66);

  // Era 9 — Future
  static const Color futureBg = Color(0xff0a0a2e);
  static const Color futureDeep = Color(0xff1a1a40);
  static const Color futureGlow = Color(0x99ffffff);
  static const Color futureLight = Color(0xfff0f0f0);

  // Portfolio
  static const Color portfolioBg = Color(0xfff0f0f0);
  static const Color portfolioText = Color(0xff1a1a2e);
  static const Color portfolioAccent = Color(0xff6496ff);
  static const Color portfolioSubtext = Color(0xff666680);
}
```

- [ ] Replace `lib/core/utils/app_color.dart` with the above content

### Step 1.3: Rewrite `lib/core/utils/app_text.dart`

Replace the entire file with era content:

```dart
abstract class AppText {
  const AppText._();

  // Era names (used by progress bar)
  static const List<String> eraNames = [
    'The Big Bang',
    'Cosmic Dark Ages',
    'First Stars & Light',
    'Galaxies Form',
    'Our Solar System',
    'Life Begins',
    'Age of Giants',
    'Rise of Humanity',
    'The Future',
  ];

  // Era timestamps
  static const List<String> eraTimestamps = [
    '13.8 BILLION YEARS AGO',
    '13.5 BILLION YEARS AGO',
    '13.2 BILLION YEARS AGO',
    '10 BILLION YEARS AGO',
    '4.6 BILLION YEARS AGO',
    '3.8 BILLION YEARS AGO',
    '230 MILLION YEARS AGO',
    '300,000 YEARS AGO',
    'NOW → ∞',
  ];

  // Era headlines
  static const List<String> eraHeadlines = [
    'Everything Began',
    'The Silent Cosmos',
    'Let There Be Light',
    'Islands of Stars',
    'Our Place in the Void',
    'Chemistry Became Biology',
    'Titans of the Earth',
    'The Spark of Consciousness',
    'What Comes Next?',
  ];

  // Era descriptions (1 mind-blowing paragraph each)
  static const List<String> eraDescriptions = [
    'In a fraction of a second, the universe expanded from smaller than an atom to larger than a galaxy. The temperature was 10 trillion degrees. Every particle of matter that would ever exist was created in this moment.',
    'For 200 million years, the universe was completely dark. No stars, no light — just an expanding fog of hydrogen and helium cooling in absolute silence. The longest night in history.',
    'Gravity pulled hydrogen clouds together until they ignited. The first stars were monsters — 1,000 times more massive than our sun, burning blue-white and dying in spectacular supernovae that forged every heavy element in your body.',
    'Billions of stars fell into gravitational dances, forming spiraling galaxies. The observable universe contains 2 trillion galaxies, each home to hundreds of billions of stars. We live in one called the Milky Way.',
    'A cloud of gas and dust collapsed into a spinning disk. At its center, our Sun ignited. The remaining debris became 8 planets, 200+ moons, and billions of asteroids — all orbiting in the same direction, a memory of that original spin.',
    'In warm shallow pools, simple molecules began copying themselves. Single cells appeared — the ancestor of every living thing. For 3 billion years, life was nothing but microbes. Then everything changed.',
    'Dinosaurs ruled for 165 million years — 800 times longer than humans have existed. A Tyrannosaurus stood 12 meters tall. An Argentinosaurus weighed 70 tonnes. They vanished in a single day when a 10km asteroid struck.',
    'A species learned to control fire, tell stories, and wonder about the stars. In 300,000 years we went from stone tools to quantum computers. We are the universe becoming aware of itself.',
    '13.8 billion years of cosmic evolution. Stardust became atoms. Atoms became life. Life became conscious. And consciousness learned to create.',
  ];

  // Portfolio section
  static const String portfolioIntro =
      'This experience was crafted by';
  static const String portfolioName = 'Muhammad Usman';
  static const String portfolioRole = 'Flutter Developer';
  static const String portfolioTagline =
      'Building experiences that inspire.';
}
```

- [ ] Replace `lib/core/utils/app_text.dart` with the above content

### Step 1.4: Update `lib/core/utils/app_settings.dart`

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

abstract class AppSettings {
  const AppSettings._();

  static const String appName = 'Chronos';
  static const String shortName = 'Chronos';
  static const int eraCount = 9;
  static const double eraHeightFactor = 1.5;
}
```

- [ ] Replace `lib/core/utils/app_settings.dart` with the above content. `eraHeightFactor` is how many viewport heights each era occupies (1.5 = user scrolls 1.5 screens per era for smooth pacing)

### Step 1.5: Create `lib/core/provider/scroll_provider.dart`

This is the heart of the app — replaces `NavProvider`. Follows the same pattern: `ChangeNotifier`, private fields, public getters, `notifyListeners()`.

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class ScrollProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _currentEra = 0;
  int get currentEra => _currentEra;

  double _overallProgress = 0.0;
  double get overallProgress => _overallProgress;

  double _eraProgress = 0.0;
  double get eraProgress => _eraProgress;

  String get eraLabel => AppText.eraNames[_currentEra];

  double _viewportHeight = 0.0;

  void initScroll(double viewportHeight) {
    _viewportHeight = viewportHeight;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    final double totalHeight = eraHeight * AppSettings.eraCount;

    _overallProgress = (offset / totalHeight).clamp(0.0, 1.0);

    final int newEra = (offset / eraHeight).floor().clamp(0, AppSettings.eraCount - 1);
    _eraProgress = ((offset - (newEra * eraHeight)) / eraHeight).clamp(0.0, 1.0);

    if (newEra != _currentEra) {
      _currentEra = newEra;
    }

    notifyListeners();
  }

  double eraProgressFor(int eraIndex) {
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    final double eraStart = eraIndex * eraHeight;
    final double offset = _scrollController.offset;
    return ((offset - eraStart) / eraHeight).clamp(0.0, 1.0);
  }

  void jumpToEra(int eraIndex) {
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    _scrollController.animateTo(
      eraIndex * eraHeight,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
```

- [ ] Create `lib/core/provider/scroll_provider.dart` with the above content
- [ ] `_onScroll` calculates: which era is active (`_currentEra`), local progress within that era (`_eraProgress`), and overall journey progress (`_overallProgress`)
- [ ] `eraProgressFor(int)` lets individual era widgets query their own progress without storing it
- [ ] `jumpToEra(int)` is called by the progress bar for click-to-navigate

### Step 1.6: Rewrite `lib/core/hooks/hooks.dart`

Replace all exports with the new file structure. This is the single barrel import for the entire app:

```dart
// Core utilities
export 'package:safeandromeda/core/utils/app_settings.dart';
export 'package:safeandromeda/core/utils/app_color.dart';
export 'package:safeandromeda/core/utils/app_text.dart';
export 'package:safeandromeda/core/utils/app_asset.dart';
export 'package:safeandromeda/core/utils/response.dart';

// Providers
export 'package:safeandromeda/core/provider/scroll_provider.dart';

// Pages
export 'package:safeandromeda/pages/journey/journey_page.dart';
export 'package:safeandromeda/pages/eras/big_bang.dart';
export 'package:safeandromeda/pages/eras/dark_ages.dart';
export 'package:safeandromeda/pages/eras/first_stars.dart';
export 'package:safeandromeda/pages/eras/galaxies.dart';
export 'package:safeandromeda/pages/eras/solar_system.dart';
export 'package:safeandromeda/pages/eras/life_begins.dart';
export 'package:safeandromeda/pages/eras/age_of_giants.dart';
export 'package:safeandromeda/pages/eras/humanity.dart';
export 'package:safeandromeda/pages/eras/future.dart';
export 'package:safeandromeda/pages/portfolio/portfolio_reveal.dart';

// Layouts
export 'package:safeandromeda/layouts/eras/desktop.dart';
export 'package:safeandromeda/layouts/eras/tablet.dart';
export 'package:safeandromeda/layouts/eras/mobile.dart';
export 'package:safeandromeda/layouts/portfolio/desktop.dart';
export 'package:safeandromeda/layouts/portfolio/tablet.dart';
export 'package:safeandromeda/layouts/portfolio/mobile.dart';

// Components
export 'package:safeandromeda/components/journey/progress_bar.dart';
export 'package:safeandromeda/components/journey/era_wrapper.dart';
export 'package:safeandromeda/components/interactive/star_igniter.dart';
export 'package:safeandromeda/components/interactive/galaxy_rotator.dart';
export 'package:safeandromeda/components/interactive/creature_revealer.dart';
export 'package:safeandromeda/components/painters/star_field_painter.dart';
export 'package:safeandromeda/components/painters/nebula_painter.dart';
export 'package:safeandromeda/components/painters/particle_painter.dart';
export 'package:safeandromeda/components/painters/orbit_painter.dart';

// Packages
export 'dart:async';
export 'dart:math';
export 'package:flutter/material.dart';
export 'package:provider/provider.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:url_launcher/url_launcher.dart';
```

- [ ] Replace `lib/core/hooks/hooks.dart` with the above content
- [ ] Note: remove `dart:convert`, `package:flutter/services.dart`, `package:scrollable_positioned_list`, `safeandromeda/main.dart` — no longer needed

### Step 1.7: Create placeholder era files

Create all 9 era files + portfolio as minimal `StatelessWidget` stubs. Each returns a `SizedBox` for now. This lets hooks.dart compile.

For each file below, use this template (replace class name and era index):

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class BigBangEra extends StatelessWidget {
  const BigBangEra({super.key});

  static const int eraIndex = 0;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
```

Create these files with matching class names and `eraIndex` values:

| File | Class | eraIndex |
|------|-------|----------|
| `lib/pages/eras/big_bang.dart` | `BigBangEra` | 0 |
| `lib/pages/eras/dark_ages.dart` | `DarkAgesEra` | 1 |
| `lib/pages/eras/first_stars.dart` | `FirstStarsEra` | 2 |
| `lib/pages/eras/galaxies.dart` | `GalaxiesEra` | 3 |
| `lib/pages/eras/solar_system.dart` | `SolarSystemEra` | 4 |
| `lib/pages/eras/life_begins.dart` | `LifeBeginsEra` | 5 |
| `lib/pages/eras/age_of_giants.dart` | `AgeOfGiantsEra` | 6 |
| `lib/pages/eras/humanity.dart` | `HumanityEra` | 7 |
| `lib/pages/eras/future.dart` | `FutureEra` | 8 |
| `lib/pages/portfolio/portfolio_reveal.dart` | `PortfolioReveal` | — |

- [ ] Create all 10 stub files using the template above

### Step 1.8: Create placeholder component and layout files

Create stubs for all component and layout files so hooks.dart compiles. Use the same `StatelessWidget` + `SizedBox` template pattern.

**Components** (create each as `StatelessWidget` returning `const SizedBox()`):

| File | Class |
|------|-------|
| `lib/components/journey/progress_bar.dart` | `ProgressBar` |
| `lib/components/journey/era_wrapper.dart` | `EraWrapper` |
| `lib/components/interactive/star_igniter.dart` | `StarIgniter` |
| `lib/components/interactive/galaxy_rotator.dart` | `GalaxyRotator` |
| `lib/components/interactive/creature_revealer.dart` | `CreatureRevealer` |

**Painters** (create each as empty `CustomPainter` returning immediately from `paint`):

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class StarFieldPainter extends CustomPainter {
  const StarFieldPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
```

| File | Class |
|------|-------|
| `lib/components/painters/star_field_painter.dart` | `StarFieldPainter` |
| `lib/components/painters/nebula_painter.dart` | `NebulaPainter` |
| `lib/components/painters/particle_painter.dart` | `ParticlePainter` |
| `lib/components/painters/orbit_painter.dart` | `OrbitPainter` |

**Layouts** (create each as `StatelessWidget` returning `const SizedBox()`):

| File | Class |
|------|-------|
| `lib/layouts/eras/desktop.dart` | `EraDesktopLayout` |
| `lib/layouts/eras/tablet.dart` | `EraTabletLayout` |
| `lib/layouts/eras/mobile.dart` | `EraMobileLayout` |
| `lib/layouts/portfolio/desktop.dart` | `PortfolioDesktopLayout` |
| `lib/layouts/portfolio/tablet.dart` | `PortfolioTabletLayout` |
| `lib/layouts/portfolio/mobile.dart` | `PortfolioMobileLayout` |

- [ ] Create all 15 stub files

### Step 1.9: Rewrite `lib/main.dart`

Wire the new `ScrollProvider` and `JourneyPage` into the app root. Follows the existing pattern — `MultiProvider` at root, `MaterialApp` inside the page widget:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ScrollProvider())],
    child: const JourneyPage(),
  ));
}
```

- [ ] Replace `lib/main.dart` with the above content

### Step 1.10: Create `lib/pages/journey/journey_page.dart` (minimal shell)

This is the equivalent of `starter_page.dart`. Creates the `MaterialApp`, `Scaffold`, and `CustomScrollView`. For now, eras are placeholder stubs:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ScrollProvider provider = context.read<ScrollProvider>();
    provider.initScroll(size.height);

    return MaterialApp(
      title: AppSettings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: AppColors.parent),
      home: Scaffold(
        backgroundColor: AppColors.bigBangVoid,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: provider.scrollController,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const BigBangEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const DarkAgesEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const FirstStarsEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const GalaxiesEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const SolarSystemEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const LifeBeginsEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const AgeOfGiantsEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const HumanityEra(),
                  ),
                  SizedBox(
                    height: size.height * AppSettings.eraHeightFactor,
                    child: const FutureEra(),
                  ),
                  SizedBox(
                    height: size.height,
                    child: const PortfolioReveal(),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ProgressBar(),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] Create `lib/pages/journey/journey_page.dart` with the above content
- [ ] Run `flutter analyze` — should pass with zero errors
- [ ] Run `flutter build web` — should compile and show a black screen
- [ ] Commit: `"feat: phase 1 — foundation, providers, theme, era stubs"`

---

## Phase 2: Scroll Engine & Era Framework

**Goal:** Build the `EraWrapper` component, `ProgressBar`, and painter base classes. After this phase, scrolling shows 9 black sections with era text fading in/out and the progress bar tracking position.

### Step 2.1: Implement `EraWrapper` — `lib/components/journey/era_wrapper.dart`

This is the shared scaffold for every era. It receives `eraIndex`, reads `ScrollProvider` for progress, and renders background color + text content with parallax and opacity driven by progress.

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class EraWrapper extends StatelessWidget {
  const EraWrapper({
    super.key,
    required this.eraIndex,
    required this.child,
    this.backgroundColor = AppColors.black,
  });

  final int eraIndex;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        final double textOpacity = _textOpacity(progress);
        final double parallaxOffset = _parallaxOffset(progress, size.height);

        return Container(
          width: size.width,
          height: size.height * AppSettings.eraHeightFactor,
          color: backgroundColor,
          child: Stack(
            children: [
              Positioned.fill(child: child),
              Positioned(
                left: 0,
                right: 0,
                top: (size.height * 0.3) + parallaxOffset,
                child: Opacity(
                  opacity: textOpacity,
                  child: _EraTextContent(
                    eraIndex: eraIndex,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _textOpacity(double progress) {
    if (progress < 0.15) return (progress / 0.15).clamp(0.0, 1.0);
    if (progress > 0.75) return ((1.0 - progress) / 0.25).clamp(0.0, 1.0);
    return 1.0;
  }

  double _parallaxOffset(double progress, double viewportHeight) {
    return (progress - 0.5) * viewportHeight * -0.15;
  }
}

class _EraTextContent extends StatelessWidget {
  const _EraTextContent({required this.eraIndex});

  final int eraIndex;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppText.eraTimestamps[eraIndex],
            style: GoogleFonts.roboto(
              color: AppColors.white.withValues(alpha: 0.4),
              fontSize: size.height * 0.014,
              letterSpacing: 6,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            AppText.eraHeadlines[eraIndex],
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.05,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          SizedBox(
            width: size.width * 0.5,
            child: Text(
              AppText.eraDescriptions[eraIndex],
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: size.height * 0.018,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] Replace `lib/components/journey/era_wrapper.dart` with the above content
- [ ] `_textOpacity`: fades in during 0→0.15 progress, full at 0.15→0.75, fades out 0.75→1.0
- [ ] `_parallaxOffset`: text moves slower than scroll for depth illusion

### Step 2.2: Implement `ProgressBar` — `lib/components/journey/progress_bar.dart`

Thin bar at top with era label. Reads from `ScrollProvider` via `Consumer`:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        return Container(
          width: size.width,
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.015,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppSettings.appName.toUpperCase(),
                    style: GoogleFonts.russoOne(
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontSize: size.height * 0.014,
                      letterSpacing: 4,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      pro.eraLabel,
                      key: ValueKey<int>(pro.currentEra),
                      style: GoogleFonts.roboto(
                        color: AppColors.eraLabelText,
                        fontSize: size.height * 0.014,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.008),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final double tapFraction =
                      details.localPosition.dx / size.width;
                  final int targetEra =
                      (tapFraction * AppSettings.eraCount)
                          .floor()
                          .clamp(0, AppSettings.eraCount - 1);
                  pro.jumpToEra(targetEra);
                },
                child: Container(
                  width: size.width,
                  height: size.height * 0.003,
                  decoration: BoxDecoration(
                    color: AppColors.progressBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: pro.overallProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.progressFill,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/components/journey/progress_bar.dart` with the above content
- [ ] `AnimatedSwitcher` crossfades the era label when `currentEra` changes
- [ ] `GestureDetector` on the bar enables tap-to-navigate via `jumpToEra`

### Step 2.3: Implement `StarFieldPainter` — `lib/components/painters/star_field_painter.dart`

The most reused painter — renders a field of stars with parallax. Stars are generated deterministically from a seed so they're stable across repaints:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class StarFieldPainter extends CustomPainter {
  const StarFieldPainter({
    required this.progress,
    this.starCount = 120,
    this.baseColor = AppColors.white,
    this.seed = 42,
    this.maxOpacity = 1.0,
  });

  final double progress;
  final int starCount;
  final Color baseColor;
  final int seed;
  final double maxOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(seed);
    final Paint paint = Paint();

    for (int i = 0; i < starCount; i++) {
      final double x = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double starSize = random.nextDouble() * 2.0 + 0.5;
      final double depth = random.nextDouble();

      final double parallax = progress * size.height * 0.1 * depth;
      final double y = baseY - parallax;

      if (y < -10 || y > size.height + 10) continue;

      final double twinkle =
          (0.5 + 0.5 * ((i * 0.7 + progress * 3.0) % 1.0)).clamp(0.3, 1.0);
      final double opacity = (twinkle * maxOpacity).clamp(0.0, 1.0);

      paint.color = baseColor.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), starSize, paint);

      if (starSize > 1.5) {
        paint.color = baseColor.withValues(alpha: opacity * 0.3);
        canvas.drawCircle(Offset(x, y), starSize * 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
```

- [ ] Replace `lib/components/painters/star_field_painter.dart` with the above content

### Step 2.4: Implement `NebulaPainter` — `lib/components/painters/nebula_painter.dart`

Renders soft nebula glow clouds. Used in multiple eras with different colors:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class NebulaPainter extends CustomPainter {
  const NebulaPainter({
    required this.progress,
    required this.clouds,
  });

  final double progress;
  final List<NebulaCloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    for (final NebulaCloud cloud in clouds) {
      final double drift = progress * size.width * cloud.driftSpeed;
      final Offset center = Offset(
        cloud.x * size.width + drift,
        cloud.y * size.height,
      );

      final double opacity = (cloud.opacity * (0.7 + 0.3 * progress)).clamp(0.0, 1.0);

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            cloud.color.withValues(alpha: opacity),
            cloud.color.withValues(alpha: opacity * 0.3),
            cloud.color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(
          Rect.fromCenter(
            center: center,
            width: cloud.radius * size.width * 2,
            height: cloud.radius * size.height * 2,
          ),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: cloud.radius * size.width * 2,
          height: cloud.radius * size.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NebulaPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class NebulaCloud {
  const NebulaCloud({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    this.opacity = 0.3,
    this.driftSpeed = 0.05,
  });

  final double x;
  final double y;
  final double radius;
  final Color color;
  final double opacity;
  final double driftSpeed;
}
```

- [ ] Replace `lib/components/painters/nebula_painter.dart` with the above content
- [ ] `NebulaCloud` defines position (0.0–1.0 fractions of size), radius, color, drift speed

### Step 2.5: Implement `ParticlePainter` — `lib/components/painters/particle_painter.dart`

Generic particle system used for the Big Bang burst, cellular forms, etc.:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class ParticlePainter extends CustomPainter {
  const ParticlePainter({
    required this.progress,
    required this.particles,
  });

  final double progress;
  final List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (final Particle p in particles) {
      final double life = (progress - p.birthProgress).clamp(0.0, 1.0);
      if (life <= 0.0) continue;

      final double x = size.width * p.startX +
          (p.velocityX * size.width * life);
      final double y = size.height * p.startY +
          (p.velocityY * size.height * life);

      if (x < -20 || x > size.width + 20 || y < -20 || y > size.height + 20) {
        continue;
      }

      final double fadeIn = (life / 0.1).clamp(0.0, 1.0);
      final double fadeOut = life > 0.8 ? ((1.0 - life) / 0.2).clamp(0.0, 1.0) : 1.0;
      final double opacity = (fadeIn * fadeOut * p.opacity).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), p.size * (0.5 + life * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class Particle {
  const Particle({
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.color,
    this.size = 1.5,
    this.opacity = 1.0,
    this.birthProgress = 0.0,
  });

  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final Color color;
  final double size;
  final double opacity;
  final double birthProgress;
}
```

- [ ] Replace `lib/components/painters/particle_painter.dart` with the above content
- [ ] `birthProgress` controls when a particle appears relative to scroll progress
- [ ] Particles fade in over first 10% of their life, fade out over last 20%

### Step 2.6: Implement `OrbitPainter` — `lib/components/painters/orbit_painter.dart`

Draws orbital rings and orbiting bodies. Used for Solar System era:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class OrbitPainter extends CustomPainter {
  const OrbitPainter({
    required this.progress,
    required this.orbits,
    required this.centerColor,
    required this.centerRadius,
  });

  final double progress;
  final List<OrbitRing> orbits;
  final Color centerColor;
  final double centerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.35, size.height * 0.45);

    final Paint sunPaint = Paint()..color = centerColor;
    canvas.drawCircle(center, centerRadius, sunPaint);

    final Paint glowPaint = Paint()
      ..color = centerColor.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, centerRadius * 3, glowPaint);

    final double drawProgress = progress.clamp(0.0, 1.0);

    for (int i = 0; i < orbits.length; i++) {
      final OrbitRing orbit = orbits[i];
      final double orbitAppear = (i / orbits.length) * 0.5;
      final double localProgress =
          ((drawProgress - orbitAppear) / 0.5).clamp(0.0, 1.0);

      if (localProgress <= 0.0) continue;

      final Paint ringPaint = Paint()
        ..color = AppColors.white.withValues(alpha: 0.06 * localProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: orbit.radiusX * size.width * 2,
          height: orbit.radiusY * size.height * 2,
        ),
        ringPaint,
      );

      final double angle = progress * orbit.speed * 3.14159 * 2;
      final double px = center.dx + orbit.radiusX * size.width * cos(angle);
      final double py = center.dy + orbit.radiusY * size.height * sin(angle);

      final Paint planetPaint = Paint()..color = orbit.planetColor;
      canvas.drawCircle(
        Offset(px, py),
        orbit.planetSize * localProgress,
        planetPaint,
      );
    }
  }

  double cos(double radians) => _cos(radians);
  double sin(double radians) => _sin(radians);

  static double _cos(double r) {
    return r.isNaN ? 0 : (r % (3.14159 * 2) < 3.14159 ? -1.0 : 1.0) *
        (1 - (((r % 3.14159) - 1.5708) * ((r % 3.14159) - 1.5708)) / 2);
  }

  static double _sin(double r) => _cos(r - 1.5708);

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class OrbitRing {
  const OrbitRing({
    required this.radiusX,
    required this.radiusY,
    required this.planetColor,
    required this.planetSize,
    this.speed = 1.0,
  });

  final double radiusX;
  final double radiusY;
  final Color planetColor;
  final double planetSize;
  final double speed;
}
```

- [ ] Replace `lib/components/painters/orbit_painter.dart` with the above content
- [ ] Note: uses approximate trig to avoid `dart:math` import conflicts with the barrel export. Replace `cos`/`sin` with `import 'dart:math' show cos, sin;` if `dart:math` is already in hooks.dart (it is — added in Step 1.6)

### Step 2.7: Fix `OrbitPainter` to use `dart:math` properly

Since `dart:math` is exported via hooks.dart, replace the approximate trig with real `dart:math`:

In `lib/components/painters/orbit_painter.dart`, remove the `cos`, `sin`, `_cos`, `_sin` methods and use `dart:math` directly:

```dart
      final double angle = progress * orbit.speed * pi * 2;
      final double px = center.dx + orbit.radiusX * size.width * cos(angle);
      final double py = center.dy + orbit.radiusY * size.height * sin(angle);
```

Where `pi`, `cos`, `sin` come from `dart:math` already exported in hooks.

- [ ] Update `OrbitPainter` to use `dart:math` `pi`, `cos`, `sin` (remove the 4 approximate methods)

### Step 2.8: Wire `BigBangEra` with `EraWrapper` as proof of concept

Update `lib/pages/eras/big_bang.dart` to use `EraWrapper` + `ParticlePainter`. This validates the full scroll→progress→paint pipeline:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class BigBangEra extends StatelessWidget {
  const BigBangEra({super.key});

  static const int eraIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.bigBangVoid,
          child: CustomPaint(
            painter: ParticlePainter(
              progress: progress,
              particles: _bigBangParticles,
            ),
          ),
        );
      },
    );
  }

  static final List<Particle> _bigBangParticles = List<Particle>.generate(
    80,
    (int i) {
      final Random r = Random(i);
      final double angle = r.nextDouble() * pi * 2;
      final double speed = 0.1 + r.nextDouble() * 0.4;
      return Particle(
        startX: 0.5,
        startY: 0.4,
        velocityX: cos(angle) * speed,
        velocityY: sin(angle) * speed,
        color: Color.lerp(
          AppColors.bigBangCenter,
          AppColors.bigBangOuter,
          r.nextDouble(),
        )!,
        size: 1.0 + r.nextDouble() * 2.5,
        birthProgress: r.nextDouble() * 0.3,
      );
    },
  );
}
```

- [ ] Replace `lib/pages/eras/big_bang.dart` with the above content
- [ ] Run `flutter build web` — verify it compiles
- [ ] Open in browser — scroll should show particles bursting from center in Era 1

### Step 2.9: Verify the full scroll pipeline works end-to-end

- [ ] Run `flutter run -d chrome`
- [ ] Verify: scrolling shows Big Bang particles animating
- [ ] Verify: progress bar at top updates fill and era label crossfades
- [ ] Verify: tap on progress bar jumps to different positions
- [ ] Verify: era text (timestamp, headline, description) fades in/out with parallax

### Step 2.10: Commit Phase 2

- [ ] Run `flutter analyze` — zero errors
- [ ] Commit: `"feat: phase 2 — scroll engine, era wrapper, progress bar, painters"`

---

## Phase 3: Eras 1–4 — Cosmic Origins

**Goal:** Implement the first 4 eras with full visual effects. Big Bang (particle burst), Dark Ages (near-blackness), First Stars (star field igniting), Galaxies (spiral painter).

### Step 3.1: Enhance `BigBangEra` with radial gradient background

Update `lib/pages/eras/big_bang.dart` — add a radial gradient background behind particles that expands with progress:

In the `EraWrapper.child`, wrap the `CustomPaint` in a `Stack` with a gradient container:

```dart
child: Stack(
  children: [
    Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.1 + progress * 1.5,
            colors: [
              AppColors.bigBangCenter.withValues(alpha: (1.0 - progress).clamp(0.0, 0.8)),
              AppColors.bigBangMid.withValues(alpha: (0.6 - progress * 0.6).clamp(0.0, 0.6)),
              AppColors.bigBangOuter.withValues(alpha: (0.3 - progress * 0.3).clamp(0.0, 0.3)),
              AppColors.bigBangVoid,
            ],
            stops: const [0.0, 0.2, 0.5, 1.0],
          ),
        ),
      ),
    ),
    Positioned.fill(
      child: CustomPaint(
        painter: ParticlePainter(
          progress: progress,
          particles: _bigBangParticles,
        ),
      ),
    ),
  ],
),
```

- [ ] Update `lib/pages/eras/big_bang.dart` to add the radial gradient expanding from center
- [ ] The gradient radius grows with progress (starts tiny, expands as user scrolls — the Big Bang expanding)

### Step 3.2: Implement `DarkAgesEra` — `lib/pages/eras/dark_ages.dart`

The darkest era. Nearly pure black with barely visible hydrogen wisps:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class DarkAgesEra extends StatelessWidget {
  const DarkAgesEra({super.key});

  static const int eraIndex = 1;

  static const List<NebulaCloud> _wisps = [
    NebulaCloud(x: 0.3, y: 0.4, radius: 0.15, color: AppColors.darkAgesHydrogen, opacity: 0.08, driftSpeed: 0.02),
    NebulaCloud(x: 0.6, y: 0.6, radius: 0.12, color: AppColors.darkAgesWisp, opacity: 0.05, driftSpeed: -0.015),
    NebulaCloud(x: 0.8, y: 0.3, radius: 0.1, color: AppColors.darkAgesHydrogen, opacity: 0.06, driftSpeed: 0.01),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.darkAgesBg,
          child: CustomPaint(
            painter: NebulaPainter(
              progress: progress,
              clouds: _wisps,
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/dark_ages.dart` with the above content
- [ ] The wisps are extremely subtle — opacity 0.05–0.08. This era should feel oppressively dark.

### Step 3.3: Implement `FirstStarsEra` — `lib/pages/eras/first_stars.dart`

Stars ignite as the user scrolls. The star field starts dark and progressively lights up:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class FirstStarsEra extends StatelessWidget {
  const FirstStarsEra({super.key});

  static const int eraIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.firstStarsBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.firstStarsBg,
                        AppColors.firstStarsDeep,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(
                    progress: progress,
                    starCount: 150,
                    baseColor: AppColors.firstStarsGlow,
                    maxOpacity: progress.clamp(0.0, 1.0),
                    seed: 77,
                  ),
                ),
              ),
              Positioned.fill(
                child: StarIgniter(eraProgress: progress),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/first_stars.dart` with the above content
- [ ] `maxOpacity: progress` makes stars gradually appear as user scrolls — light emerging from the dark ages
- [ ] `StarIgniter` overlay handles the tap-to-ignite interaction (implemented in Phase 5)

### Step 3.4: Implement `GalaxiesEra` — `lib/pages/eras/galaxies.dart`

Spiral galaxy forming from nebula clouds. Uses `NebulaPainter` for the galactic haze and `GalaxyRotator` for the interactive element:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class GalaxiesEra extends StatelessWidget {
  const GalaxiesEra({super.key});

  static const int eraIndex = 3;

  static const List<NebulaCloud> _galacticClouds = [
    NebulaCloud(x: 0.5, y: 0.4, radius: 0.25, color: AppColors.galaxiesArm, opacity: 0.2, driftSpeed: 0.03),
    NebulaCloud(x: 0.45, y: 0.45, radius: 0.18, color: AppColors.galaxiesCore, opacity: 0.15, driftSpeed: -0.02),
    NebulaCloud(x: 0.55, y: 0.35, radius: 0.2, color: AppColors.galaxiesArm, opacity: 0.12, driftSpeed: 0.025),
    NebulaCloud(x: 0.4, y: 0.5, radius: 0.15, color: AppColors.galaxiesDeep, opacity: 0.1, driftSpeed: -0.01),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.galaxiesBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(
                    progress: progress,
                    starCount: 200,
                    baseColor: AppColors.white,
                    maxOpacity: 0.6,
                    seed: 123,
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(
                    progress: progress,
                    clouds: _galacticClouds,
                  ),
                ),
              ),
              Positioned.fill(
                child: GalaxyRotator(eraProgress: progress),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/galaxies.dart` with the above content

### Step 3.5: Implement `SolarSystemEra` — `lib/pages/eras/solar_system.dart`

Warm golden sun with orbital rings drawing themselves into place:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class SolarSystemEra extends StatelessWidget {
  const SolarSystemEra({super.key});

  static const int eraIndex = 4;

  static const List<OrbitRing> _orbits = [
    OrbitRing(radiusX: 0.06, radiusY: 0.04, planetColor: Color(0xffaa8866), planetSize: 3, speed: 4.0),
    OrbitRing(radiusX: 0.1, radiusY: 0.065, planetColor: Color(0xffeebb66), planetSize: 4, speed: 2.5),
    OrbitRing(radiusX: 0.15, radiusY: 0.1, planetColor: Color(0xff4488cc), planetSize: 5, speed: 1.8),
    OrbitRing(radiusX: 0.19, radiusY: 0.13, planetColor: Color(0xffcc4422), planetSize: 4, speed: 1.2),
    OrbitRing(radiusX: 0.27, radiusY: 0.18, planetColor: Color(0xffddaa66), planetSize: 8, speed: 0.6),
    OrbitRing(radiusX: 0.34, radiusY: 0.22, planetColor: Color(0xffccbb88), planetSize: 7, speed: 0.4),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.solarBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(
                    progress: progress,
                    starCount: 80,
                    baseColor: AppColors.white,
                    maxOpacity: 0.3,
                    seed: 456,
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: OrbitPainter(
                    progress: progress,
                    orbits: _orbits,
                    centerColor: AppColors.solarSun,
                    centerRadius: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/solar_system.dart` with the above content

### Step 3.6: Verify Eras 1–5 render correctly

- [ ] Run `flutter run -d chrome`
- [ ] Scroll through Eras 1–5 and verify: Big Bang particles + gradient, Dark Ages blackness, First Stars lighting up, Galaxies nebula, Solar System orbits
- [ ] Verify text content (timestamps, headlines, descriptions) appears and fades correctly in each era

### Step 3.7: Tune transition smoothness between Eras 1–5

Adjust background color blending. In `journey_page.dart`, each era's `SizedBox` container should interpolate its background toward the next era. Update `EraWrapper` to accept `nextBackgroundColor`:

Add parameter to `EraWrapper`:

```dart
final Color nextBackgroundColor;
```

In `EraWrapper.build`, change the `Container.color` to a lerped gradient:

```dart
decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundColor,
      Color.lerp(backgroundColor, nextBackgroundColor, progress) ?? backgroundColor,
    ],
  ),
),
```

- [ ] Add `nextBackgroundColor` parameter to `EraWrapper` (required, no default)
- [ ] Update the `Container` to use `LinearGradient` blending toward the next era's color
- [ ] Update all era files to pass `nextBackgroundColor` (e.g., BigBang passes `AppColors.darkAgesBg`, DarkAges passes `AppColors.firstStarsBg`, etc.)

### Step 3.8: Add `RepaintBoundary` around each era in `journey_page.dart`

Wrap each era's `SizedBox` in `RepaintBoundary` for paint isolation:

```dart
RepaintBoundary(
  child: SizedBox(
    height: size.height * AppSettings.eraHeightFactor,
    child: const BigBangEra(),
  ),
),
```

- [ ] Wrap all 9 eras + portfolio in `RepaintBoundary` in `journey_page.dart`

### Step 3.9: Add scroll indicator to Era 1

A subtle "SCROLL TO EXPLORE" text with a small animated chevron at the bottom of the first viewport. This goes inside `BigBangEra`'s `Stack`, positioned at bottom center:

```dart
Positioned(
  bottom: size.height * 0.08,
  left: 0,
  right: 0,
  child: Opacity(
    opacity: (1.0 - progress * 4).clamp(0.0, 1.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SCROLL TO EXPLORE',
          style: GoogleFonts.roboto(
            color: AppColors.white.withValues(alpha: 0.35),
            fontSize: size.height * 0.012,
            letterSpacing: 4,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.white.withValues(alpha: 0.25),
          size: size.height * 0.025,
        ),
      ],
    ),
  ),
),
```

- [ ] Add scroll indicator to `BigBangEra` — disappears quickly (fades out by progress 0.25)

### Step 3.10: Commit Phase 3

- [ ] Run `flutter analyze` — zero errors
- [ ] Run `flutter build web` — builds successfully
- [ ] Commit: `"feat: phase 3 — eras 1-5, star field, nebula, orbit painters"`

---

## Phase 4: Eras 5–9 — From Life to Future

**Goal:** Implement remaining eras: Life Begins (organic cells), Age of Giants (silhouettes), Humanity (firelight), Future (dissolve to light).

### Step 4.1: Implement `LifeBeginsEra` — `lib/pages/eras/life_begins.dart`

Organic green/teal with cell-like particles drifting:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class LifeBeginsEra extends StatelessWidget {
  const LifeBeginsEra({super.key});

  static const int eraIndex = 5;

  static const List<NebulaCloud> _pools = [
    NebulaCloud(x: 0.3, y: 0.5, radius: 0.2, color: AppColors.lifeGreen, opacity: 0.12, driftSpeed: 0.02),
    NebulaCloud(x: 0.6, y: 0.4, radius: 0.15, color: AppColors.lifeTeal, opacity: 0.1, driftSpeed: -0.015),
    NebulaCloud(x: 0.7, y: 0.6, radius: 0.18, color: AppColors.lifeGreen, opacity: 0.08, driftSpeed: 0.01),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.lifeBg,
          nextBackgroundColor: AppColors.giantsBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(progress: progress, clouds: _pools),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(
                    progress: progress,
                    particles: _cellParticles,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static final List<Particle> _cellParticles = List<Particle>.generate(
    30,
    (int i) {
      final Random r = Random(i + 500);
      return Particle(
        startX: 0.2 + r.nextDouble() * 0.6,
        startY: 0.2 + r.nextDouble() * 0.6,
        velocityX: (r.nextDouble() - 0.5) * 0.05,
        velocityY: (r.nextDouble() - 0.5) * 0.05,
        color: i.isEven ? AppColors.lifeGreen : AppColors.lifeTeal,
        size: 2.0 + r.nextDouble() * 4.0,
        opacity: 0.15 + r.nextDouble() * 0.2,
        birthProgress: r.nextDouble() * 0.4,
      );
    },
  );
}
```

- [ ] Replace `lib/pages/eras/life_begins.dart` with the above content
- [ ] Cell particles are larger (2–6px) and slower than star particles — organic feeling

### Step 4.2: Implement `AgeOfGiantsEra` — `lib/pages/eras/age_of_giants.dart`

Earthy greens with misty atmosphere. Creature silhouettes revealed on hover/tap (interactive component wired in Phase 5):

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class AgeOfGiantsEra extends StatelessWidget {
  const AgeOfGiantsEra({super.key});

  static const int eraIndex = 6;

  static const List<NebulaCloud> _mist = [
    NebulaCloud(x: 0.2, y: 0.7, radius: 0.3, color: AppColors.giantsForest, opacity: 0.2, driftSpeed: 0.01),
    NebulaCloud(x: 0.7, y: 0.6, radius: 0.25, color: AppColors.giantsLeaf, opacity: 0.1, driftSpeed: -0.008),
    NebulaCloud(x: 0.5, y: 0.8, radius: 0.35, color: AppColors.giantsBg, opacity: 0.15, driftSpeed: 0.005),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.giantsBg,
          nextBackgroundColor: AppColors.humanityBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.giantsBg, AppColors.giantsForest],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(progress: progress, clouds: _mist),
                ),
              ),
              Positioned.fill(
                child: CreatureRevealer(eraProgress: progress),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/age_of_giants.dart` with the above content

### Step 4.3: Implement `HumanityEra` — `lib/pages/eras/humanity.dart`

Warm amber with a central firelight glow. Stars visible in the sky above:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class HumanityEra extends StatelessWidget {
  const HumanityEra({super.key});

  static const int eraIndex = 7;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.humanityBg,
          nextBackgroundColor: AppColors.futureBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(
                    progress: progress,
                    starCount: 60,
                    baseColor: AppColors.white,
                    maxOpacity: 0.2,
                    seed: 789,
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.25,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: size.width * 0.004,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.humanityFire.withValues(alpha: progress.clamp(0.0, 0.9)),
                          AppColors.humanityWarm.withValues(alpha: progress.clamp(0.0, 0.5)),
                          AppColors.parent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(
                    progress: progress,
                    clouds: const [
                      NebulaCloud(x: 0.5, y: 0.65, radius: 0.12, color: AppColors.humanityFire, opacity: 0.3, driftSpeed: 0.0),
                      NebulaCloud(x: 0.5, y: 0.6, radius: 0.2, color: AppColors.humanityWarm, opacity: 0.15, driftSpeed: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/humanity.dart` with the above content
- [ ] The firelight is a narrow gradient column + warm nebula glow — subtle but warm

### Step 4.4: Implement `FutureEra` — `lib/pages/eras/future.dart`

The only era that transitions from dark to light. As the user scrolls, the dark cosmos dissolves into brightness:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class FutureEra extends StatelessWidget {
  const FutureEra({super.key});

  static const int eraIndex = 8;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, __) {
        final double progress = pro.eraProgressFor(eraIndex);
        final double lightProgress = (progress * 1.5).clamp(0.0, 1.0);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: Color.lerp(
            AppColors.futureBg,
            AppColors.futureLight,
            lightProgress,
          )!,
          nextBackgroundColor: AppColors.portfolioBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(
                    progress: progress,
                    starCount: 100,
                    baseColor: AppColors.white,
                    maxOpacity: (1.0 - lightProgress).clamp(0.0, 0.8),
                    seed: 999,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: AppColors.futureLight.withValues(alpha: lightProgress * 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] Replace `lib/pages/eras/future.dart` with the above content
- [ ] `lightProgress` accelerates faster than scroll (×1.5) so light overtakes the user — dramatic payoff
- [ ] Star field fades out as light fills in
- [ ] `EraWrapper` text should use dark color when `lightProgress > 0.5` — handle via text color override

### Step 4.5: Update `EraWrapper` to support light-mode text

Add an optional `useDarkText` parameter to `EraWrapper` for Era 9:

```dart
final bool useDarkText;
```

Default `false`. When `true`, `_EraTextContent` uses `AppColors.portfolioText` instead of `AppColors.white`.

In `_EraTextContent`, add the same parameter and conditionally pick colors:

```dart
color: useDarkText
    ? AppColors.portfolioText.withValues(alpha: 0.4)
    : AppColors.white.withValues(alpha: 0.4),
```

Apply to all 3 text widgets in `_EraTextContent` (timestamp, headline, description).

- [ ] Add `useDarkText` parameter (default `false`) to `EraWrapper` and `_EraTextContent`
- [ ] Update `FutureEra` to pass `useDarkText: progress > 0.4`

### Step 4.6: Implement `PortfolioReveal` — `lib/pages/portfolio/portfolio_reveal.dart`

The portfolio section — light background, your name, role, links:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioReveal extends StatelessWidget {
  const PortfolioReveal({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Responsive(
      mobile: PortfolioMobileLayout(size: size),
      tablet: PortfolioTabletLayout(size: size),
      desktop: PortfolioDesktopLayout(size: size),
    );
  }
}
```

- [ ] Replace `lib/pages/portfolio/portfolio_reveal.dart` with the above content

### Step 4.7: Implement portfolio layouts

**`lib/layouts/portfolio/desktop.dart`:**

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioDesktopLayout extends StatelessWidget {
  const PortfolioDesktopLayout({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.portfolioBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppText.portfolioIntro,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioSubtext,
              fontSize: size.height * 0.018,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            AppText.portfolioName,
            style: GoogleFonts.russoOne(
              color: AppColors.portfolioText,
              fontSize: size.height * 0.06,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            AppText.portfolioRole,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioAccent,
              fontSize: size.height * 0.02,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Container(
            width: size.width * 0.06,
            height: size.height * 0.002,
            color: AppColors.portfolioAccent.withValues(alpha: 0.4),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            AppText.portfolioTagline,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioSubtext,
              fontSize: size.height * 0.016,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
```

**`lib/layouts/portfolio/tablet.dart`** and **`lib/layouts/portfolio/mobile.dart`**: Same structure as desktop but with adjusted font sizes — tablet uses `0.8×` desktop sizes, mobile uses `0.65×`.

- [ ] Implement all 3 portfolio layout files following the pattern above
- [ ] Tablet: `fontSize` multiplied by 0.8 vs desktop values
- [ ] Mobile: `fontSize` multiplied by 0.65 vs desktop values

### Step 4.8: Implement era layout wrappers

The era layouts handle responsive text sizing. Update `lib/layouts/eras/desktop.dart`, `tablet.dart`, `mobile.dart`:

**`lib/layouts/eras/desktop.dart`:**
```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class EraDesktopLayout extends StatelessWidget {
  const EraDesktopLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
```

Since `EraWrapper` already handles all sizing via `MediaQuery.sizeOf`, the layout wrappers pass through for now. They exist as extension points if per-breakpoint customization is needed later.

- [ ] Update all 3 era layout files as pass-through wrappers
- [ ] These are scaffolding — they'll gain content if specific eras need per-breakpoint differences

### Step 4.9: Verify Eras 5–9 + Portfolio render correctly

- [ ] Run `flutter run -d chrome`
- [ ] Scroll through all 9 eras — verify each has its distinct visual identity
- [ ] Verify Era 9 transitions from dark to light
- [ ] Verify portfolio section renders with name, role, tagline on light background
- [ ] Verify progress bar tracks correctly through all 9 eras

### Step 4.10: Commit Phase 4

- [ ] Run `flutter analyze` — zero errors
- [ ] Run `flutter build web` — builds successfully
- [ ] Commit: `"feat: phase 4 — eras 5-9, life/giants/humanity/future, portfolio reveal"`

---

## Phase 5: Interactive Moments

**Goal:** Implement the 3 interactive components: StarIgniter (tap to ignite), GalaxyRotator (drag to rotate), CreatureRevealer (hover/tap to reveal). Each uses a scoped `ChangeNotifierProvider`.

### Step 5.1: Create `StarIgniterProvider`

Create `lib/components/interactive/star_igniter.dart` with a scoped provider + interactive widget. Stars appear where the user taps:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class _StarIgniterProvider extends ChangeNotifier {
  final List<Offset> _ignitedStars = <Offset>[];
  List<Offset> get ignitedStars => _ignitedStars;

  final List<double> _ignitedSizes = <double>[];
  List<double> get ignitedSizes => _ignitedSizes;

  void ignite(Offset position, double size) {
    _ignitedStars.add(position);
    _ignitedSizes.add(size);
    notifyListeners();
  }
}

class StarIgniter extends StatelessWidget {
  const StarIgniter({super.key, required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_StarIgniterProvider>(
      create: (_) => _StarIgniterProvider(),
      child: _StarIgniterBody(eraProgress: eraProgress),
    );
  }
}

class _StarIgniterBody extends StatelessWidget {
  const _StarIgniterBody({required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    return Consumer<_StarIgniterProvider>(
      builder: (_, _StarIgniterProvider pro, __) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            final Random r = Random();
            pro.ignite(
              details.localPosition,
              3.0 + r.nextDouble() * 5.0,
            );
          },
          behavior: HitTestBehavior.translucent,
          child: CustomPaint(
            painter: _IgnitedStarsPainter(
              stars: pro.ignitedStars,
              sizes: pro.ignitedSizes,
              progress: eraProgress,
            ),
          ),
        );
      },
    );
  }
}

class _IgnitedStarsPainter extends CustomPainter {
  const _IgnitedStarsPainter({
    required this.stars,
    required this.sizes,
    required this.progress,
  });

  final List<Offset> stars;
  final List<double> sizes;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (int i = 0; i < stars.length; i++) {
      final Offset pos = stars[i];
      final double starSize = sizes[i];

      paint.color = AppColors.firstStarsGlow;
      canvas.drawCircle(pos, starSize, paint);

      paint.color = AppColors.firstStarsBright.withValues(alpha: 0.3);
      canvas.drawCircle(pos, starSize * 3, paint);

      paint.color = AppColors.firstStarsGlow.withValues(alpha: 0.1);
      canvas.drawCircle(pos, starSize * 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IgnitedStarsPainter oldDelegate) =>
      oldDelegate.stars.length != stars.length ||
      oldDelegate.progress != progress;
}
```

- [ ] Replace `lib/components/interactive/star_igniter.dart` with the above content
- [ ] `_StarIgniterProvider` is file-private — scoped via `ChangeNotifierProvider` inside `StarIgniter`
- [ ] Each tap adds a glowing star at the tap position with 3-layer glow (core + inner + outer)

### Step 5.2: Create `GalaxyRotatorProvider`

Create `lib/components/interactive/galaxy_rotator.dart` — drag to rotate a spiral galaxy:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class _GalaxyRotatorProvider extends ChangeNotifier {
  double _rotation = 0.0;
  double get rotation => _rotation;

  void rotate(double delta) {
    _rotation += delta;
    notifyListeners();
  }
}

class GalaxyRotator extends StatelessWidget {
  const GalaxyRotator({super.key, required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_GalaxyRotatorProvider>(
      create: (_) => _GalaxyRotatorProvider(),
      child: _GalaxyRotatorBody(eraProgress: eraProgress),
    );
  }
}

class _GalaxyRotatorBody extends StatelessWidget {
  const _GalaxyRotatorBody({required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<_GalaxyRotatorProvider>(
      builder: (_, _GalaxyRotatorProvider pro, __) {
        return GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            pro.rotate(details.delta.dx / size.width * 2);
          },
          behavior: HitTestBehavior.translucent,
          child: CustomPaint(
            painter: _GalaxySpiralPainter(
              rotation: pro.rotation + eraProgress * pi * 2,
              progress: eraProgress,
            ),
          ),
        );
      },
    );
  }
}

class _GalaxySpiralPainter extends CustomPainter {
  const _GalaxySpiralPainter({
    required this.rotation,
    required this.progress,
  });

  final double rotation;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint();
    final Random random = Random(42);

    for (int arm = 0; arm < 3; arm++) {
      final double armOffset = arm * (pi * 2 / 3);

      for (int i = 0; i < 60; i++) {
        final double t = i / 60.0;
        final double spiralRadius = t * size.width * 0.2;
        final double angle = armOffset + rotation + t * pi * 3;

        final double jitterX = (random.nextDouble() - 0.5) * 15;
        final double jitterY = (random.nextDouble() - 0.5) * 15;

        final double x = center.dx + spiralRadius * cos(angle) + jitterX;
        final double y = center.dy + spiralRadius * sin(angle) * 0.6 + jitterY;

        final double starOpacity = ((1.0 - t) * 0.7 * progress).clamp(0.0, 0.7);
        paint.color = Color.lerp(
          AppColors.galaxiesCore,
          AppColors.galaxiesArm,
          t,
        )!.withValues(alpha: starOpacity);

        final double dotSize = (1.0 + random.nextDouble() * 2.0) * (1.0 - t * 0.5);
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }

    paint.color = AppColors.white.withValues(alpha: 0.8 * progress);
    canvas.drawCircle(center, 4, paint);
    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    canvas.drawCircle(center, 12, paint);
  }

  @override
  bool shouldRepaint(covariant _GalaxySpiralPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.progress != progress;
}
```

- [ ] Replace `lib/components/interactive/galaxy_rotator.dart` with the above content
- [ ] 3 spiral arms with 60 dots each — rotation driven by drag + scroll progress
- [ ] Spiral is viewed at an angle (y × 0.6) for perspective

### Step 5.3: Create `CreatureRevealerProvider`

Create `lib/components/interactive/creature_revealer.dart` — hover (desktop) or tap (mobile) to reveal dinosaur silhouettes:

```dart
import 'package:safeandromeda/core/hooks/hooks.dart';

class _CreatureRevealerProvider extends ChangeNotifier {
  final Set<int> _revealed = <int>{};
  Set<int> get revealed => _revealed;

  void reveal(int index) {
    if (_revealed.add(index)) {
      notifyListeners();
    }
  }
}

class CreatureRevealer extends StatelessWidget {
  const CreatureRevealer({super.key, required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_CreatureRevealerProvider>(
      create: (_) => _CreatureRevealerProvider(),
      child: _CreatureRevealerBody(eraProgress: eraProgress),
    );
  }
}

class _CreatureRevealerBody extends StatelessWidget {
  const _CreatureRevealerBody({required this.eraProgress});

  final double eraProgress;

  static const List<_CreatureData> _creatures = [
    _CreatureData(x: 0.15, y: 0.7, width: 0.12, height: 0.15, label: 'T-Rex · 12m tall'),
    _CreatureData(x: 0.4, y: 0.65, width: 0.18, height: 0.2, label: 'Argentinosaurus · 35m long'),
    _CreatureData(x: 0.7, y: 0.72, width: 0.1, height: 0.08, label: 'Triceratops · 9m long'),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isMobile = Responsive.isMobile(context);

    return Consumer<_CreatureRevealerProvider>(
      builder: (_, _CreatureRevealerProvider pro, __) {
        return Stack(
          children: List<Widget>.generate(_creatures.length, (int i) {
            final _CreatureData c = _creatures[i];
            final bool isRevealed = pro.revealed.contains(i);

            return Positioned(
              left: c.x * size.width,
              top: c.y * size.height * AppSettings.eraHeightFactor,
              width: c.width * size.width,
              height: c.height * size.height * AppSettings.eraHeightFactor,
              child: MouseRegion(
                onEnter: isMobile ? null : (_) => pro.reveal(i),
                child: GestureDetector(
                  onTap: isMobile ? () => pro.reveal(i) : null,
                  behavior: HitTestBehavior.translucent,
                  child: AnimatedOpacity(
                    opacity: isRevealed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: c.width * size.width,
                          height: c.height * size.height * AppSettings.eraHeightFactor * 0.7,
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: size.height * 0.008),
                        Text(
                          c.label,
                          style: GoogleFonts.roboto(
                            color: AppColors.giantsLeaf.withValues(alpha: 0.7),
                            fontSize: size.height * 0.012,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _CreatureData {
  const _CreatureData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final String label;
}
```

- [ ] Replace `lib/components/interactive/creature_revealer.dart` with the above content
- [ ] Desktop: hover reveals silhouettes. Mobile: tap reveals them. Uses `Responsive.isMobile()`
- [ ] `AnimatedOpacity` fades creatures in over 600ms — no `setState`, driven by Provider

### Step 5.4: Verify star igniter works

- [ ] Run `flutter run -d chrome`
- [ ] Scroll to Era 3 (First Stars)
- [ ] Click/tap on the dark areas — glowing stars should appear at each tap position
- [ ] Stars should have 3-layer glow effect (bright core, medium inner, soft outer)

### Step 5.5: Verify galaxy rotator works

- [ ] Scroll to Era 4 (Galaxies)
- [ ] Click and drag horizontally — the spiral galaxy should rotate
- [ ] Galaxy should also auto-rotate slowly as you scroll (driven by `eraProgress`)

### Step 5.6: Verify creature revealer works

- [ ] Scroll to Era 7 (Age of Giants)
- [ ] Hover over the three creature zones (desktop) — silhouettes should fade in
- [ ] Verify labels show scale information ("T-Rex · 12m tall", etc.)

### Step 5.7: Add hint text for interactive eras

In `_EraTextContent` inside `era_wrapper.dart`, add optional hint text below the description for interactive eras. Add a parameter to `EraWrapper`:

```dart
final String? interactionHint;
```

In `_EraTextContent`, if `interactionHint` is not null, render it below the description:

```dart
if (interactionHint != null) ...[
  SizedBox(height: size.height * 0.025),
  Text(
    interactionHint!,
    style: GoogleFonts.roboto(
      color: AppColors.white.withValues(alpha: 0.3),
      fontSize: size.height * 0.012,
      letterSpacing: 3,
    ),
  ),
],
```

- [ ] Add `interactionHint` parameter to `EraWrapper` and `_EraTextContent`
- [ ] Update `FirstStarsEra` to pass `interactionHint: 'TAP TO IGNITE STARS'`
- [ ] Update `GalaxiesEra` to pass `interactionHint: 'DRAG TO ROTATE'`
- [ ] Update `AgeOfGiantsEra` to pass `interactionHint: 'HOVER TO REVEAL'` (or `'TAP TO REVEAL'` on mobile — pass based on `Responsive.isMobile(context)`)

### Step 5.8: Add smooth scroll physics

In `journey_page.dart`, add `BouncingScrollPhysics` to the `SingleChildScrollView` for a smoother scroll feel on web:

```dart
physics: const BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
),
```

- [ ] Add scroll physics to `SingleChildScrollView` in `journey_page.dart`

### Step 5.9: Remove `scrollable_positioned_list` from `pubspec.yaml`

This dependency is no longer used — we replaced it with `CustomScrollView` + `ScrollController`:

- [ ] Remove `scrollable_positioned_list: ^0.3.8` from `pubspec.yaml` dependencies
- [ ] Run `flutter pub get`
- [ ] Run `flutter analyze` — verify no references remain

### Step 5.10: Commit Phase 5

- [ ] Run `flutter analyze` — zero errors
- [ ] Run `flutter build web` — builds successfully
- [ ] Commit: `"feat: phase 5 — interactive moments (star igniter, galaxy rotator, creature revealer)"`

---

## Phase 6: Responsive, Performance & Polish

**Goal:** Fine-tune responsive behavior across breakpoints, optimize painter performance, add final visual polish, clean up unused files, final build verification.

### Step 6.1: Add responsive particle density

In each era that uses painters, reduce particle counts on mobile/tablet. Create a helper in `lib/core/utils/app_settings.dart`:

```dart
static int particleCount(BuildContext context, {required int desktop}) {
  if (Responsive.isMobile(context)) return (desktop * 0.4).round();
  if (Responsive.isTablet(context)) return (desktop * 0.7).round();
  return desktop;
}
```

- [ ] Add `particleCount` helper to `AppSettings`
- [ ] Update `BigBangEra` particle count: desktop 80 → mobile 32, tablet 56
- [ ] Update `FirstStarsEra` star count: desktop 150 → mobile 60, tablet 105
- [ ] Update `GalaxiesEra` star count: desktop 200 → mobile 80, tablet 140
- [ ] Update `SolarSystemEra` star count: desktop 80 → mobile 32, tablet 56

### Step 6.2: Responsive text sizing in `_EraTextContent`

Update `_EraTextContent` in `era_wrapper.dart` to adjust font sizes per breakpoint:

```dart
final bool isMobile = Responsive.isMobile(context);
final bool isTablet = Responsive.isTablet(context);
final double scaleFactor = isMobile ? 0.65 : isTablet ? 0.8 : 1.0;
final double horizontalPadding = isMobile ? 0.06 : 0.1;
final double descriptionWidth = isMobile ? 0.85 : isTablet ? 0.65 : 0.5;
```

Apply `scaleFactor` to all font sizes and `descriptionWidth` to the description `SizedBox`.

- [ ] Update `_EraTextContent` with responsive scale factors
- [ ] Mobile: 65% font size, 85% width description
- [ ] Tablet: 80% font size, 65% width description
- [ ] Desktop: 100% font size, 50% width description

### Step 6.3: Responsive progress bar

Update `ProgressBar` to adjust sizing on mobile — hide the "CHRONOS" label on mobile to save space:

```dart
final bool isMobile = Responsive.isMobile(context);

// In the Row:
if (!isMobile)
  Text(
    AppSettings.appName.toUpperCase(),
    // ...
  ),
```

- [ ] Update `ProgressBar` to hide app name on mobile
- [ ] Adjust padding: mobile uses `0.03` horizontal, desktop uses `0.04`

### Step 6.4: Add `RepaintBoundary` to interactive components

Wrap each interactive component's `CustomPaint` in `RepaintBoundary` to isolate their repaint regions from the era's main painter:

- [ ] Wrap `_IgnitedStarsPainter` CustomPaint in `RepaintBoundary`
- [ ] Wrap `_GalaxySpiralPainter` CustomPaint in `RepaintBoundary`
- [ ] These prevent interactive repaints from triggering full era repaints

### Step 6.5: Guard `ScrollProvider.initScroll` against double-init

When the browser resizes, `JourneyPage.build` re-runs and could re-initialize the scroll listener. Add a guard:

```dart
bool _initialized = false;

void initScroll(double viewportHeight) {
  _viewportHeight = viewportHeight;
  if (!_initialized) {
    _scrollController.addListener(_onScroll);
    _initialized = true;
  }
}
```

- [ ] Add `_initialized` guard to `ScrollProvider.initScroll`
- [ ] This prevents duplicate scroll listeners on hot reload or window resize

### Step 6.6: Add `Selector` optimization for eras

Each era currently rebuilds on every scroll event via `Consumer<ScrollProvider>`. Optimize with `Selector` so each era only rebuilds when its own progress changes meaningfully:

In each era file, replace:
```dart
Consumer<ScrollProvider>(
  builder: (_, ScrollProvider pro, __) {
    final double progress = pro.eraProgressFor(eraIndex);
```

With:
```dart
Selector<ScrollProvider, double>(
  selector: (_, ScrollProvider pro) =>
      (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
  builder: (_, double progress, __) {
```

This quantizes progress to 0.01 steps — 100 rebuilds per era instead of thousands.

- [ ] Update all 9 era files to use `Selector<ScrollProvider, double>` instead of `Consumer`
- [ ] The `* 100 / 100` rounding reduces rebuild frequency by ~10x

### Step 6.7: Update `.gitignore` for `.superpowers/`

```
.superpowers/
```

- [ ] Add `.superpowers/` to `.gitignore`

### Step 6.8: Remove unused `cupertino_icons` from `pubspec.yaml`

- [ ] Remove `cupertino_icons: ^1.0.8` from `pubspec.yaml` dependencies
- [ ] Run `flutter pub get`

### Step 6.9: Full end-to-end verification

- [ ] Run `flutter analyze` — zero errors
- [ ] Run `flutter build web` — builds successfully
- [ ] Run `flutter run -d chrome` and test:
  - [ ] Scroll through all 9 eras — visual effects render correctly
  - [ ] Progress bar tracks position and crossfades era labels
  - [ ] Tap progress bar to jump between eras
  - [ ] Era 3: tap to ignite stars works
  - [ ] Era 4: drag to rotate galaxy works
  - [ ] Era 7: hover/tap reveals creatures
  - [ ] Era 9: dark-to-light transition works
  - [ ] Portfolio section renders with correct text
  - [ ] Resize browser: mobile/tablet/desktop layouts adapt
  - [ ] "SCROLL TO EXPLORE" hint visible at start, fades on scroll
  - [ ] No console errors in DevTools

### Step 6.10: Final commit

- [ ] Commit: `"feat: phase 6 — responsive polish, performance optimization, final cleanup"`
- [ ] Run `flutter build web --release` — verify production build succeeds
