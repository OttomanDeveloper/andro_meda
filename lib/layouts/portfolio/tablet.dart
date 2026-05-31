import 'package:safeandromeda/core/hooks/hooks.dart';

/// Tablet (650..1100) portfolio layout: card scaled to 0.8.
class PortfolioTabletLayout extends StatelessWidget {
  const PortfolioTabletLayout({super.key, required this.size});

  final Size size; // screen size passed through to PortfolioContent

  /// Renders the shared card at 0.8 scale.
  @override
  Widget build(BuildContext context) {
    return PortfolioContent(size: size, scaleFactor: 0.8);
  }
}
