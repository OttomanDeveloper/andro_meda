import 'package:safeandromeda/core/hooks/hooks.dart';

/// Desktop (>=1100) era wrapper. Passthrough for now; the hook for any
/// desktop-only era chrome.
class EraDesktopLayout extends StatelessWidget {
  const EraDesktopLayout({super.key, required this.child});

  final Widget child; // the era widget to render

  /// Returns the era unchanged.
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
