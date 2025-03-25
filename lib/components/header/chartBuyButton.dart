import 'package:safeandromeda/core/hooks/hooks.dart';

Widget buySellButtons(
  BuildContext context, {
  required double rounded,
  required double iconSize,
  required double textSize,
  required double buttonSpace,
  required double iconTextSpace,
  required double paddingVertical,
  required double paddingHorizontal,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      MaterialButton(
        color: AppColors.white,
        hoverColor: AppColors.black.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded),
        ),
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        onPressed: () => PopDialog(context: context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: iconSize,
              color: AppColors.black.withOpacity(0.75),
            ),
            SizedBox(width: iconTextSpace),
            Text(
              "Live Chart",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: textSize,
                color: AppColors.black.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: buttonSpace),
      MaterialButton(
        color: Colors.blue,
        hoverColor: AppColors.black.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded),
        ),
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        onPressed: () => PopDialog(context: context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: iconSize,
              color: AppColors.white,
            ),
            SizedBox(width: iconTextSpace),
            Text(
              "Buy Now",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: textSize,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
