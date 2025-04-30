import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/record_button_controller.dart';
import 'navigation/app_navigation.dart';

void main() {
  runApp(const VoiceTabApp());
}

class VoiceTabApp extends StatelessWidget {
  const VoiceTabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordButtonController()),
      ],
      child: MaterialApp.router(
        title: 'VoiceTab',
        debugShowCheckedModeBanner: false,
        routerConfig: AppNavigation.router,
      ),
    );
  }
}
