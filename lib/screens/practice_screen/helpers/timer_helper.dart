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

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}