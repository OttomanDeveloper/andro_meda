import 'package:safeandromeda/core/hooks/hooks.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: InfoTablet(isMobile: true),
      tablet: InfoTablet(isMobile: false),
      desktop: InfoDesktop(),
    );
  }
}
