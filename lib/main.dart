import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/home_screen.dart';
import 'core/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar settings antes de iniciar la app
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
      title: 'Custom Timer',

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

      // 🔥 Aquí está la conexión real con Settings
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const HomeScreen(),
    );
  }
}
