import 'package:safeandromeda/core/hooks/hooks.dart';

/// Tracks which titan indices the user has already revealed via tap or hover.
class _CreatureRevealerProvider extends ChangeNotifier {
  final Set<int> _revealed = <int>{}; // indices into _creatures, 0..2
  Set<int> get revealed => _revealed;

  /// Marks a titan revealed; notifies only on the first reveal of that index.
  void reveal(int index) {
    if (_revealed.add(index)) {
      notifyListeners();
    }
  }
}

/// Age-of-Giants overlay: three dinosaur titans the user reveals by tap/hover.
class CreatureRevealer extends StatelessWidget {
  const CreatureRevealer({
    super.key,
    required this.eraProgress,
    required this.time,
  });

  final double eraProgress; // era scroll progress, 0..1
  final double time; // global animation clock, seconds

  /// Scopes a reveal provider to this overlay's subtree.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_CreatureRevealerProvider>(
      create: (_) => _CreatureRevealerProvider(),
      child: _CreatureRevealerBody(eraProgress: eraProgress, time: time),
    );
  }
}

/// Lays out the dust, the three titans, and the era title.
class _CreatureRevealerBody extends StatelessWidget {
  const _CreatureRevealerBody({required this.eraProgress, required this.time});

  final double eraProgress; // era scroll progress, 0..1
  final double time; // global animation clock, seconds

  /// Authored placement and label for each titan; index maps to painter index.
  static const List<_CreatureData> _creatures = [
    _CreatureData(
      x: 0.05,
      y: 0.28,
      width: 0.22,
      height: 0.25,
      label: 'T-Rex · 12m tall',
    ),
    _CreatureData(
      x: 0.32,
      y: 0.2,
      width: 0.32,
      height: 0.32,
      label: 'Argentinosaurus · 35m long',
    ),
    _CreatureData(
      x: 0.7,
      y: 0.3,
      width: 0.2,
      height: 0.16,
      label: 'Triceratops · 9m long',
    ),
  ];

  /// Builds the titan stack; rebuilds when reveal state changes.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    // Drive each creature's box height off the width using a 16:9 reference,
    // so the silhouettes keep their authored proportions on narrow phones
    // instead of stretching tall and thin. (On a 16:9 screen this equals
    // size.height * eraHeightFactor, so desktop/tablet are unchanged.)
    final double boxUnitH = size.width * (9 / 16) * AppSettings.eraHeightFactor;

    return Consumer<_CreatureRevealerProvider>(
      builder: (_, _CreatureRevealerProvider pro, _) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: TitanDustPainter(time: time)),
            ),
            ...List<Widget>.generate(_creatures.length, (int i) {
              final _CreatureData c = _creatures[i];
              final bool isRevealed = pro.revealed.contains(i);
              // Lunge toward one another so the titans appear to brawl.
              final double lunge = 0.5 + 0.5 * sin(time * 2.2); // 0..1 sway
              // Outer two close inward (+18/-18 px); center one stays put.
              final double dx = i == 0
                  ? lunge * 18
                  : (i == 2 ? -lunge * 18 : 0.0);
              // Center bobs vertically; outer two rise slightly on the lunge.
              final double dy = i == 1 ? sin(time * 1.6) * 7 : -lunge * 6;

              return Positioned(
                left: c.x * size.width,
                top: c.y * size.height * AppSettings.eraHeightFactor,
                width: c.width * size.width,
                height: c.height * boxUnitH,
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: MouseRegion(
                    // Hover reveals on desktop; tap reveals on touch (tablet
                    // and mobile). Both are wired so it works on any device.
                    onEnter: (_) => pro.reveal(i),
                    child: GestureDetector(
                      onTap: () => pro.reveal(i),
                      behavior: HitTestBehavior.translucent,
                      child: AnimatedScale(
                        scale: isRevealed ? 1.0 : 0.9,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: CustomPaint(
                                painter: CreatureSilhouettePainter(
                                  creatureIndex: i,
                                  glowColor: AppColors.giantsLeaf,
                                  isRevealed: isRevealed,
                                ),
                                size: Size.infinite,
                              ),
                            ),
                            SizedBox(height: size.height * 0.008),
                            AnimatedOpacity(
                              opacity: isRevealed ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 600),
                              child: Text(
                                c.label,
                                style: GoogleFonts.roboto(
                                  color: AppColors.giantsLeaf.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: size.height * 0.014,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.giantsLeaf.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              left: 0,
              right: 0,
              top: size.height * AppSettings.eraHeightFactor * 0.14,
              child: Center(
                child: Text(
                  'TITANS OF THE EARTH',
                  style: GoogleFonts.russoOne(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: size.height * 0.03,
                    letterSpacing: 6,
                    shadows: [
                      Shadow(
                        color: AppColors.black.withValues(alpha: 0.8),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: AppColors.giantsLeaf.withValues(alpha: 0.6),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Placement box and caption for one titan, all spatial values as 0..1 fractions.
class _CreatureData {
  const _CreatureData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
  });

  final double x; // left edge, fraction of viewport width
  final double y; // top edge, fraction of era canvas height
  final double width; // box width, fraction of viewport width
  final double height; // box height, fraction of derived box unit
  final String label; // caption shown once revealed
}
