import 'package:safeandromeda/core/hooks/hooks.dart';

Widget tablet(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  var onClick = context.read<NavProvider>();
  return Container(
    width: size.width,
    height: size.height,
    decoration: BoxDecoration(
      color: AppColors.parent,
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(AppAsset.space1),
      ),
    ),
    child: Scaffold(
      key: onClick.globalKey,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.parent,
      drawerScrimColor: AppColors.parent,
      drawer: sideBar(context, onClick),
      appBar: AppBar(
        leading: SizedBox.shrink(),
        backgroundColor: AppColors.parent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: size.width * 0.04),
            Image.asset(
              AppAsset.logo,
              fit: BoxFit.cover,
              height: size.height * 0.032,
            ),
            SizedBox(width: size.width * 0.015),
            Text(
              "${AppSettings.shortName}".toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.russoOne(
                color: AppColors.blue,
                fontSize: size.height * 0.025,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (onClick.globalKey.currentState!.isDrawerOpen) {
                onClick.globalKey.currentState!.openEndDrawer();
              } else {
                onClick.globalKey.currentState!.openDrawer();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_outlined,
                  size: size.height * 0.025,
                  color: AppColors.white.withOpacity(0.75),
                ),
                SizedBox(width: size.width * 0.006),
                Text(
                  "Menu",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: size.height * 0.019,
                    color: AppColors.white.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.04),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: size.height * 0.03,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: size.height * 0.007),
          Text(
            "${AppSettings.shortName}".toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.055,
            ),
          ),
          SizedBox(height: size.height * 0.016),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07,
            ),
            child: Text(
              "${AppText.home}",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.white.withOpacity(0.8),
                fontSize: size.height * 0.023,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.035),
          buySellButtons(
            context,
            rounded: size.height * 0.01,
            textSize: size.height * 0.02,
            iconSize: size.height * 0.033,
            buttonSpace: size.width * 0.02,
            iconTextSpace: size.width * 0.01,
            paddingVertical: size.height * 0.018,
            paddingHorizontal: size.width * 0.07,
          ),
          SizedBox(height: size.height * 0.035),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(size.height * 0.015),
            ),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.006,
              horizontal: size.width * 0.015,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcons(
                  isTablet: true,
                  asset: AppAsset.instagram,
                  onTap: () => openLink(AppLinks.instagram),
                ),
                SizedBox(width: size.width * 0.02),
                SocialIcons(
                  isTablet: true,
                  asset: AppAsset.youtube,
                  onTap: () => openLink(AppLinks.youtube),
                ),
                SizedBox(width: size.width * 0.02),
                SocialIcons(
                  isTablet: true,
                  asset: AppAsset.discord,
                  onTap: () => openLink(AppLinks.discord),
                ),
                SizedBox(width: size.width * 0.02),
                SocialIcons(
                  isTablet: true,
                  asset: AppAsset.telegram,
                  onTap: () => openLink(AppLinks.telegram),
                ),
                SizedBox(width: size.width * 0.02),
                SocialIcons(
                  isTablet: true,
                  asset: AppAsset.twitter,
                  onTap: () => openLink(AppLinks.twitter),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
