import 'package:safeandromeda/core/hooks/hooks.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({super.key});

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  Widget sectionWidget(int i) {
    if (i == 0) {
      return const Header();
    } else if (i == 1) {
      return const InfoPage();
    } else if (i == 2) {
      return const IntroToken();
    } else if (i == 3) {
      return const RoadMap();
    } else if (i == 4) {
      return const TeamMember();
    } else if (i == 5) {
      return const Bottom();
    } else {
      return const SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      provider.addItemScrollListener();
    });
  }

  /// Create an Instance of `NavProvider`
  late final NavProvider provider = context.read<NavProvider>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppSettings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: AppColors.parent),
      home: Scaffold(
        backgroundColor: AppColors.whatMainBG,
        body: SafeArea(
          child: RawScrollbar(
            thickness: 5.0,
            controller: provider.scrollController,
            child: ScrollablePositionedList.builder(
              itemCount: 6,
              initialScrollIndex: 0,
              itemScrollController: provider.itemScrollController,
              itemPositionsListener: provider.itemPositionsListener,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return sectionWidget(index);
              },
            ),
          ),
        ),
        floatingActionButton: Consumer<NavProvider>(
          builder: (_, NavProvider pro, __) {
            if (pro.isFloat) {
              return FloatingActionButton(
                onPressed: () => pro.scroll(index: 0),
                backgroundColor: AppColors.whatBlueText,
                child: const Icon(
                  color: AppColors.white,
                  Icons.keyboard_arrow_up_outlined,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
