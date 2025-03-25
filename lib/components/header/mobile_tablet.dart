import 'package:safeandromeda/core/hooks/hooks.dart';

class TabletNav extends StatelessWidget {
  const TabletNav({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.height * 0.015),
      ),
      onPressed: () => onTap(),
      color: AppColors.blue,
      hoverColor: AppColors.black.withValues(alpha: 0.2),
      child: Container(
        width: size.width * 0.55,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.013),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: AppColors.white,
            fontSize: size.height * 0.02,
          ),
        ),
      ),
    );
  }
}
