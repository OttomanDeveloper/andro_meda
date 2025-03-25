import 'package:safeandromeda/core/hooks/hooks.dart';

class FastSecureCards extends StatelessWidget {
  const FastSecureCards({
    super.key,
    this.isMobile = false,
    this.isTablet = false,
  });

  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    late final double padding;
    late final double widgetPadding;
    if (isMobile) {
      padding = size.height * 0.01;
      widgetPadding = size.width * 0.04;
    } else {
      if (isTablet) {
        padding = size.height * 0.015;
        widgetPadding = size.width * 0.04;
      } else {
        padding = size.height * 0.02;
        widgetPadding = size.width * 0.04;
      }
    }

    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration: const BoxDecoration(
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
    super.key,
    required this.title,
    required this.icon,
    required this.isTablet,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    // Variables
    late final double space;
    late final double rounded;
    late final double iconSize;
    late final double textSize;
    late final double paddingVertical;
    late final double paddingHorizontal;

    if (isMobile) {
      space = size.width * 0.02;
      rounded = size.height * 0.008;
      iconSize = size.height * 0.021;
      textSize = size.height * 0.017;
      paddingVertical = size.height * 0.011;
      paddingHorizontal = size.width * 0.05;
    } else {
      if (isTablet) {
        space = size.width * 0.015;
        rounded = size.height * 0.01;
        textSize = size.height * 0.02;
        iconSize = size.height * 0.024;
        paddingVertical = size.height * 0.012;
        paddingHorizontal = size.width * 0.035;
      } else {
        space = size.width * 0.009;
        rounded = size.height * 0.01;
        iconSize = size.height * 0.025;
        textSize = size.height * 0.021;
        paddingVertical = size.height * 0.01;
        paddingHorizontal = size.width * 0.025;
      }
    }

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
          color: AppColors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: AppColors.white),
          SizedBox(width: space),
          Text(
            title,
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
