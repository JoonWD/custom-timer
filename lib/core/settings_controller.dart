import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/ui_sounds.dart';

class SettingsController extends ChangeNotifier {
  static const _uiVolumeKey = 'ui_volume';
  static const _alarmVolumeKey = 'alarm_volume';
  static const _darkModeKey = 'dark_mode';

  double _uiVolume = 0.6;
  double _alarmVolume = 0.8;
  bool _darkMode = false;

  double get uiVolume => _uiVolume;
  double get alarmVolume => _alarmVolume;
  bool get isDarkMode => _darkMode;

  // =========================
  // LOAD FROM STORAGE
  // =========================
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _uiVolume = prefs.getDouble(_uiVolumeKey) ?? 0.6;
    _alarmVolume = prefs.getDouble(_alarmVolumeKey) ?? 0.8;
    _darkMode = prefs.getBool(_darkModeKey) ?? false;

    // 🔗 sincronizar con motor real de sonidos
    UISounds.setUiVolume(_uiVolume);
    UISounds.setAlarmVolume(_alarmVolume);

    notifyListeners();
  }

  // =========================
  // SETTERS
  // =========================

  Future<void> setUiVolume(double value) async {
    _uiVolume = value.clamp(0.0, 1.0);

    UISounds.setUiVolume(_uiVolume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_uiVolumeKey, _uiVolume);

    notifyListeners();
  }

  Future<void> setAlarmVolume(double value) async {
    _alarmVolume = value.clamp(0.0, 1.0);

    UISounds.setAlarmVolume(_alarmVolume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_alarmVolumeKey, _alarmVolume);

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);

    notifyListeners();
  }
}
