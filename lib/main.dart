import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen.dart';
import 'models.dart';
import 'notification_service.dart';
import 'timer_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final provider = TimerProvider();
  await provider.load();
  runApp(
    ChangeNotifierProvider.value(value: provider, child: const ArkApp()),
  );
}

class ArkApp extends StatelessWidget {
  const ArkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARK Breeding Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: const ColorScheme.dark(
          primary: kNeonGreen,
          secondary: kCyan,
          surface: kSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBackground,
          foregroundColor: kCyan,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: kCyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kNeonGreen,
          foregroundColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
