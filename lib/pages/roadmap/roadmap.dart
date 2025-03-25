import 'package:safeandromeda/core/hooks/hooks.dart';

class RoadMap extends StatelessWidget {
  const RoadMap({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Responsive(
      mobile: _mobile(size),
      tablet: _tablet(size),
      desktop: _desktop(size),
    );
  }

  Widget _desktop(Size size) {
    return Container(
      width: size.width,
      color: AppColors.roadMapBG,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.05,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _line(size),
              SizedBox(width: size.width * 0.02),
              Text(
                "OUR VISION",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.teamText,
                  fontSize: size.height * 0.025,
                ),
              ),
              SizedBox(width: size.width * 0.02),
              _line(size),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "THE ROADMAP".toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.03,
            ),
          ),
          SizedBox(height: size.height * 0.06),
          Container(
            height: size.height * 0.7,
            padding: EdgeInsets.only(
              left: size.width * 0.04,
              right: size.width * 0.06,
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.07),
                          SvgPicture.asset(
                            AppAsset.galaxySVG,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
                  ],
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: RoadMapSteps(
                    quarter: "Q1 2021",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                Positioned(
                  top: size.height * 0.17,
                  right: 0.0,
                  child: RoadMapSteps(
                    quarter: "Q2 2021",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.75),
                  ),
                ),
                Positioned(
                  top: size.height * 0.34,
                  right: 0.0,
                  child: RoadMapSteps(
                    quarter: "Q3 2022",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.67),
                  ),
                ),
                Positioned(
                  top: size.height * 0.51,
                  right: 0.0,
                  child: RoadMapSteps(
                    quarter: "Q4 2022",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tablet(Size size) {
    return Container(
      width: size.width,
      color: AppColors.roadMapBG,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.03,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _line(size),
              SizedBox(width: size.width * 0.03),
              Text(
                "OUR VISION",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.teamText,
                  fontSize: size.height * 0.022,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              _line(size),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "THE ROADMAP".toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.025,
            ),
          ),
          SizedBox(height: size.height * 0.05),
          SizedBox(
            height: size.height * 0.7,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  AppAsset.galaxySVG,
                ),
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00222020),
                        Color(0x83222020),
                        Color(0x83222020),
                        Color(0x00222020),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  child: RoadMapSteps(
                    isTablet: true,
                    quarter: "Q1 2021",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                Positioned(
                  top: size.height * 0.17,
                  child: RoadMapSteps(
                    isTablet: true,
                    quarter: "Q2 2021",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.77),
                  ),
                ),
                Positioned(
                  top: size.height * 0.34,
                  child: RoadMapSteps(
                    isTablet: true,
                    quarter: "Q3 2022",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.72),
                  ),
                ),
                Positioned(
                  top: size.height * 0.51,
                  child: RoadMapSteps(
                    isTablet: true,
                    quarter: "Q4 2022",
                    title: "Releasing Soon ...",
                    description: "",
                    titleColor: AppColors.white.withValues(alpha: 0.67),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobile(Size size) {
    return Container(
      width: size.width,
      color: AppColors.roadMapBG,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.03,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _line(size),
              SizedBox(width: size.width * 0.03),
              Text(
                "OUR VISION",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.teamText,
                  fontSize: size.height * 0.022,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              _line(size),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "THE ROADMAP".toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.025,
            ),
          ),
          SizedBox(height: size.height * 0.035),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoadMapSteps(
                  isMobile: true,
                  quarter: "Q1 2021",
                  title: "Releasing Soon ...",
                  description: "",
                  titleColor: AppColors.white.withValues(alpha: 0.85),
                ),
                RoadMapSteps(
                  isMobile: true,
                  quarter: "Q2 2021",
                  title: "Releasing Soon ...",
                  description: "",
                  titleColor: AppColors.white.withValues(alpha: 0.77),
                ),
                RoadMapSteps(
                  isMobile: true,
                  quarter: "Q3 2022",
                  title: "Releasing Soon ...",
                  description: "",
                  titleColor: AppColors.white.withValues(alpha: 0.72),
                ),
                RoadMapSteps(
                  isMobile: true,
                  quarter: "Q4 2022",
                  title: "Releasing Soon ...",
                  description: "",
                  titleColor: AppColors.white.withValues(alpha: 0.67),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(Size size) {
    return Container(
      height: size.height * 0.002,
      width: size.width * 0.09,
      color: AppColors.roadMapText,
    );
  }
}

class RoadMapSteps extends StatelessWidget {
  const RoadMapSteps({
    super.key,
    required this.title,
    required this.quarter,
    required this.titleColor,
    required this.description,
    this.isMobile = false,
    this.isTablet = false,
  });

  final String title;
  final String quarter;
  final Color titleColor;
  final String description;
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quarter,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
            fontSize: isMobile ? size.height * 0.016 : size.height * 0.02,
          ),
        ),
        SizedBox(width: isMobile ? size.width * 0.025 : size.width * 0.01),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(
            isMobile ? size.height * 0.007 : size.height * 0.013,
          ),
        ),
        SizedBox(width: isMobile ? size.width * 0.025 : size.width * 0.01),
        SizedBox(
          width: isMobile
              ? size.width * 0.6
              : isTablet
                  ? size.width * 0.36
                  : size.width * 0.36,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  color: titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize:
                      isMobile ? size.height * 0.019 : size.height * 0.024,
                ),
              ),
              SizedBox(height: size.height * 0.005),
              Text(
                description,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontSize:
                      isMobile ? size.height * 0.0165 : size.height * 0.018,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
