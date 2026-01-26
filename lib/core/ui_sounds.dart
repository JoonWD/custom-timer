import 'package:audioplayers/audioplayers.dart';

class UISounds {
  UISounds._(); // clase estática

  // =========================
  // PLAYERS SEPARADOS
  // =========================

  static final AudioPlayer _uiPlayer = AudioPlayer();
  static final AudioPlayer _alarmPlayer = AudioPlayer();

  // =========================
  // VOLUMENES (CONTROLADOS POR SETTINGS)
  // =========================

  static double _uiVolume = 0.6;
  static double _alarmVolume = 0.8;

  static void setUiVolume(double value) {
    _uiVolume = value.clamp(0.0, 1.0);
  }

  static void setAlarmVolume(double value) async {
    final newVolume = value.clamp(0.0, 1.0);
    final changedZeroState = (_alarmVolume == 0.0) != (newVolume == 0.0);

    _alarmVolume = newVolume;

    if (_alarmPlaying) {
      if (changedZeroState) {
        // Cambió entre 0 y >0 → hay que reiniciar con otra fuente
        await stopAlarm();
        await playAlarmLoop();
      } else {
        await _alarmPlayer.setVolume(_alarmVolume);
      }
    }
  }

  // =========================
  // UI SOUNDS
  // =========================

  static Future<void> tap() async {
    try {
      await _uiPlayer.stop();
      await _uiPlayer.play(AssetSource('sounds/tick2.mp3'), volume: _uiVolume);
    } catch (_) {}
  }

  static Future<void> click() async {
    try {
      await _uiPlayer.stop();
      await _uiPlayer.play(AssetSource('sounds/click.mp3'), volume: _uiVolume);
    } catch (_) {}
  }

  static Future<void> yet() async {
    try {
      await _uiPlayer.stop();
      await _uiPlayer.play(AssetSource('sounds/yet.mp3'), volume: _uiVolume);
    } catch (_) {}
  }

  // =========================
  // ALARMA FINAL (LOOP REAL FIXED)
  // =========================

  static bool _alarmPlaying = false;

  static Future<void> playAlarmLoop() async {
    try {
      if (_alarmPlaying) return;
      _alarmPlaying = true;
      await _alarmPlayer.stop();
      await _alarmPlayer.setReleaseMode(ReleaseMode.loop);

      final source = _alarmVolume == 0.0
          ? AssetSource('sounds/vibration-sound.mp3')
          : AssetSource('sounds/successful-ending.mp3');

      await _alarmPlayer.setSource(source);
      await _alarmPlayer.setVolume(_alarmVolume == 0 ? 0.2 : _alarmVolume);
      await _alarmPlayer.resume();
    } catch (_) {}
  }

  static Future<void> stopAlarm() async {
    try {
      _alarmPlaying = false;
      await _alarmPlayer.stop();
    } catch (_) {}
  }
}
