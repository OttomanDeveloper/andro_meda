import 'package:safeandromeda/core/hooks/hooks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ScrollProvider()),
      ChangeNotifierProvider(create: (_) => AnimationProvider()),
    ],
    child: const JourneyPage(),
  ));
}
