import 'package:safeandromeda/core/hooks/hooks.dart';

class TeamCard extends StatefulWidget {
  const TeamCard({
    super.key,
    required this.name,
    required this.specialist,
    required this.asset,
    this.isMobile = false,
    this.isTablet = false,
  });

  final String name;
  final String asset;
  final String specialist;
  final bool isMobile;
  final bool isTablet;

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    late final double cardWidth;
    late final double avatarRadius;
    late final double headerGreenLine;
    if (widget.isMobile) {
      cardWidth = size.width * 0.6;
      avatarRadius = size.height * 0.0435;
      headerGreenLine = size.height * 0.007;
    } else {
      if (widget.isTablet) {
        cardWidth = size.width * 0.425;
        avatarRadius = size.height * 0.0672;
        headerGreenLine = size.height * 0.012;
      } else {
        cardWidth = size.width * 0.165;
        avatarRadius = size.height * 0.063;
        headerGreenLine = size.height * 0.015;
      }
    }

    return Material(
      elevation: 10.0,
      color: AppColors.parent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          if (value) {
            _isHover = true;
          } else {
            _isHover = false;
          }
          setState(() {});
        },
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHover ? AppColors.teamGreen : AppColors.parent,
            ),
            gradient: const LinearGradient(
              colors: [
                AppColors.teamCard1,
                AppColors.teamCard2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(size.height * 0.015),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width,
                height: headerGreenLine,
                color: AppColors.teamGreen,
              ),
              SizedBox(height: size.height * 0.01),
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.white,
                child: SvgPicture.asset(
                  widget.asset,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.teamGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: size.height * 0.019,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: size.width * 0.0045),
                  Expanded(child: teamLine(size)),
                  SizedBox(width: size.width * 0.0045),
                  Text(
                    widget.specialist,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: size.height * 0.0163,
                      color: AppColors.teamSpecialistText,
                    ),
                  ),
                  SizedBox(width: size.width * 0.0045),
                  Expanded(child: teamLine(size)),
                  SizedBox(width: size.width * 0.0045),
                ],
              ),
              SizedBox(height: size.height * 0.006),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      AppAsset.instaSVG,
                      height: size.height * 0.055,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      AppAsset.teleSVG,
                      height: size.height * 0.055,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      AppAsset.faceSVG,
                      height: size.height * 0.055,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.003),
            ],
          ),
        ),
      ),
    );
  }

  Widget teamLine(Size size) {
    return Container(
      height: size.height * 0.002,
      color: AppColors.teamLiner,
    );
  }
}
