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
    _CreatureData(x: 0.05, y: 0.28, width: 0.22, height: 0.25, label: 'T-Rex · 12m tall'),
    _CreatureData(x: 0.32, y: 0.2, width: 0.32, height: 0.32, label: 'Argentinosaurus · 35m long'),
    _CreatureData(x: 0.7, y: 0.3, width: 0.2, height: 0.16, label: 'Triceratops · 9m long'),
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
                  child: AnimatedScale(
                    scale: isRevealed ? 1.0 : 0.9,
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
                                color: AppColors.giantsLeaf.withValues(alpha: 0.8),
                                fontSize: size.height * 0.014,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: AppColors.giantsLeaf.withValues(alpha: 0.5),
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
    this.isRevealed = false,
  });

  final int creatureIndex;
  final Color glowColor;
  final bool isRevealed;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path path = switch (creatureIndex) {
      0 => _buildTRexPath(w, h),
      1 => _buildArgentinosaurusPath(w, h),
      _ => _buildTriceratopsPath(w, h),
    };

    if (isRevealed) {
      // Bright glow behind silhouette
      final Paint glowPaint = Paint()
        ..color = glowColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawPath(path, glowPaint);

      // Silhouette fill — slightly lighter when revealed
      final Paint fillPaint = Paint()
        ..color = const Color(0xff0f2010)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Bright edge highlight
      final Paint edgePaint = Paint()
        ..color = glowColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawPath(path, edgePaint);
    } else {
      // Dark shadow silhouette — always visible
      final Paint shadowPaint = Paint()
        ..color = const Color(0xff080e05).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawPath(path, shadowPaint);

      final Paint fillPaint = Paint()
        ..color = const Color(0xff0a1508).withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }
  }

  Path _buildTRexPath(double w, double h) {
    final Path path = Path();
    // T-Rex facing right: head right, tail left, standing upright
    // Start at back foot, trace clockwise
    path.moveTo(w * 0.30, h * 0.95); // back foot right
    path.lineTo(w * 0.32, h * 0.65); // back leg up
    path.lineTo(w * 0.35, h * 0.58); // hip
    path.quadraticBezierTo(w * 0.40, h * 0.50, w * 0.45, h * 0.45); // back curve
    path.lineTo(w * 0.50, h * 0.38); // upper back
    path.lineTo(w * 0.55, h * 0.30); // neck base
    path.quadraticBezierTo(w * 0.60, h * 0.22, w * 0.65, h * 0.18); // neck
    path.lineTo(w * 0.75, h * 0.12); // head top
    path.lineTo(w * 0.82, h * 0.15); // snout
    path.lineTo(w * 0.80, h * 0.22); // jaw
    path.lineTo(w * 0.72, h * 0.24); // throat
    path.quadraticBezierTo(w * 0.65, h * 0.28, w * 0.58, h * 0.35); // neck down
    path.lineTo(w * 0.56, h * 0.40); // chest
    path.lineTo(w * 0.58, h * 0.43); // tiny arm
    path.lineTo(w * 0.56, h * 0.46); // arm back
    path.lineTo(w * 0.52, h * 0.50); // belly
    path.quadraticBezierTo(w * 0.48, h * 0.58, w * 0.45, h * 0.62); // lower belly
    path.lineTo(w * 0.44, h * 0.65); // front hip
    path.lineTo(w * 0.42, h * 0.95); // front foot
    path.lineTo(w * 0.38, h * 0.95); // front foot inner
    path.lineTo(w * 0.40, h * 0.68); // front leg up
    path.lineTo(w * 0.35, h * 0.65); // crotch
    path.lineTo(w * 0.28, h * 0.95); // back foot inner
    path.close();
    // Tail as separate fill
    path.moveTo(w * 0.35, h * 0.55);
    path.quadraticBezierTo(w * 0.25, h * 0.48, w * 0.12, h * 0.42);
    path.lineTo(w * 0.05, h * 0.40); // tail tip
    path.lineTo(w * 0.12, h * 0.46);
    path.quadraticBezierTo(w * 0.25, h * 0.54, w * 0.33, h * 0.60);
    path.close();
    return path;
  }

  Path _buildArgentinosaurusPath(double w, double h) {
    final Path path = Path();
    // Sauropod facing right: long neck up-right, long tail left, 4 legs
    // Start at front foot, trace outline clockwise
    path.moveTo(w * 0.28, h * 0.95); // front left foot
    path.lineTo(w * 0.27, h * 0.70); // front leg up
    path.lineTo(w * 0.25, h * 0.60); // chest
    path.quadraticBezierTo(w * 0.22, h * 0.45, w * 0.18, h * 0.35); // neck base
    path.quadraticBezierTo(w * 0.15, h * 0.22, w * 0.14, h * 0.12); // neck curve
    path.lineTo(w * 0.16, h * 0.06); // head top
    path.lineTo(w * 0.20, h * 0.08); // head front
    path.lineTo(w * 0.19, h * 0.12); // jaw
    path.quadraticBezierTo(w * 0.20, h * 0.22, w * 0.24, h * 0.35); // neck back
    path.quadraticBezierTo(w * 0.28, h * 0.42, w * 0.32, h * 0.48); // shoulder
    path.quadraticBezierTo(w * 0.42, h * 0.40, w * 0.52, h * 0.42); // back ridge
    path.quadraticBezierTo(w * 0.60, h * 0.44, w * 0.65, h * 0.48); // rear back
    path.lineTo(w * 0.68, h * 0.55); // hip
    path.lineTo(w * 0.70, h * 0.70); // back leg
    path.lineTo(w * 0.72, h * 0.95); // back right foot
    path.lineTo(w * 0.68, h * 0.95); // back right foot inner
    path.lineTo(w * 0.66, h * 0.72); // back leg inner
    path.lineTo(w * 0.64, h * 0.62); // under hip
    // Tail going right
    path.quadraticBezierTo(w * 0.75, h * 0.55, w * 0.85, h * 0.48);
    path.lineTo(w * 0.95, h * 0.44); // tail tip
    path.lineTo(w * 0.85, h * 0.52); // tail underside
    path.quadraticBezierTo(w * 0.75, h * 0.60, w * 0.64, h * 0.66);
    // Back left leg
    path.lineTo(w * 0.62, h * 0.95); // back left foot
    path.lineTo(w * 0.58, h * 0.95);
    path.lineTo(w * 0.60, h * 0.68);
    // Belly
    path.quadraticBezierTo(w * 0.48, h * 0.62, w * 0.36, h * 0.64);
    path.lineTo(w * 0.32, h * 0.70); // front hip
    path.lineTo(w * 0.34, h * 0.95); // front right foot
    path.lineTo(w * 0.30, h * 0.95);
    path.lineTo(w * 0.30, h * 0.72);
    path.lineTo(w * 0.26, h * 0.66);
    path.lineTo(w * 0.24, h * 0.95); // back to start
    path.close();
    return path;
  }

  Path _buildTriceratopsPath(double w, double h) {
    final Path path = Path();
    // Triceratops facing right: big frill, horns, stocky body, short tail
    path.moveTo(w * 0.25, h * 0.95); // front foot
    path.lineTo(w * 0.24, h * 0.72); // front leg
    path.lineTo(w * 0.22, h * 0.62); // chest
    path.lineTo(w * 0.18, h * 0.50); // neck
    // Frill (the big bony shield)
    path.lineTo(w * 0.12, h * 0.38);
    path.quadraticBezierTo(w * 0.08, h * 0.28, w * 0.10, h * 0.20);
    path.lineTo(w * 0.15, h * 0.14); // frill top
    path.lineTo(w * 0.22, h * 0.12);
    path.lineTo(w * 0.28, h * 0.16); // frill right edge
    // Horns
    path.lineTo(w * 0.32, h * 0.06); // top horn
    path.lineTo(w * 0.34, h * 0.16);
    path.lineTo(w * 0.38, h * 0.08); // second horn
    path.lineTo(w * 0.40, h * 0.18);
    // Nose/beak
    path.lineTo(w * 0.46, h * 0.22); // nose horn
    path.lineTo(w * 0.44, h * 0.28); // snout
    path.lineTo(w * 0.40, h * 0.34); // mouth
    path.lineTo(w * 0.35, h * 0.40); // jaw
    // Under jaw back to body
    path.quadraticBezierTo(w * 0.30, h * 0.50, w * 0.28, h * 0.58);
    path.lineTo(w * 0.30, h * 0.68);
    path.lineTo(w * 0.32, h * 0.95); // front right foot
    path.lineTo(w * 0.36, h * 0.95);
    path.lineTo(w * 0.35, h * 0.70);
    // Belly
    path.quadraticBezierTo(w * 0.45, h * 0.68, w * 0.55, h * 0.65);
    path.quadraticBezierTo(w * 0.62, h * 0.63, w * 0.65, h * 0.60);
    // Back
    path.quadraticBezierTo(w * 0.60, h * 0.48, w * 0.50, h * 0.44);
    path.quadraticBezierTo(w * 0.40, h * 0.42, w * 0.30, h * 0.44);
    // Back to hip from top
    path.moveTo(w * 0.65, h * 0.60);
    path.lineTo(w * 0.66, h * 0.70);
    path.lineTo(w * 0.68, h * 0.95); // back right foot
    path.lineTo(w * 0.72, h * 0.95);
    path.lineTo(w * 0.70, h * 0.72);
    path.lineTo(w * 0.68, h * 0.62);
    // Tail
    path.quadraticBezierTo(w * 0.78, h * 0.55, w * 0.85, h * 0.50);
    path.lineTo(w * 0.88, h * 0.48);
    path.lineTo(w * 0.85, h * 0.54);
    path.quadraticBezierTo(w * 0.78, h * 0.60, w * 0.70, h * 0.65);
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
