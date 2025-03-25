import 'package:safeandromeda/core/hooks/hooks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NavProvider>(create: (_) => NavProvider())
      ],
      child: StarterScreen(),
    ),
  );
}
