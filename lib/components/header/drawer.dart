import 'package:safeandromeda/core/hooks/hooks.dart';

Drawer sideBar(
  BuildContext context,
  NavProvider onClick,
) {
  final Size size = MediaQuery.sizeOf(context);
  return Drawer(
      child: Column(
    children: [
      SizedBox(height: size.height * 0.075),
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
              Icons.clear,
              color: AppColors.white,
              size: size.height * 0.027,
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              "Close",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: size.height * 0.024,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: size.height * 0.027),
      TabletNav(
        onTap: () {
          if (onClick.globalKey.currentState!.isDrawerOpen) {
            onClick.globalKey.currentState!.openEndDrawer();
            onClick.scroll(index: 0);
          }
        },
        title: "Home",
      ),
      SizedBox(height: size.height * 0.01),
      TabletNav(
        onTap: () {
          if (onClick.globalKey.currentState!.isDrawerOpen) {
            onClick.globalKey.currentState!.openEndDrawer();
            onClick.scroll(index: 4);
          }
        },
        title: "Team",
      ),
      SizedBox(height: size.height * 0.01),
      TabletNav(
        onTap: () {
          if (onClick.globalKey.currentState!.isDrawerOpen) {
            onClick.globalKey.currentState!.openEndDrawer();
            onClick.scroll(index: 3);
          }
        },
        title: "Roadmap",
      ),
      SizedBox(height: size.height * 0.01),
      TabletNav(
        onTap: () {
          if (onClick.globalKey.currentState!.isDrawerOpen) {
            onClick.globalKey.currentState!.openEndDrawer();
            onClick.scroll(index: 2);
          }
        },
        title: "Token Info",
      ),
    ],
  ));
}
