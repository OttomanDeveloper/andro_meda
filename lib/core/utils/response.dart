import 'package:safeandromeda/core/hooks/hooks.dart';

/// Picks one of three child widgets by screen width. Breakpoints: <650 mobile,
/// 650..1099 tablet, >=1100 desktop.
class Responsive extends StatelessWidget {
  final Widget mobile; // shown when width < 650
  final Widget tablet; // shown when 650 <= width < 1100
  final Widget desktop; // shown when width >= 1100

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// True when viewport width is below the tablet breakpoint (< 650).
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  /// True when viewport width is in the tablet band (650..1099).
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 650;

  /// True when viewport width is at or above the desktop breakpoint (>= 1100).
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  /// Mobile and tablet are touch-first; only desktop gets hover affordances.
  static bool isTouch(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100;

  /// Builds the variant matching the current constraints via LayoutBuilder.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth >= 650) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
