import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/screens/practice_screen/quit_modal/quit_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/pause_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/quiz_timer.dart';
import 'dart:math';

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

  final List<String> hintMessages = [
    "Tap the speaker to hear the question! 🔊",
    "Click the black icon to hear me read the question! 📢",
    "Need help? Press the speaker icon! 🎯",
    "Tap to hear the question read aloud! 🎧",
    "Listen to the question by tapping the speaker! 👂",
    "Press the black speaker for audio help! 🔉",
    "Tap to hear - I'm here to help! 🎤",
  ];

  final QuizTimer _quizTimer = QuizTimer();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    regenerateNumbers();
    _updateHintMessage();
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
    super.dispose();
  }

  void _updateHintMessage() {
    final random = Random();
    setState(() {
      currentHintMessage = hintMessages[random.nextInt(hintMessages.length)];
      hasListenedToQuestion = false;
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
      } else {
        answeredQuestions.add(
            '${numbers[0]} ${_getOperatorSymbol(widget.selectedOperation)} ${numbers[1]} = $selectedAnswer (${isCorrect ? "Correct" : "Wrong, The correct answer is $correctAnswer"})');
      }
      answeredCorrectly.add(isCorrect);
    });
  }

  String _getOperatorSymbol(Operation operation) {
    if (operation == Operation.addition_2A ||
        operation == Operation.addition_A ||
        operation == Operation.addition_B) {
      return '+';
    } else if (operation == Operation.subtraction_A ||
        operation == Operation.subtraction_B) {
      return '-';
    } else if (operation == Operation.multiplication_C) {
      return 'x';
    } else if (operation == Operation.division_C ||
        operation == Operation.division_D) {
      return '÷';
    } else if (operation == Operation.lcm) {
      return 'LCM';
    } else if (operation == Operation.gcf) {
      return 'GCF';
    }
    return '';
  }

  void _triggerTTSSpeech() {
    String operatorWord = '';
    switch (widget.selectedOperation) {
      case Operation.addition_2A:
      case Operation.addition_A:
      case Operation.addition_B:
        operatorWord = 'plus';
        break;
      case Operation.subtraction_A:
      case Operation.subtraction_B:
        operatorWord = 'minus';
        break;
      case Operation.multiplication_C:
        operatorWord = 'times';
        break;
      case Operation.division_C:
      case Operation.division_D:
        operatorWord = 'divided by';
        break;
      case Operation.lcm:
        operatorWord = 'LCM of ';
        break;
      case Operation.gcf:
        operatorWord = 'GCF of ';
        break;
    }

    String questionText;
    switch (widget.selectedOperation) {
      case Operation.lcm:
        questionText = numbers.length > 3
            ? 'LCM of ${numbers[0]}, ${numbers[1]}, and ${numbers[2]}'
            : 'LCM of ${numbers[0]} and ${numbers[1]}';
        break;
      case Operation.gcf:
        questionText = '$operatorWord ${numbers[0]} and ${numbers[1]}';
        break;
      default:
        questionText = '${numbers[0]} $operatorWord ${numbers[1]} equals?';
    }

    widget.triggerTTS(questionText);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Quiz'),
        backgroundColor: const Color(0xFF009DDC),
        actions: [
          ElevatedButton(
            onPressed: _showQuitDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.exit_to_app_rounded,
              size: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: endQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 127, 22),
              ),
              child: const Text(
                'Show Result',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
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
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatTime(_quizTimer.secondsPassed),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedOpacity(
                        opacity: hasListenedToQuestion ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF009DDC).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF009DDC),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            currentHintMessage,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF009DDC),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.speaker),
                            iconSize: 150,
                            color: Colors.black,
                            onPressed: _triggerTTSSpeech,
                          ),
                          if (!hasListenedToQuestion)
                            Positioned(
                              right: 45,
                              top: 45,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF009DDC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.touch_app,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    checkAnswer(answerOptions[0]);
                                    regenerateNumbers();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                  child: Text(
                                    answerOptions[0].toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    checkAnswer(answerOptions[1]);
                                    regenerateNumbers();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                  child: Text(
                                    answerOptions[1].toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                checkAnswer(answerOptions[2]);
                                regenerateNumbers();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                              child: Text(
                                answerOptions[2].toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: _showPauseDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: const Size(60, 60),
                  padding: EdgeInsets.zero,
                ),
                child: const Center(
                  child: Icon(
                    Icons.pause,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}