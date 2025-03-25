import 'package:safeandromeda/core/hooks/hooks.dart';

class InfoDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FastSecureCards(),
        Container(
          color: AppColors.parent,
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.035,
            horizontal: size.width * 0.035,
          ),
          child: Row(
            children: [
              Expanded(
                child: Image.network(
                  "https://media.discordapp.net/attachments/838662480795533335/858573554966069258/newAndroMeda.png",
                  height: size.height * 0.32,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppText.infoTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: size.height * 0.032,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.width * 0.18,
                      ),
                      child: InfoText(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
