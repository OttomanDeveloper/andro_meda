import 'package:safeandromeda/core/hooks/hooks.dart';

class TeamMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Responsive(
      mobile: MobileTeam(teamLiner(size)),
      tablet: TabletTeam(teamLiner(size)),
      desktop: DesktopTeam(teamLiner(size)),
    );
  }

  Widget teamLiner(Size size) {
    return Container(
      height: size.height * 0.002,
      width: size.width * 0.09,
      color: AppColors.teamText,
    );
  }
}
