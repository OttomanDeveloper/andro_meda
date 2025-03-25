import 'package:safeandromeda/core/hooks/hooks.dart';

class FastSecureCards extends StatelessWidget {
  const FastSecureCards({
    this.isMobile = false,
    this.isTablet = false,
  });

  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding = isMobile
        ? size.height * 0.01
        : isTablet
            ? size.height * 0.015
            : size.height * 0.02;
    double widgetPadding = isMobile
        ? size.width * 0.04
        : isTablet
            ? size.width * 0.04
            : size.width * 0.04;
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.whatBG1,
            AppColors.whatBG2,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IntroTokenTopButton(
            title: "Fast",
            isTablet: isTablet,
            isMobile: isMobile,
            icon: Icons.bolt_outlined,
          ),
          SizedBox(width: widgetPadding),
          IntroTokenTopButton(
            title: "Secure",
            isTablet: isTablet,
            isMobile: isMobile,
            icon: Icons.security_outlined,
          ),
          SizedBox(width: widgetPadding),
          IntroTokenTopButton(
            title: "Reward",
            isTablet: isTablet,
            isMobile: isMobile,
            icon: Icons.speed_outlined,
          ),
        ],
      ),
    );
  }
}

class IntroTokenTopButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isTablet;
  final bool isMobile;
  const IntroTokenTopButton({
    required this.title,
    required this.icon,
    required this.isTablet,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Variables
    double paddingVertical = isMobile
        ? size.height * 0.011
        : isTablet
            ? size.height * 0.012
            : size.height * 0.01;
    double paddingHorizontal = isMobile
        ? size.width * 0.05
        : isTablet
            ? size.width * 0.035
            : size.width * 0.025;
    double space = isMobile
        ? size.width * 0.02
        : isTablet
            ? size.width * 0.015
            : size.width * 0.009;
    double rounded = isMobile
        ? size.height * 0.008
        : isTablet
            ? size.height * 0.01
            : size.height * 0.01;
    double iconSize = isMobile
        ? size.height * 0.021
        : isTablet
            ? size.height * 0.024
            : size.height * 0.025;
    double textSize = isMobile
        ? size.height * 0.017
        : isTablet
            ? size.height * 0.02
            : size.height * 0.021;
    // Widget Returning
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: AppColors.whatIconsBG,
        borderRadius: BorderRadius.circular(rounded),
        border: Border.all(
          color: AppColors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: AppColors.white,
          ),
          SizedBox(width: space),
          Text(
            "$title",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: textSize,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
