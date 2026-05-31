import 'package:safeandromeda/core/hooks/hooks.dart';

/// Mobile (<650) era wrapper. Passthrough for now; the hook for any
/// mobile-only era chrome.
class EraMobileLayout extends StatelessWidget {
  const EraMobileLayout({super.key, required this.child});

  final Widget child; // the era widget to render

  /// Returns the era unchanged.
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
