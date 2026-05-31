import 'package:safeandromeda/core/hooks/hooks.dart';

/// Mobile (<650) portfolio layout: card scaled down to 0.65.
class PortfolioMobileLayout extends StatelessWidget {
  const PortfolioMobileLayout({super.key, required this.size});

  final Size size; // screen size passed through to PortfolioContent

  /// Renders the shared card at 0.65 scale.
  @override
  Widget build(BuildContext context) {
    return PortfolioContent(size: size, scaleFactor: 0.65);
  }
}
