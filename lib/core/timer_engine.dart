import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/ui_sounds.dart';

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
    final h = _currentDuration.inHours.toString().padLeft(2, '0');
    final m = (_currentDuration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_currentDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // =========================
  // CONTROL PRINCIPAL
  // =========================

  void start() {
    if (_status == TimerStatus.running) return;
    if (_currentDuration <= Duration.zero) return;

    _status = TimerStatus.running;
    _endTime = DateTime.now().add(_currentDuration);

    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 100), // suficiente precisión, menos consumo
      (_) => _updateTime(),
    );

    onTick();
  }

  void pause() {
    if (_status != TimerStatus.running) return;

    _updateTime(); // congelar exacto
    _ticker?.cancel();
    _status = TimerStatus.paused;
    onTick();
  }

  void reset() {
    if (_status == TimerStatus.idle) return;

    _ticker?.cancel();
    UISounds.stopAlarm();

    _currentDuration = _initialDuration;
    _status = TimerStatus.idle;
    onTick();
  }

  void stop() {
    _ticker?.cancel();
    UISounds.stopAlarm();

    _currentDuration = Duration.zero;
    _initialDuration = Duration.zero;
    _status = TimerStatus.idle;
    _endTime = null;

    onTick();
  }

  void _finish() {
    if (_status == TimerStatus.finished) return; // protección doble trigger

    _ticker?.cancel();
    _currentDuration = Duration.zero;
    _status = TimerStatus.finished;

    UISounds.playAlarmLoop();

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
  // AJUSTES (solo idle)
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
    final updated = _currentDuration + delta;

    _currentDuration = updated.isNegative ? Duration.zero : updated;
    _initialDuration = _currentDuration;

    onTick();
  }

  // =========================
  // CLEANUP
  // =========================

  void dispose() {
    _ticker?.cancel();
    UISounds.stopAlarm();
  }
}
