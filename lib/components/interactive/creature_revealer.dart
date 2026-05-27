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
