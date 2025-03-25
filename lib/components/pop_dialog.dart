import 'package:flutter/cupertino.dart';
import 'package:safeandromeda/core/hooks/hooks.dart';

class PopDialog {
  final BuildContext context;
  PopDialog({required this.context}) {
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final Size size = MediaQuery.sizeOf(context);
        return Responsive(
          mobile: dilog(size, padding: size.width * 0.07),
          tablet: dilog(size, padding: size.width * 0.13),
          desktop: dilog(size, padding: size.width * 0.31),
        );
      },
    );
  }

  Widget dilog(Size size, {required double padding}) {
    return Dialog(
      elevation: 8.0,
      insetPadding: EdgeInsets.symmetric(horizontal: padding),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.height * 0.02),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.012),
          Icon(
            Icons.campaign_outlined,
            color: AppColors.blue,
            size: size.height * 0.07,
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            "Launching Soon",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              fontSize: size.height * 0.028,
              color: AppColors.black.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
            ),
            child: Text(
              "Safe Andromeda will be launching soon. Please join our Telegram channel for future updates and stay connected with us .Our Team is available 24/7 there for helping you.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: size.height * 0.018,
                color: AppColors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.018),
          Material(
            elevation: 6.0,
            color: AppColors.blue,
            child: InkWell(
              onTap: () => openLink(AppLinks.telegram),
              hoverColor: AppColors.black.withValues(alpha: 0.1),
              onHover: (value) {},
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.008,
                ),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      AppAsset.telegram,
                      height: size.height * 0.03,
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      "Join Telegram",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColors.white,
                        fontSize: size.height * 0.02,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
