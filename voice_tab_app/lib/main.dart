import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/record_button_controller.dart';
import 'navigation/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final controller = RecordButtonController();
  await controller.loadFromPrefs(); // => doet initializeDefaults() automatisch

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: controller)],
      child: const VoiceTabApp(),
    ),
  );
}

class VoiceTabApp extends StatelessWidget {
  const VoiceTabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VoiceTab',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
