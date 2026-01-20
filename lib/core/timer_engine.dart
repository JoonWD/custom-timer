import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerEngine {
  final VoidCallback onTick;

  Timer? _timer;
  Duration _current = Duration.zero;
  bool _isRunning = false;

  TimerEngine({required this.onTick});

  // =========================
  // GETTERS
  // =========================

  String get formattedTime {
    final hours = _current.inHours.toString().padLeft(2, '0');
    final minutes = (_current.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_current.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  bool get isRunning => _isRunning;

  // =========================
  // CONTROLES PRINCIPALES
  // =========================

  void start() {
    if (_isRunning || _current.inSeconds <= 0) return;

    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_current.inSeconds <= 0) {
        pause();
        return;
      }

      _current -= const Duration(seconds: 1);
      onTick();
    });
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    onTick();
  }

  void reset() {
    pause();
    _current = Duration.zero;
    onTick();
  }

  // =========================
  // AJUSTE DE TIEMPO
  // =========================

  void addHours(int value) {
    _updateTime(Duration(hours: value));
  }

  void addMinutes(int value) {
    _updateTime(Duration(minutes: value));
  }

  void addSeconds(int value) {
    _updateTime(Duration(seconds: value));
  }

  void _updateTime(Duration delta) {
    if (_isRunning) return; // no permitir edición mientras corre

    final newTime = _current + delta;

    // Evita valores negativos
    if (newTime.inSeconds < 0) return;

    _current = newTime;
    onTick();
  }

  // =========================
  // CLEANUP
  // =========================

  void dispose() {
    _timer?.cancel();
  }
}
