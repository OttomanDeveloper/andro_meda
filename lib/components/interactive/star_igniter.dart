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
      builder: (_, _StarIgniterProvider pro, _) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            final Random r = Random();
            pro.ignite(
              details.localPosition,
              3.0 + r.nextDouble() * 5.0,
            );
          },
          behavior: HitTestBehavior.translucent,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _IgnitedStarsPainter(
                stars: pro.ignitedStars,
                sizes: pro.ignitedSizes,
                progress: eraProgress,
              ),
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
