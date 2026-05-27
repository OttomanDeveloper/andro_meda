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
