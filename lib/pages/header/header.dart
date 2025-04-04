import 'package:safeandromeda/core/hooks/hooks.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: mobile(context),
      tablet: tablet(context),
      desktop: desktop(context),
    );
  }
}
