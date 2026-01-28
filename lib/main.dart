import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/home_screen.dart';
import 'core/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // =========================
  // WINDOW CONFIG (DESKTOP)
  // =========================
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(480, 680),      // tamaño inicial
    minimumSize: Size(400, 600), // tamaño mínimo permitido
    center: true,
    title: 'ChronoSync',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // =========================
  // LOAD SETTINGS
  // =========================
  final settingsController = SettingsController();
  await settingsController.load();

  runApp(
    ChangeNotifierProvider(
      create: (_) => settingsController,
      child: const TimerApp(),
    ),
  );
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChronoSync',

      // 🌞 Tema claro
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),

      // 🌙 Tema oscuro
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2EE59D),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 27, 27, 27),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),

      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const HomeScreen(),
    );
  }
}
