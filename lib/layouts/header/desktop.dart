import 'package:safeandromeda/core/hooks/hooks.dart';

Widget desktop(BuildContext context) {
  final Size size = MediaQuery.sizeOf(context);
  final NavProvider onClick = context.read<NavProvider>();
  return Container(
    width: size.width,
    height: size.height,
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(AppAsset.space1),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: size.width * 0.03),
            Image.asset(
              AppAsset.logo,
              fit: BoxFit.cover,
              height: size.height * 0.032,
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              AppSettings.shortName.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.russoOne(
                color: AppColors.blue,
                fontSize: size.height * 0.023,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavButton(
                  title: "Home",
                  onTap: () => onClick.scroll(index: 0),
                ),
                NavButton(
                  title: "Token Info",
                  onTap: () => onClick.scroll(index: 2),
                ),
                NavButton(
                  title: "Roadmap",
                  onTap: () => onClick.scroll(index: 3),
                ),
                NavButton(
                  title: "Team",
                  onTap: () => onClick.scroll(index: 4),
                ),
                SizedBox(width: size.width * 0.01),
                MaterialButton(
                  color: AppColors.white,
                  hoverColor: AppColors.black.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.height * 0.01),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.006,
                    horizontal: size.width * 0.012,
                  ),
                  onPressed: () => openLink(AppLinks.telegram),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAsset.telegram,
                        height: size.height * 0.02,
                      ),
                      SizedBox(width: size.width * 0.005),
                      Text(
                        "Join Telegram",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: size.height * 0.015,
                          color: AppColors.black.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: size.width * 0.03),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: const Color(0xffB7D8FF),
                  fontSize: size.height * 0.03,
                ),
              ),
              SizedBox(height: size.height * 0.002),
              Text(
                AppSettings.shortName.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.russoOne(
                  color: AppColors.white,
                  fontSize: size.height * 0.07,
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.15,
                ),
                child: Text(
                  AppText.home,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: size.height * 0.022,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.035),
              buySellButtons(
                context,
                rounded: size.height * 0.005,
                iconSize: size.height * 0.035,
                textSize: size.height * 0.018,
                buttonSpace: size.width * 0.013,
                iconTextSpace: size.width * 0.005,
                paddingVertical: size.height * 0.013,
                paddingHorizontal: size.width * 0.02,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
