import 'package:safeandromeda/core/hooks/hooks.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: InfoTablet(isMobile: true),
      tablet: InfoTablet(isMobile: false),
      desktop: InfoDesktop(),
    );
  }
}
