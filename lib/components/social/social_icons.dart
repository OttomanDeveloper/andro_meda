import 'package:safeandromeda/core/hooks/hooks.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({
    super.key,
    required this.asset,
    required this.onTap,
    this.isTablet = false,
    this.isMobile = false,
  });

  final String asset;
  final VoidCallback onTap;
  final bool isTablet;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    late final double iconSize;
    if (isTablet) {
      iconSize = size.height * 0.05;
    } else {
      if (isMobile) {
        iconSize = size.height * 0.045;
      } else {
        iconSize = size.height * 0.053;
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.004,
      ),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => onTap(),
        onHover: (value) {},
        child: SvgPicture.asset(
          asset,
          fit: BoxFit.cover,
          height: iconSize,
        ),
      ),
    );
  }
}
