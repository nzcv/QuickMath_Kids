import 'dart:async';

class QuizTimer {
  Timer? _timer;
  int _secondsPassed = 0;
  bool _isPaused = false;

  int get secondsPassed => _secondsPassed;
  bool get isPaused => _isPaused;

  void startTimer(void Function(int) onTick) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _secondsPassed++;
        onTick(_secondsPassed);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void pauseTimer() {
    _isPaused = true;
  }

  void resumeTimer() {
    _isPaused = false;
  }
}
