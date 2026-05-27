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

    switch (creatureIndex) {
      case 0:
        _paintTRex(canvas, w, h);
      case 1:
        _paintArgentinosaurus(canvas, w, h);
      default:
        _paintTriceratops(canvas, w, h);
    }
  }

  void _fillShape(Canvas canvas, Path path) {
    if (isRevealed) {
      canvas.drawPath(path, Paint()
        ..color = glowColor.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15));
      canvas.drawPath(path, Paint()..color = const Color(0xff0d1a0a));
      canvas.drawPath(path, Paint()
        ..color = glowColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    } else {
      canvas.drawPath(path, Paint()
        ..color = const Color(0xff080e05).withValues(alpha: 0.7));
    }
  }

  void _fillOval(Canvas canvas, Rect rect) {
    final Path p = Path()..addOval(rect);
    _fillShape(canvas, p);
  }

  void _fillRect(Canvas canvas, Rect rect) {
    final Path p = Path()..addRect(rect);
    _fillShape(canvas, p);
  }

  void _paintTRex(Canvas canvas, double w, double h) {
    // Body — large horizontal oval
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.45, h * 0.52), width: w * 0.4, height: h * 0.28));
    // Head — smaller oval, tilted forward-right
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.72, h * 0.25), width: w * 0.22, height: h * 0.15));
    // Jaw — narrow rect under head
    _fillRect(canvas, Rect.fromLTWH(w * 0.66, h * 0.30, w * 0.12, h * 0.05));
    // Neck — connecting oval
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.58, h * 0.38), width: w * 0.15, height: h * 0.2));
    // Right leg (back)
    _fillRect(canvas, Rect.fromLTWH(w * 0.34, h * 0.58, w * 0.07, h * 0.38));
    // Right foot
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.375, h * 0.94), width: w * 0.1, height: h * 0.06));
    // Left leg (front)
    _fillRect(canvas, Rect.fromLTWH(w * 0.48, h * 0.58, w * 0.07, h * 0.35));
    // Left foot
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.515, h * 0.92), width: w * 0.1, height: h * 0.06));
    // Tiny arm
    _fillRect(canvas, Rect.fromLTWH(w * 0.58, h * 0.42, w * 0.06, h * 0.04));
    // Tail — tapers left
    final Path tail = Path();
    tail.moveTo(w * 0.28, h * 0.45);
    tail.quadraticBezierTo(w * 0.15, h * 0.40, w * 0.03, h * 0.38);
    tail.lineTo(w * 0.03, h * 0.42);
    tail.quadraticBezierTo(w * 0.15, h * 0.46, w * 0.28, h * 0.55);
    tail.close();
    _fillShape(canvas, tail);
    // Eye
    if (isRevealed) {
      canvas.drawCircle(Offset(w * 0.76, h * 0.23), 2.5,
        Paint()..color = glowColor.withValues(alpha: 0.8));
    }
  }

  void _paintArgentinosaurus(Canvas canvas, double w, double h) {
    // Massive body — wide oval
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.55), width: w * 0.45, height: h * 0.25));
    // Neck — tall narrow oval going up-left
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.22, h * 0.32), width: w * 0.1, height: h * 0.35));
    // Small head at top of neck
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.18, h * 0.12), width: w * 0.09, height: h * 0.07));
    // Front left leg
    _fillRect(canvas, Rect.fromLTWH(w * 0.3, h * 0.62, w * 0.06, h * 0.32));
    // Front right leg
    _fillRect(canvas, Rect.fromLTWH(w * 0.38, h * 0.62, w * 0.06, h * 0.30));
    // Back left leg
    _fillRect(canvas, Rect.fromLTWH(w * 0.56, h * 0.62, w * 0.06, h * 0.32));
    // Back right leg
    _fillRect(canvas, Rect.fromLTWH(w * 0.63, h * 0.62, w * 0.06, h * 0.30));
    // 4 feet
    for (final double fx in [0.33, 0.41, 0.59, 0.66]) {
      _fillOval(canvas, Rect.fromCenter(
        center: Offset(w * fx, h * 0.94), width: w * 0.08, height: h * 0.05));
    }
    // Tail — tapers right
    final Path tail = Path();
    tail.moveTo(w * 0.7, h * 0.48);
    tail.quadraticBezierTo(w * 0.82, h * 0.42, w * 0.95, h * 0.38);
    tail.lineTo(w * 0.95, h * 0.42);
    tail.quadraticBezierTo(w * 0.82, h * 0.48, w * 0.7, h * 0.58);
    tail.close();
    _fillShape(canvas, tail);
    // Eye
    if (isRevealed) {
      canvas.drawCircle(Offset(w * 0.2, h * 0.11), 2,
        Paint()..color = glowColor.withValues(alpha: 0.8));
    }
  }

  void _paintTriceratops(Canvas canvas, double w, double h) {
    // Stocky body — wide low oval
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.58), width: w * 0.5, height: h * 0.24));
    // Head — medium oval, front-left
    _fillOval(canvas, Rect.fromCenter(
      center: Offset(w * 0.22, h * 0.42), width: w * 0.18, height: h * 0.16));
    // Frill — semi-circle behind head
    final Path frill = Path();
    frill.moveTo(w * 0.15, h * 0.35);
    frill.quadraticBezierTo(w * 0.18, h * 0.2, w * 0.3, h * 0.22);
    frill.quadraticBezierTo(w * 0.35, h * 0.28, w * 0.32, h * 0.38);
    frill.quadraticBezierTo(w * 0.25, h * 0.42, w * 0.15, h * 0.38);
    frill.close();
    _fillShape(canvas, frill);
    // Top horn (long)
    final Path horn1 = Path();
    horn1.moveTo(w * 0.2, h * 0.35);
    horn1.lineTo(w * 0.16, h * 0.15);
    horn1.lineTo(w * 0.22, h * 0.34);
    horn1.close();
    _fillShape(canvas, horn1);
    // Second horn
    final Path horn2 = Path();
    horn2.moveTo(w * 0.26, h * 0.34);
    horn2.lineTo(w * 0.24, h * 0.16);
    horn2.lineTo(w * 0.29, h * 0.33);
    horn2.close();
    _fillShape(canvas, horn2);
    // Nose horn (small)
    final Path noseHorn = Path();
    noseHorn.moveTo(w * 0.14, h * 0.40);
    noseHorn.lineTo(w * 0.10, h * 0.34);
    noseHorn.lineTo(w * 0.15, h * 0.38);
    noseHorn.close();
    _fillShape(canvas, noseHorn);
    // 4 legs
    _fillRect(canvas, Rect.fromLTWH(w * 0.32, h * 0.64, w * 0.07, h * 0.28));
    _fillRect(canvas, Rect.fromLTWH(w * 0.4, h * 0.64, w * 0.07, h * 0.26));
    _fillRect(canvas, Rect.fromLTWH(w * 0.57, h * 0.64, w * 0.07, h * 0.28));
    _fillRect(canvas, Rect.fromLTWH(w * 0.65, h * 0.64, w * 0.07, h * 0.26));
    // 4 feet
    for (final double fx in [0.355, 0.435, 0.605, 0.685]) {
      _fillOval(canvas, Rect.fromCenter(
        center: Offset(w * fx, h * 0.93), width: w * 0.09, height: h * 0.05));
    }
    // Short tail
    final Path tail = Path();
    tail.moveTo(w * 0.72, h * 0.52);
    tail.quadraticBezierTo(w * 0.82, h * 0.48, w * 0.88, h * 0.46);
    tail.lineTo(w * 0.88, h * 0.50);
    tail.quadraticBezierTo(w * 0.82, h * 0.54, w * 0.72, h * 0.60);
    tail.close();
    _fillShape(canvas, tail);
    // Eye
    if (isRevealed) {
      canvas.drawCircle(Offset(w * 0.18, h * 0.40), 2,
        Paint()..color = glowColor.withValues(alpha: 0.8));
    }
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
