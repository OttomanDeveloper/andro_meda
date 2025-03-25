import 'package:safeandromeda/core/hooks/hooks.dart';

Widget mobile(BuildContext context) {
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
        leading: IconButton(
          onPressed: () {
            if (onClick.globalKey.currentState!.isDrawerOpen) {
              onClick.globalKey.currentState!.openEndDrawer();
            } else {
              onClick.globalKey.currentState!.openDrawer();
            }
          },
          icon: Icon(Icons.menu_outlined),
          iconSize: size.height * 0.025,
          color: AppColors.white.withOpacity(0.75),
        ),
        backgroundColor: AppColors.parent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: size.width * 0.14),
            Image.asset(
              AppAsset.logo,
              fit: BoxFit.cover,
              height: size.height * 0.027,
            ),
            SizedBox(width: size.width * 0.028),
            Text(
              "${AppSettings.shortName}".toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.russoOne(
                color: AppColors.blue,
                fontSize: size.height * 0.023,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: size.height * 0.025,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: size.height * 0.006),
          Text(
            "${AppSettings.shortName}".toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.045,
            ),
          ),
          SizedBox(height: size.height * 0.012),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07,
            ),
            child: Text(
              "${AppText.home}",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: size.height * 0.025,
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          buySellButtons(
            context,
            rounded: size.height * 0.015,
            iconSize: size.height * 0.03,
            textSize: size.height * 0.018,
            buttonSpace: size.width * 0.02,
            iconTextSpace: size.width * 0.02,
            paddingVertical: size.height * 0.02,
            paddingHorizontal: size.width * 0.07,
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(size.height * 0.015),
            ),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.008,
              horizontal: size.width * 0.03,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcons(
                  isMobile: true,
                  asset: AppAsset.instagram,
                  onTap: () => openLink(AppLinks.instagram),
                ),
                SizedBox(width: size.width * 0.035),
                SocialIcons(
                  isMobile: true,
                  asset: AppAsset.youtube,
                  onTap: () => openLink(AppLinks.youtube),
                ),
                SizedBox(width: size.width * 0.035),
                SocialIcons(
                  isMobile: true,
                  asset: AppAsset.discord,
                  onTap: () => openLink(AppLinks.discord),
                ),
                SizedBox(width: size.width * 0.035),
                SocialIcons(
                  isMobile: true,
                  asset: AppAsset.telegram,
                  onTap: () => openLink(AppLinks.telegram),
                ),
                SizedBox(width: size.width * 0.035),
                SocialIcons(
                  isMobile: true,
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
