import 'package:safeandromeda/core/hooks/hooks.dart';

/// App-wide constants and tuning values for the timeline experience.
abstract class AppSettings {
  const AppSettings._();

  static const String appName = 'Chronos'; // full app name
  static const String shortName = 'Chronos'; // short label for tight UI spots
  static const int eraCount = 9; // number of timeline eras
  static const double eraHeightFactor =
      2.0; // each era is this many viewport heights tall

  /// Particle budget scaled down on smaller screens to keep painters cheap.
  /// [desktop] is the full count; mobile gets 40%, tablet 70%, desktop 100%.
  static int particleCount(BuildContext context, {required int desktop}) {
    if (Responsive.isMobile(context)) return (desktop * 0.4).round();
    if (Responsive.isTablet(context)) return (desktop * 0.7).round();
    return desktop;
  }
}
