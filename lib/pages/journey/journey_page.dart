import 'package:safeandromeda/core/hooks/hooks.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ScrollProvider provider = context.read<ScrollProvider>();
    provider.initScroll(size.height);

    return MaterialApp(
      title: AppSettings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: AppColors.parent),
      home: Scaffold(
        backgroundColor: AppColors.bigBangVoid,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: provider.scrollController,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const BigBangEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const DarkAgesEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const FirstStarsEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const GalaxiesEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const SolarSystemEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const LifeBeginsEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const AgeOfGiantsEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const HumanityEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height * AppSettings.eraHeightFactor,
                      child: const FutureEra(),
                    ),
                  ),
                  RepaintBoundary(
                    child: SizedBox(
                      height: size.height,
                      child: const PortfolioReveal(),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ProgressBar(),
            ),
          ],
        ),
      ),
    );
  }
}
