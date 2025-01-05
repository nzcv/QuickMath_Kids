import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/screens/practice_screen/modals/quit_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/modals/pause_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/timer_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/tts_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/operation_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/hint_helper.dart';
import 'package:confetti/confetti.dart';

class PracticeScreen extends StatefulWidget {
  final Function(List<String>, List<bool>, int) switchToResultScreen;
  final VoidCallback switchToStartScreen;
  final Function(String) triggerTTS;
  final Operation selectedOperation;
  final String selectedRange;

  const PracticeScreen(this.switchToResultScreen, this.switchToStartScreen,
      this.triggerTTS, this.selectedOperation, this.selectedRange,
      {super.key});

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  List<int> numbers = [0, 0, 0];
  List<int> answerOptions = [];
  int correctAnswer = 0;
  String resultText = '';
  List<String> answeredQuestions = [];
  List<bool> answeredCorrectly = [];
  String currentHintMessage = '';
  bool hasListenedToQuestion = false;
  final HintManager hintManager = HintManager();
  late ConfettiController _confettiController;

  final QuizTimer _quizTimer = QuizTimer();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late TTSHelper _ttsHelper;

  @override
  void initState() {
    super.initState();
    regenerateNumbers();
    _updateHintMessage();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _confettiController.play();
    _ttsHelper = TTSHelper(widget.triggerTTS);
    _quizTimer.startTimer((secondsPassed) {
      setState(() {
        // Timer callback
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _quizTimer.stopTimer();
    _confettiController.dispose();
    super.dispose();
  }

  void _updateHintMessage() {
    setState(() {
      currentHintMessage = hintManager.getRandomHintMessage();
    });
  }

  void stopTimer() {
    _quizTimer.stopTimer();
  }

  void pauseTimer() {
    _quizTimer.pauseTimer();
  }

  void resumeTimer() {
    _quizTimer.resumeTimer();
  }

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void regenerateNumbers() {
    setState(() {
      numbers = QuestionGenerator().generateTwoRandomNumbers(
          widget.selectedOperation, widget.selectedRange);

      if (numbers.length == 3) {
        correctAnswer = numbers[2];
      } else if (numbers.length == 4) {
        correctAnswer = numbers[3];
      }

      answerOptions = [correctAnswer];
      while (answerOptions.length < 3) {
        int option = QuestionGenerator().generateRandomNumber();
        if (!answerOptions.contains(option)) {
          answerOptions.add(option);
        }
      }
      answerOptions.shuffle();
      _updateHintMessage();
    });
  }

  void checkAnswer(int selectedAnswer) {
    bool isCorrect = selectedAnswer == correctAnswer;

    setState(() {
      if (widget.selectedOperation == Operation.lcm && numbers.length > 3) {
        answeredQuestions.add(
            'LCM of ${numbers[0]}, ${numbers[1]}, and ${numbers[2]} = $selectedAnswer (${isCorrect ? "Correct" : "Wrong, The correct answer is $correctAnswer"})');
        _confettiController.play();
      } else {
        answeredQuestions.add(
            '${numbers[0]} ${_getOperatorSymbol(widget.selectedOperation)} ${numbers[1]} = $selectedAnswer (${isCorrect ? "Correct" : "Wrong, The correct answer is $correctAnswer"})');
        _confettiController.play();
      }
      answeredCorrectly.add(isCorrect);
    });

    // Regenerate numbers for the next question
    regenerateNumbers();

    // Automatically trigger TTS for the new question
    Future.delayed(const Duration(), () {
      _triggerTTSSpeech();
    });

    _updateHintMessage();
  }

  String _getOperatorSymbol(Operation operation) {
    return OperatorHelper.getOperatorSymbol(operation);
  }

  void _triggerTTSSpeech() {
    _ttsHelper.playSpeech(widget.selectedOperation, numbers);
    setState(() {
      hasListenedToQuestion = true;
    });
  }

  void endQuiz() {
    stopTimer();
    widget.switchToResultScreen(
        answeredQuestions, answeredCorrectly, _quizTimer.secondsPassed);
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuitDialog(
          onQuit: () {
            widget.switchToStartScreen();
          },
        );
      },
    );
  }

  void _showPauseDialog() {
    pauseTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PauseDialog(onResume: resumeTimer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100], // Matching ResultScreen background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: Text(
          'Practice',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _showQuitDialog,
              icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
              label: const Text('Quit', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: endQuiz,
              icon: const Icon(Icons.assessment, color: Colors.white),
              label: const Text('Results', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: -3.14159 / 2,
              numberOfParticles: 100,
              gravity: 1,
              shouldLoop: false,
              emissionFrequency: 0.1,
              particleDrag: 0.01,
              colors: const [Colors.green, Colors.blue, Colors.orange],
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Timer Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _quizTimer.formatTime(_quizTimer.secondsPassed),
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Hint Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lightbulb, color: Colors.amber[700]),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hint',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentHintMessage,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[300],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Voice Button
                      ElevatedButton(
                        onPressed: _triggerTTSSpeech,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                          elevation: 8,
                        ),
                        child: const Icon(
                          Icons.record_voice_over,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Answer Options
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAnswerButton(answerOptions[0], 0),
                                const SizedBox(width: 16),
                                _buildAnswerButton(answerOptions[1], 1),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildAnswerButton(answerOptions[2], 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Pause Button
            Positioned(
              bottom: 24,
              right: 24,
              child: ElevatedButton(
                onPressed: _showPauseDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  elevation: 8,
                ),
                child: const Icon(
                  Icons.pause,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int answer, int index) {
    return SizedBox(
      width: 140,
      height: 50,
      child: ElevatedButton(
        onPressed: () => checkAnswer(answer),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 4,
        ),
        child: Text(
          answer.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
