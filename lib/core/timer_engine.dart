import 'dart:async';
import 'package:flutter/foundation.dart';

enum TimerStatus { idle, running, paused, finished }

class TimerEngine {
  final VoidCallback onTick;

  Timer? _timer;

  Duration _currentDuration = Duration.zero;
  Duration _initialDuration = Duration.zero;

  Duration get currentDuration => _currentDuration;
  Duration get initialDuration => _initialDuration;

  TimerStatus _status = TimerStatus.idle;

  // =========================
  // GETTERS DE ESTADO
  // =========================

  bool get isRunning => _status == TimerStatus.running;
  bool get isPaused => _status == TimerStatus.paused;
  bool get isIdle => _status == TimerStatus.idle;
  bool get isFinished => _status == TimerStatus.finished;

  TimerEngine({required this.onTick});

  // =========================
  // FORMATO DE TIEMPO
  // =========================

  String get formattedTime {
    final hours = _currentDuration.inHours.toString().padLeft(2, '0');
    final minutes =
        (_currentDuration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds =
        (_currentDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // =========================
  // CONTROLES
  // =========================

  void start() {
    if (_status == TimerStatus.running) return;
    if (_currentDuration.inSeconds <= 0) return;

    _status = TimerStatus.running;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentDuration.inSeconds <= 1) {
        _finish();
        return;
      }

      _currentDuration -= const Duration(seconds: 1);
      onTick();
    });

    onTick();
  }

  void pause() {
    if (_status != TimerStatus.running) return;

    _timer?.cancel();
    _status = TimerStatus.paused;
    onTick();
  }

  void reset() {
    if (_status == TimerStatus.idle) return;

    _timer?.cancel();
    _currentDuration = _initialDuration;
    _status = TimerStatus.idle;
    onTick();
  }

  void stop() {
    // Se usa solo cuando está finished
    _timer?.cancel();
    _currentDuration = Duration.zero;
    _initialDuration = Duration.zero;
    _status = TimerStatus.idle;
    onTick();
  }

  void _finish() {
    _timer?.cancel();
    _currentDuration = Duration.zero;
    _status = TimerStatus.finished;
    onTick();
  }

  // =========================
  // AJUSTE DE TIEMPO
  // =========================

  void addSeconds(int value) {
    if (_status != TimerStatus.idle) return;

    _currentDuration += Duration(seconds: value);
    if (_currentDuration.isNegative) _currentDuration = Duration.zero;

    _initialDuration = _currentDuration;
    onTick();
  }

  void addMinutes(int value) {
    if (_status != TimerStatus.idle) return;

    _currentDuration += Duration(minutes: value);
    if (_currentDuration.isNegative) _currentDuration = Duration.zero;

    _initialDuration = _currentDuration;
    onTick();
  }

  void addHours(int value) {
    if (_status != TimerStatus.idle) return;

    _currentDuration += Duration(hours: value);
    if (_currentDuration.isNegative) _currentDuration = Duration.zero;

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
