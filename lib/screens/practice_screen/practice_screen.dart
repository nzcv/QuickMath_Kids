import 'package:flutter/material.dart';
import 'package:oral_app_new/question_logic/question_generator.dart';
import 'package:oral_app_new/screens/practice_screen/quit_modal/quit_modal.dart'; // Import the QuitDialog
import 'package:oral_app_new/screens/practice_screen/pause_modal.dart';
import 'package:oral_app_new/screens/practice_screen/quiz_timer.dart'; // Import the new timer utility class

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

class _PracticeScreenState extends State<PracticeScreen> {
  List<int> numbers = [0, 0, 0];
  List<int> answerOptions = [];
  int correctAnswer = 0;
  String resultText = '';
  List<String> answeredQuestions = [];
  List<bool> answeredCorrectly = [];

  final QuizTimer _quizTimer = QuizTimer(); // Use the new timer class

  @override
  void initState() {
    super.initState();
    regenerateNumbers();
    _quizTimer.startTimer((secondsPassed) {
      setState(() {
        // Timer callback
      });
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
      correctAnswer = numbers[2];
      answerOptions = [correctAnswer];
      while (answerOptions.length < 3) {
        int option = QuestionGenerator().generateRandomNumber();
        if (!answerOptions.contains(option)) {
          answerOptions.add(option);
        }
      }
      answerOptions.shuffle(); // Randomize answer options
    });
  }

  void checkAnswer(int selectedAnswer) {
    bool isCorrect = selectedAnswer == correctAnswer;

    setState(() {
      answeredQuestions.add(
          '${numbers[0]} ${_getOperatorSymbol(widget.selectedOperation)} ${numbers[1]} = $selectedAnswer (${isCorrect ? "Correct" : "Wrong, The correct answer is $correctAnswer"})');
      answeredCorrectly.add(isCorrect);
    });
  }

  String _getOperatorSymbol(Operation operation) {
    if (
        operation == Operation.addition2A ||
        operation == Operation.additionA ||
        operation == Operation.additionB) {
      return '+';
    } else if (
               operation == Operation.subtractionA ||
               operation == Operation.subtractionB) {
      return '-';
    } else if (
               operation == Operation.multiplicationC ||
               operation == Operation.multiplicationD) {
      return 'x';
    } else if (
               operation == Operation.divisionC ||
               operation == Operation.divisionD) {
      return '÷';
    }
    return '';
  }

  void _triggerTTSSpeech() {
    String operatorWord = '';
    if (
        widget.selectedOperation == Operation.addition2A ||
        widget.selectedOperation == Operation.additionA ||
        widget.selectedOperation == Operation.additionB) {
      operatorWord = 'plus';
    } else if (
               widget.selectedOperation == Operation.subtractionA ||
               widget.selectedOperation == Operation.subtractionB) {
      operatorWord = 'minus';
    } else if (
               widget.selectedOperation == Operation.multiplicationC ||
               widget.selectedOperation == Operation.multiplicationD) {
      operatorWord = 'times';
    } else if (
               widget.selectedOperation == Operation.divisionC ||
               widget.selectedOperation == Operation.divisionD) {
      operatorWord = 'divided by';
    }

    String questionText = '${numbers[0]} $operatorWord ${numbers[1]} equals?';
    widget.triggerTTS(questionText);
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
            widget
                .switchToStartScreen(); // Call the function to switch to start screen
          },
        );
      },
    );
  }

  void _showPauseDialog() {
    pauseTimer(); // Pause the timer when the modal opens
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PauseDialog(onResume: resumeTimer); // Pass the resume function
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String questionText =
        '${numbers[0]} ${_getOperatorSymbol(widget.selectedOperation)} ${numbers[1]} = ?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Quiz'),
        backgroundColor: const Color(0xFF009DDC), // Kumon blue
        actions: [
          ElevatedButton(
            onPressed: _showQuitDialog, // Show the quit dialog
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
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display the formatted timer
                  Text(
                    formatTime(_quizTimer.secondsPassed),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.speaker),
                    iconSize: 150,
                    color: Colors.black,
                    onPressed: _triggerTTSSpeech,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    questionText,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
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
            // Add the pause button at the bottom-right corner
            Positioned(
              bottom: 10, // Position the button
              right: 10, // Position the button
              child: ElevatedButton(
                onPressed: _showPauseDialog, // Show the pause dialog
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: const Size(60, 60), // Button size
                  padding: EdgeInsets.zero, // Ensures no extra padding
                ),
                child: const Center(
                  child: Icon(
                    Icons.pause,
                    size: 30, // Icon size
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
