import 'package:safeandromeda/core/hooks/hooks.dart';

/// Desktop (>=1100) portfolio layout: full-size card.
class PortfolioDesktopLayout extends StatelessWidget {
  const PortfolioDesktopLayout({super.key, required this.size});

  final Size size; // screen size passed through to PortfolioContent

  /// Renders the shared card at full scale (1.0).
  @override
  Widget build(BuildContext context) {
    return PortfolioContent(size: size, scaleFactor: 1.0);
  }
}
