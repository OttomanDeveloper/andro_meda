import 'package:safeandromeda/core/hooks/hooks.dart';

/// Named color palette for the app. Grouped per era plus shared UI colors.
/// Color values are ARGB; the leading two hex digits are alpha.
abstract class AppColors {
  const AppColors._();

  // Base
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color parent =
      Colors.transparent; // placeholder / pass-through fill

  // Progress bar (journey scrubber, shared across eras)
  static const Color progressBg = Color(
    0x33ffffff,
  ); // unfilled track, ~20% white
  static const Color progressFill = Color(
    0xaaffffff,
  ); // filled portion, ~67% white
  static const Color eraLabelText = Color(
    0x99ffffff,
  ); // era name caption, ~60% white

  // Era 1, Big Bang
  static const Color bigBangCenter = Color(0xffffffff); // hottest core flash
  static const Color bigBangMid = Color(0xffffcc00); // inner glow ring
  static const Color bigBangOuter = Color(0xffff6600); // outer fireball
  static const Color bigBangEdge = Color(
    0xff220000,
  ); // fading edge into the void
  static const Color bigBangVoid = Color(0xff000000); // surrounding empty space

  // Era 2, Cosmic Dark Ages
  static const Color darkAgesBg = Color(0xff000000); // base black backdrop
  static const Color darkAgesDeep = Color(0xff020208); // faint deep-space tint
  static const Color darkAgesWisp = Color(0xff0a0a1a); // gas wisps
  static const Color darkAgesHydrogen = Color(
    0xff1a1030,
  ); // hydrogen fog clouds

  // Era 3, First Stars
  static const Color firstStarsBg = Color(0xff050520); // night-sky background
  static const Color firstStarsDeep = Color(
    0xff0a0a30,
  ); // deeper background layer
  static const Color firstStarsGlow = Color(0xffc8dcff); // bluish stellar glow
  static const Color firstStarsBright = Color(
    0xffffffff,
  ); // star core highlight

  // Era 4, Galaxies
  static const Color galaxiesBg = Color(0xff0a1030); // background
  static const Color galaxiesDeep = Color(0xff150a30); // deeper purple layer
  static const Color galaxiesArm = Color(0xff9678ff); // spiral arm color
  static const Color galaxiesCore = Color(0xff6496ff); // bright galactic core

  // Era 5, Solar System
  static const Color solarBg = Color(0xff050515); // background
  static const Color solarDust = Color(0xff1a1000); // protoplanetary dust disk
  static const Color solarSun = Color(0xffffcc44); // sun body
  static const Color solarFlare = Color(0xffff9900); // solar flare / corona

  // Era 6, Life Begins
  static const Color lifeBg = Color(0xff001a0a); // background
  static const Color lifeDeep = Color(0xff003a20); // deeper water/ooze layer
  static const Color lifeGreen = Color(0xff00ff96); // microbe / DNA green
  static const Color lifeTeal = Color(0xff00c8ff); // teal accent

  // Era 7, Age of Giants
  static const Color giantsBg = Color(0xff1a2a15); // background
  static const Color giantsForest = Color(0xff2a3a20); // forest canopy
  static const Color giantsLeaf = Color(0xff96c864); // foliage / leaves
  static const Color giantsEarth = Color(0xffc8a050); // ground / dinosaur tone

  // Era 8, Humanity
  static const Color humanityBg = Color(0xff1a0a00); // background
  static const Color humanityDark = Color(0xff2a1500); // dark earth / cave
  static const Color humanityFire = Color(0xffff9932); // campfire flame
  static const Color humanityWarm = Color(0xffffcc66); // warm firelight glow

  // Era 9, Future
  static const Color futureBg = Color(0xff0a0a2e); // background
  static const Color futureDeep = Color(0xff1a1a40); // deeper layer
  static const Color futureGlow = Color(0x99ffffff); // tech glow, ~60% white
  static const Color futureLight = Color(0xfff0f0f0); // near-white highlight

  // Portfolio (final reveal screen, light theme)
  static const Color portfolioBg = Color(0xfff0f0f0); // light background
  static const Color portfolioText = Color(0xff1a1a2e); // primary dark text
  static const Color portfolioAccent = Color(0xff6496ff); // accent / link blue
  static const Color portfolioSubtext = Color(
    0xff666680,
  ); // muted secondary text
}
