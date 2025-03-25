import 'package:safeandromeda/core/hooks/hooks.dart';

class TeamMember extends StatelessWidget {
  const TeamMember({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
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
