import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerEngine {
  final VoidCallback onTick;

  Timer? _timer;

  Duration _currentDuration = Duration.zero;
  Duration _initialDuration = Duration.zero;
  Duration get currentDuration => _currentDuration;

  bool _isRunning = false;
  bool _hasStarted = false;
  bool get hasStarted => _hasStarted;
  bool get isPaused => !_isRunning && _currentDuration > Duration.zero;


  TimerEngine({required this.onTick});

  // =========================
  // GETTERS
  // =========================

  String get formattedTime {
    final hours = _currentDuration.inHours.toString().padLeft(2, '0');
    final minutes =
        (_currentDuration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds =
        (_currentDuration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  bool get isRunning => _isRunning;

  // =========================
  // CONTROLES PRINCIPALES
  // =========================

void start() {
  if (_isRunning || _currentDuration.inSeconds <= 0) return;

  _hasStarted = true;
  _isRunning = true;

  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (_currentDuration.inSeconds <= 0) {
      pause();
      return;
    }

    _currentDuration -= const Duration(seconds: 1);
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
  _currentDuration = _initialDuration;
  _hasStarted = false; // ← clave
  onTick();
}


  // =========================
  // AJUSTE DE TIEMPO
  // =========================

  void addSeconds(int value) {
    if (_isRunning) return;

    _currentDuration += Duration(seconds: value);
    if (_currentDuration.isNegative) {
      _currentDuration = Duration.zero;
    }

    _initialDuration = _currentDuration;
    onTick();
  }

  void addMinutes(int value) {
    if (_isRunning) return;

    _currentDuration += Duration(minutes: value);
    if (_currentDuration.isNegative) {
      _currentDuration = Duration.zero;
    }

    _initialDuration = _currentDuration;
    onTick();
  }

  void addHours(int value) {
    if (_isRunning) return;

    _currentDuration += Duration(hours: value);
    if (_currentDuration.isNegative) {
      _currentDuration = Duration.zero;
    }

    _initialDuration = _currentDuration;
    onTick();
  }

  // =========================
  // CLEANUP
  // =========================

  void dispose() {
    _timer?.cancel();
  }
}
