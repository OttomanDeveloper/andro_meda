import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioReveal extends StatelessWidget {
  const PortfolioReveal({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Responsive(
      mobile: PortfolioMobileLayout(size: size),
      tablet: PortfolioTabletLayout(size: size),
      desktop: PortfolioDesktopLayout(size: size),
    );
  }
}
