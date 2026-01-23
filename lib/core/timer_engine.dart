import 'dart:async';
import 'package:flutter/foundation.dart';

enum TimerStatus { idle, running, paused, finished }

class TimerEngine {
  final VoidCallback onTick;

  Timer? _ticker;

  Duration _currentDuration = Duration.zero;
  Duration _initialDuration = Duration.zero;

  DateTime? _endTime;

  TimerStatus _status = TimerStatus.idle;

  TimerEngine({required this.onTick});

  // =========================
  // GETTERS
  // =========================

  Duration get currentDuration => _currentDuration;
  Duration get initialDuration => _initialDuration;

  bool get isRunning => _status == TimerStatus.running;
  bool get isPaused => _status == TimerStatus.paused;
  bool get isIdle => _status == TimerStatus.idle;
  bool get isFinished => _status == TimerStatus.finished;

  // =========================
  // FORMATO
  // =========================

  String get formattedTime {
    final hours = _currentDuration.inHours.toString().padLeft(2, '0');
    final minutes = (_currentDuration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_currentDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // =========================
  // CONTROL
  // =========================

  void start() {
    if (_status == TimerStatus.running) return;
    if (_currentDuration <= Duration.zero) return;

    _status = TimerStatus.running;

    _endTime = DateTime.now().add(_currentDuration);

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateTime();
    });

    onTick();
  }

  void pause() {
    if (_status != TimerStatus.running) return;

    _updateTime(); // congelamos con precisión real
    _ticker?.cancel();
    _status = TimerStatus.paused;
    onTick();
  }

  void reset() {
    if (_status == TimerStatus.idle) return;

    _ticker?.cancel();
    _currentDuration = _initialDuration;
    _status = TimerStatus.idle;
    onTick();
  }

  void stop() {
    _ticker?.cancel();
    _currentDuration = Duration.zero;
    _initialDuration = Duration.zero;
    _status = TimerStatus.idle;
    onTick();
  }

  void _finish() {
    _ticker?.cancel();
    _currentDuration = Duration.zero;
    _status = TimerStatus.finished;
    onTick();
  }

  void _updateTime() {
    if (_endTime == null) return;

    final remaining = _endTime!.difference(DateTime.now());

    if (remaining <= Duration.zero) {
      _finish();
      return;
    }

    _currentDuration = remaining;
    onTick();
  }

  // =========================
  // AJUSTES
  // =========================

  void addSeconds(int value) {
    if (_status != TimerStatus.idle) return;
    _applyAdjustment(Duration(seconds: value));
  }

  void addMinutes(int value) {
    if (_status != TimerStatus.idle) return;
    _applyAdjustment(Duration(minutes: value));
  }

  void addHours(int value) {
    if (_status != TimerStatus.idle) return;
    _applyAdjustment(Duration(hours: value));
  }

  void _applyAdjustment(Duration delta) {
    _currentDuration += delta;
    if (_currentDuration.isNegative) _currentDuration = Duration.zero;
    _initialDuration = _currentDuration;
    onTick();
  }

  // =========================
  // CLEANUP
  // =========================

  void dispose() {
    _ticker?.cancel();
  }
}
