class TimerEngine {
  int hours;
  int minutes;
  int seconds;

  int remainingSeconds;
  bool isRunning = false;

  TimerEngine({
    required this.hours,
    required this.minutes,
    required this.seconds,
  }) : remainingSeconds = _toSeconds(hours, minutes, seconds);

  static int _toSeconds(int h, int m, int s) {
    return (h * 3600) + (m * 60) + s;
  }

  void start() {
    isRunning = true;
  }

  void pause() {
    isRunning = false;
  }

  void reset() {
    remainingSeconds = _toSeconds(hours, minutes, seconds);
    isRunning = false;
  }

  void tick() {
    if (!isRunning) return;
    if (remainingSeconds > 0) {
      remainingSeconds--;
    }
  }

  bool get isFinished => remainingSeconds == 0;

  int get displayHours => remainingSeconds ~/ 3600;
  int get displayMinutes => (remainingSeconds % 3600) ~/ 60;
  int get displaySeconds => remainingSeconds % 60;
}
