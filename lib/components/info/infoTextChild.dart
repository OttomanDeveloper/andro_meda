import 'package:safeandromeda/core/hooks/hooks.dart';

class InfoTextChild extends StatelessWidget {
  const InfoTextChild({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: AppColors.white,
            fontSize: size.height * 0.02,
          ),
        ),
        SizedBox(width: size.width * 0.02),
        Expanded(
          child: Text(
            '$title',
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: size.height * 0.018,
              color: AppColors.white.withOpacity(0.94),
            ),
          ),
        ),
      ],
    );
  }
}
