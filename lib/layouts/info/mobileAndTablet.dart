import 'package:safeandromeda/core/hooks/hooks.dart';

class InfoTablet extends StatelessWidget {
  final bool isMobile;
  const InfoTablet({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool fastSecureMobile = isMobile ? true : false;
    bool fastSecureTablet = isMobile ? false : true;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FastSecureCards(
          isMobile: fastSecureMobile,
          isTablet: fastSecureTablet,
        ),
        Container(
          color: AppColors.parent,
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.035,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAsset.newDesign,
                fit: BoxFit.cover,
                height: isMobile ? size.height * 0.22 : size.height * 0.3,
              ),
              SizedBox(height: size.height * 0.025),
              Text(
                AppText.infoTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize:
                      isMobile ? size.height * 0.026 : size.height * 0.035,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(
                  height: isMobile ? size.height * 0.016 : size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                ),
                child: InfoText(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
