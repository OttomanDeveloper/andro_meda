import 'package:safeandromeda/core/hooks/hooks.dart';

/// App entry. Mounts the three app-wide providers above the journey scaffold.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ScrollProvider(),
        ), // scroll → per-era progress
        ChangeNotifierProvider(
          create: (_) => AnimationProvider(),
        ), // ticker → global time clock
        ChangeNotifierProvider(
          create: (_) => CursorProvider(),
        ), // hover position for trail
      ],
      child: const JourneyPage(),
    ),
  );
}
