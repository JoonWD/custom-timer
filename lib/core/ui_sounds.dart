import 'package:audioplayers/audioplayers.dart';

class UISounds {
  UISounds._(); // clase estática

  static final AudioPlayer _player = AudioPlayer();

  static Future<void> tap() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/tick2.mp3'),
        volume: 0.6,
      );
    } catch (_) {}
  }

  static Future<void> click() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/click.mp3'),
        volume: 0.7,
      );
    } catch (_) {}
  }

  static Future<void> yet() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/yet.mp3'),
        volume: 0.7,
      );
    } catch (_) {}
  }
}
