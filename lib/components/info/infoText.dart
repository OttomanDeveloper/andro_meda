import 'package:safeandromeda/core/hooks/hooks.dart';

class InfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: AppText.tokenIntroDes.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoTextChild(title: AppText.tokenIntroDes[index]),
            SizedBox(height: size.height * 0.013),
          ],
        );
      },
    );
  }
}

class IntroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: AppText.infoTexts.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoTextChild(title: AppText.infoTexts[index]),
            SizedBox(height: size.height * 0.013),
          ],
        );
      },
    );
  }
}
