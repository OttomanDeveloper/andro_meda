import 'package:safeandromeda/core/hooks/hooks.dart';

/// Tablet (650..1100) era wrapper. Passthrough for now; the hook for any
/// tablet-only era chrome.
class EraTabletLayout extends StatelessWidget {
  const EraTabletLayout({super.key, required this.child});

  final Widget child; // the era widget to render

  /// Returns the era unchanged.
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
