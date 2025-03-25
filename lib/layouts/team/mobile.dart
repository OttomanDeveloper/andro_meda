import 'package:safeandromeda/core/hooks/hooks.dart';

class MobileTeam extends StatelessWidget {
  final Widget teamLiner;
  const MobileTeam(this.teamLiner);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            teamLiner,
            SizedBox(width: size.width * 0.02),
            Text(
              'OUR CORE TEAM MEMBERS'.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.teamText,
                fontSize: size.height * 0.019,
              ),
            ),
            SizedBox(width: size.width * 0.02),
            teamLiner,
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          "OUR TEAM".toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.russoOne(
            color: AppColors.white,
            fontSize: size.height * 0.023,
          ),
        ),
        SizedBox(height: size.height * 0.02),
        TeamCard(
          isMobile: true,
          name: AppText.teamName[0],
          specialist: AppText.teamRole[0],
          asset: AppAsset.avatar1,
        ),
        SizedBox(height: size.height * 0.012),
        TeamCard(
          isMobile: true,
          name: AppText.teamName[1],
          specialist: AppText.teamRole[1],
          asset: AppAsset.avatar2,
        ),
        SizedBox(height: size.height * 0.012),
        TeamCard(
          isMobile: true,
          name: AppText.teamName[2],
          specialist: AppText.teamRole[2],
          asset: AppAsset.avatar3,
        ),
        SizedBox(height: size.height * 0.012),
        TeamCard(
          isMobile: true,
          name: AppText.teamName[3],
          specialist: AppText.teamRole[3],
          asset: AppAsset.avatar4,
        ),
        SizedBox(height: size.height * 0.012),
        TeamCard(
          isMobile: true,
          name: AppText.teamName[4],
          specialist: AppText.teamRole[4],
          asset: AppAsset.avatar5,
        ),
        // SizedBox(height: size.height * 0.012),
        // TeamCard(
        //   isMobile: true,
        //   name: AppText.teamName[5],
        //   specialist: AppText.teamRole[5],
        //   asset: AppAsset.avatar6,
        // ),
        SizedBox(height: size.height * 0.02),
      ],
    );
  }
}
