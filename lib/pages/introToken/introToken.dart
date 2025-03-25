import 'package:safeandromeda/core/hooks/hooks.dart';

class IntroToken extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Responsive(
      mobile: _mobile(size),
      tablet: _tablet(size),
      desktop: _desktop(size),
    );
  }

  Widget _whatLine(Size size) {
    return Container(
      width: size.width * 0.13,
      height: size.height * 0.005,
      color: AppColors.whatBlueText,
    );
  }

  Widget _desktop(Size size) {
    return Container(
      width: size.width,
      color: AppColors.whatMainBG,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.08,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                left: size.width * 0.06,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _whatLine(size),
                      SizedBox(width: size.width * 0.015),
                      Text(
                        "ANDRONOMICS",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: AppColors.whatBlueText,
                          fontSize: size.height * 0.027,
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      _whatLine(size),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    "${AppText.tokenIntroTitle}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.russoOne(
                      color: AppColors.white,
                      fontSize: size.height * 0.03,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  IntroText(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppAsset.introWhat,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tablet(Size size) {
    return Container(
      width: size.width,
      color: AppColors.whatMainBG,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.05,
        horizontal: size.width * 0.08,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _whatLine(size),
              SizedBox(width: size.width * 0.03),
              Text(
                "ANDRONOMICS",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.whatBlueText,
                  fontSize: size.height * 0.03,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              _whatLine(size),
            ],
          ),
          SizedBox(height: size.height * 0.025),
          Text(
            "${AppText.tokenIntroTitle}",
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.037,
            ),
          ),
          SizedBox(height: size.height * 0.045),
          IntroText(),
        ],
      ),
    );
  }

  Widget _mobile(Size size) {
    return Container(
      width: size.width,
      color: AppColors.whatMainBG,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.05,
        horizontal: size.width * 0.08,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _whatLine(size),
              SizedBox(width: size.width * 0.03),
              Text(
                "ANDRONOMICS",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.whatBlueText,
                  fontSize: size.height * 0.022,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              _whatLine(size),
            ],
          ),
          SizedBox(height: size.height * 0.025),
          Text(
            "${AppText.tokenIntroTitle}",
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.027,
            ),
          ),
          SizedBox(height: size.height * 0.023),
          IntroText(),
        ],
      ),
    );
  }
}
