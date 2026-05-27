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
      builder: (_, _CreatureRevealerProvider pro, _) {
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
                    child: AnimatedScale(
                      scale: isRevealed ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: CustomPaint(
                              painter: _CreatureSilhouettePainter(
                                creatureIndex: i,
                                glowColor: AppColors.giantsLeaf,
                              ),
                              size: Size.infinite,
                            ),
                          ),
                          SizedBox(height: size.height * 0.008),
                          Text(
                            c.label,
                            style: GoogleFonts.roboto(
                              color: AppColors.giantsLeaf.withValues(alpha: 0.7),
                              fontSize: size.height * 0.012,
                              shadows: [
                                Shadow(
                                  color: AppColors.giantsLeaf.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                ),
                              ],
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
        );
      },
    );
  }
}

class _CreatureSilhouettePainter extends CustomPainter {
  const _CreatureSilhouettePainter({
    required this.creatureIndex,
    required this.glowColor,
  });

  final int creatureIndex;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path path = switch (creatureIndex) {
      0 => _buildTRexPath(w, h),
      1 => _buildArgentinosaurusPath(w, h),
      _ => _buildTriceratopsPath(w, h),
    };

    // Glow shadow behind silhouette
    final Paint glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(path, glowPaint);

    // Silhouette fill
    final Paint fillPaint = Paint()
      ..color = const Color(0xff0a1508)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Subtle edge highlight
    final Paint edgePaint = Paint()
      ..color = glowColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, edgePaint);
  }

  Path _buildTRexPath(double w, double h) {
    final Path path = Path();
    path.moveTo(w * 0.1, h * 0.8);
    path.lineTo(w * 0.1, h * 0.4);
    path.lineTo(w * 0.2, h * 0.35);
    path.lineTo(w * 0.25, h * 0.15);
    path.lineTo(w * 0.5, h * 0.05);
    path.lineTo(w * 0.6, h * 0.15);
    path.lineTo(w * 0.45, h * 0.2);
    path.lineTo(w * 0.3, h * 0.25);
    path.lineTo(w * 0.28, h * 0.4);
    path.lineTo(w * 0.25, h * 0.42);
    path.lineTo(w * 0.22, h * 0.4);
    path.lineTo(w * 0.15, h * 0.5);
    path.lineTo(w * 0.2, h * 0.8);
    path.lineTo(w * 0.8, h * 0.45);
    path.lineTo(w * 0.95, h * 0.35);
    path.close();
    return path;
  }

  Path _buildArgentinosaurusPath(double w, double h) {
    final Path path = Path();
    // Long-neck sauropod silhouette
    path.moveTo(w * 0.05, h * 0.85);
    // Front legs
    path.lineTo(w * 0.12, h * 0.55);
    // Chest
    path.lineTo(w * 0.1, h * 0.45);
    // Neck base
    path.lineTo(w * 0.08, h * 0.35);
    // Long neck curving up
    path.quadraticBezierTo(w * 0.04, h * 0.2, w * 0.06, h * 0.08);
    // Head
    path.lineTo(w * 0.12, h * 0.05);
    path.lineTo(w * 0.14, h * 0.08);
    // Neck back
    path.quadraticBezierTo(w * 0.12, h * 0.2, w * 0.15, h * 0.32);
    // Back
    path.quadraticBezierTo(w * 0.3, h * 0.25, w * 0.5, h * 0.3);
    // Spine curve
    path.quadraticBezierTo(w * 0.65, h * 0.28, w * 0.7, h * 0.35);
    // Tail base
    path.lineTo(w * 0.72, h * 0.4);
    // Tail
    path.quadraticBezierTo(w * 0.82, h * 0.35, w * 0.95, h * 0.25);
    // Tail tip
    path.lineTo(w * 0.98, h * 0.23);
    // Under tail back to body
    path.quadraticBezierTo(w * 0.85, h * 0.4, w * 0.72, h * 0.5);
    // Back legs
    path.lineTo(w * 0.65, h * 0.85);
    path.lineTo(w * 0.55, h * 0.85);
    path.lineTo(w * 0.55, h * 0.55);
    // Belly
    path.quadraticBezierTo(w * 0.35, h * 0.55, w * 0.2, h * 0.55);
    // Front legs
    path.lineTo(w * 0.15, h * 0.85);
    path.close();
    return path;
  }

  Path _buildTriceratopsPath(double w, double h) {
    final Path path = Path();
    // Triceratops: horned head, frill, stocky body
    path.moveTo(w * 0.05, h * 0.85);
    // Front legs
    path.lineTo(w * 0.08, h * 0.6);
    // Chest to head
    path.lineTo(w * 0.06, h * 0.45);
    // Frill (back of head shield)
    path.lineTo(w * 0.02, h * 0.3);
    path.lineTo(w * 0.05, h * 0.2);
    path.lineTo(w * 0.1, h * 0.15);
    // Top horn
    path.lineTo(w * 0.18, h * 0.02);
    // Head top
    path.lineTo(w * 0.22, h * 0.15);
    // Second horn
    path.lineTo(w * 0.28, h * 0.08);
    path.lineTo(w * 0.3, h * 0.18);
    // Nose horn
    path.lineTo(w * 0.38, h * 0.25);
    path.lineTo(w * 0.36, h * 0.32);
    // Beak/mouth
    path.lineTo(w * 0.32, h * 0.38);
    // Throat
    path.lineTo(w * 0.2, h * 0.42);
    // Under neck to body
    path.lineTo(w * 0.18, h * 0.55);
    // Front legs base
    path.lineTo(w * 0.15, h * 0.85);
    path.lineTo(w * 0.22, h * 0.85);
    path.lineTo(w * 0.25, h * 0.6);
    // Belly
    path.quadraticBezierTo(w * 0.45, h * 0.62, w * 0.6, h * 0.58);
    // Back legs
    path.lineTo(w * 0.62, h * 0.85);
    path.lineTo(w * 0.72, h * 0.85);
    path.lineTo(w * 0.7, h * 0.55);
    // Back
    path.quadraticBezierTo(w * 0.6, h * 0.35, w * 0.45, h * 0.32);
    path.quadraticBezierTo(w * 0.3, h * 0.3, w * 0.15, h * 0.32);
    // Frill edge
    path.lineTo(w * 0.1, h * 0.28);
    // Tail
    path.moveTo(w * 0.7, h * 0.5);
    path.quadraticBezierTo(w * 0.82, h * 0.42, w * 0.92, h * 0.38);
    path.quadraticBezierTo(w * 0.85, h * 0.48, w * 0.72, h * 0.55);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _CreatureSilhouettePainter oldDelegate) =>
      creatureIndex != oldDelegate.creatureIndex ||
      glowColor != oldDelegate.glowColor;
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
