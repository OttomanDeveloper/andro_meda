import 'package:safeandromeda/core/hooks/hooks.dart';

abstract class AppSettings {
  const AppSettings._();

  static const String appName = 'Chronos';
  static const String shortName = 'Chronos';
  static const int eraCount = 9;
  static const double eraHeightFactor = 1.5;

  static int particleCount(BuildContext context, {required int desktop}) {
    if (Responsive.isMobile(context)) return (desktop * 0.4).round();
    if (Responsive.isTablet(context)) return (desktop * 0.7).round();
    return desktop;
  }
}
