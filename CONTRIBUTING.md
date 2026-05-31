# Contributing to Chronos

First off — thank you for taking the time to contribute! 🌌 This guide explains
how to get set up and the conventions this project follows. Please be
respectful and constructive in issues, reviews, and discussions.

## Getting set up

```bash
git clone https://github.com/OttomanDeveloper/andro_meda.git
cd andro_meda
flutter pub get
flutter run -d chrome
```

## Before you open a pull request

Run all three and make sure they pass — CI runs the same checks:

```bash
dart format --output=none --set-exit-if-changed .   # formatting
flutter analyze                                      # static analysis (clean)
flutter test                                         # tests
```

## Project conventions

These keep the codebase consistent — please follow them:

1. **No `setState`.** All state flows through `provider` / `ChangeNotifier`s
   (`ScrollProvider`, `AnimationProvider`, `CursorProvider`, and small
   scene-local providers). This is a hard rule, even for local UI state.
2. **Scenes are `CustomPainter`s.** Visuals are drawn on `Canvas`, not composed
   from images. Position and size everything by **fractions of the painter
   size** (`w`, `vp`) so scenes stay responsive across breakpoints.
3. **Animate from the shared clock.** Read `time` from `AnimationProvider` (fed
   by the single `Ticker` in `JourneyPage`) rather than spinning up new
   `AnimationController`s per widget.
4. **Gate per-frame work with `EraScope`.** Only the on-screen era should
   subscribe to per-frame updates.
5. **Strings, colors, and settings are centralized** in
   `lib/core/utils/` (`AppText`, `AppColors`, `AppSettings`). Add new copy and
   palette entries there, not inline.
6. **Respect the lint rules** in `analysis_options.yaml` (const-correctness,
   strict inference, etc.).
7. **Match the surrounding style** — naming, comment density, and structure.

## Adding or improving an era

- Each era lives in `lib/pages/eras/<era>.dart` and is wrapped in `EraScope` +
  `EraWrapper`.
- The era canvas is `2 × viewport` tall. A scene anchored at canvas fraction `f`
  is best framed around era-progress `p ≈ f − 0.35`; keep this in mind so
  content isn't off-screen when its era is active.
- Reuse the shared painters (`StarFieldPainter`, `NebulaPainter`,
  `InfoLabelPainter`, etc.) where you can.
- Verify on **mobile, tablet, and desktop** widths before submitting.

## Commit messages

Use clear, conventional-style messages where practical:

```
feat: add aurora layer to the Future era
fix: stop info labels clipping on narrow screens
docs: clarify EraScope gating in the README
```

## Reporting bugs & requesting features

Please use the issue templates under **Issues → New issue**. Include your
platform (web/mobile/desktop), Flutter version (`flutter --version`), and steps
to reproduce. Screenshots or a short screen recording help a lot for visual
bugs.

## License

By contributing, you agree that your contributions will be licensed under the
[Creative Commons Attribution 4.0 International License (CC BY 4.0)](LICENSE),
the same license that covers this project.
