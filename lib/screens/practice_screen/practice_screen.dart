import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart'; // Ensure this includes Range enum
import 'package:QuickMath_Kids/screens/practice_screen/modals/quit_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/modals/pause_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/timer_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/tts_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/hint_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/confetti_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/answer_option_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/helpers/operation_helper.dart';
import 'package:QuickMath_Kids/screens/practice_screen/ui/timer_card.dart';
import 'package:QuickMath_Kids/screens/practice_screen/ui/answer_button.dart';
import 'package:QuickMath_Kids/screens/practice_screen/ui/pause_button.dart';
import 'package:QuickMath_Kids/wrong_answer_storing/wrong_answer_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/app_theme.dart';

class PracticeScreen extends StatefulWidget {
  final Function(List<String>, List<bool>, int, Operation, Range, int?) // Updated to Range
      switchToResultScreen;
  final VoidCallback switchToStartScreen;
  final Function(String) triggerTTS;
  final Operation selectedOperation;
  final Range selectedRange; // Updated to Range
  final int? sessionTimeLimit;
  final bool isDarkMode;

  const PracticeScreen(
    this.switchToResultScreen,
    this.switchToStartScreen,
    this.triggerTTS,
    this.selectedOperation,
    this.selectedRange,
    this.sessionTimeLimit, {
    required this.isDarkMode,
    super.key,
  });

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<int> numbers = [0, 0, 0];
  List<int> answerOptions = [];
  List<String> answeredQuestions = [];
  List<bool> answeredCorrectly = [];
  List<Map<String, dynamic>> _wrongQuestions = [];
  List<String> _wrongQuestionsToShowThisSession = [];
  List<String> _shownWrongQuestionsThisSession = [];
  List<String> _answeredQuestionsThisSession = [];
  List<String> _wrongQuestionsThisSession = [];
  bool _isInitialized = false;

  int correctAnswer = 0;
  String currentHintMessage = '';
  bool hasListenedToQuestion = false;

  final HintManager hintManager = HintManager();
  final QuizTimer _quizTimer = QuizTimer();
  late ConfettiManager confettiManager;
  late TTSHelper _ttsHelper;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    confettiManager = ConfettiManager();
    _ttsHelper = TTSHelper(widget.triggerTTS);
    _quizTimer.startTimer((secondsPassed) {
      setState(() {
        if (widget.sessionTimeLimit != null &&
            secondsPassed >= widget.sessionTimeLimit!) {
          endQuiz();
        }
      });
    });
  }

  Future<void> _initializeScreen() async {
    await _loadWrongQuestions();
    setState(() {
      _setInitialQuestion();
      _updateHintMessage();
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _quizTimer.stopTimer();
    confettiManager.dispose();
    super.dispose();
  }

  void stopTimer() => _quizTimer.stopTimer();
  void pauseTimer() => _quizTimer.pauseTimer();
  void resumeTimer() => _quizTimer.resumeTimer();

  Future<void> _loadWrongQuestions() async {
    List<Map<String, dynamic>> allWrongQuestions =
        await WrongQuestionsService.getWrongQuestions();

    setState(() {
      _wrongQuestions = [];
      _wrongQuestionsToShowThisSession = [];

      final currentOperation =
          widget.selectedOperation.toString().split('.').last;
      final rangeDisplayName = _getRangeDisplayName(widget.selectedRange);
      for (var question in allWrongQuestions) {
        String category = question['category']?.toString() ?? '';
        String questionText = question['question']?.toString() ?? '';
        String operationFromCategory = category.split(' - ').first;
        String rangeFromCategory = category.split(' - ').last;

        if (operationFromCategory == currentOperation &&
            rangeFromCategory == rangeDisplayName) {
          _wrongQuestions.add(question);
          _wrongQuestionsToShowThisSession.add(questionText);
        }
      }

      _shownWrongQuestionsThisSession.clear();
      _answeredQuestionsThisSession.clear();
      _wrongQuestionsThisSession.clear();
    });
  }

  void regenerateNumbers() {
    int attempts = 0;
    const maxAttempts = 100;
    String questionText;

    do {
      numbers = QuestionGenerator().generateTwoRandomNumbers(
          widget.selectedOperation, widget.selectedRange);

      if (widget.selectedOperation == Operation.lcm ||
          widget.selectedOperation == Operation.gcf) {
        correctAnswer = numbers.last;
        numbers = numbers.sublist(0, numbers.length - 1);
      } else {
        if (numbers.length >= 2) {
          switch (widget.selectedOperation) {
            case Operation.additionBeginner:
            case Operation.additionIntermediate:
            case Operation.additionAdvanced:
              correctAnswer = numbers[0] + numbers[1];
              break;
            case Operation.subtractionBeginner:
            case Operation.subtractionIntermediate:
              correctAnswer = numbers[0] - numbers[1];
              break;
            case Operation.multiplicationTables:
              correctAnswer = numbers[0] * numbers[1];
              break;
            case Operation.divisionBasic:
            case Operation.divisionMixed:
              correctAnswer = numbers[0] ~/ numbers[1];
              break;
            default:
              correctAnswer = 0;
          }
        } else {
          correctAnswer = 0;
        }
      }

      questionText = _formatQuestionText();
      attempts++;
    } while (_answeredQuestionsThisSession.contains(questionText) &&
        attempts < maxAttempts);

    if (attempts >= maxAttempts) {
      int num1, num2;
      do {
        num1 = (DateTime.now().millisecondsSinceEpoch % 10) + 1;
        num2 = (DateTime.now().millisecondsSinceEpoch % 10) + 1;
        numbers = [num1, num2];

        if (widget.selectedOperation == Operation.lcm ||
            widget.selectedOperation == Operation.gcf) {
          correctAnswer = widget.selectedOperation == Operation.lcm
              ? _lcm(num1, num2)
              : _gcd(num1, num2);
        } else {
          switch (widget.selectedOperation) {
            case Operation.additionBeginner:
            case Operation.additionIntermediate:
            case Operation.additionAdvanced:
              correctAnswer = num1 + num2;
              break;
            case Operation.subtractionBeginner:
            case Operation.subtractionIntermediate:
              correctAnswer = num1 - num2;
              break;
            case Operation.multiplicationTables:
              correctAnswer = num1 * num2;
              break;
            case Operation.divisionBasic:
            case Operation.divisionMixed:
              if (num2 != 0) {
                correctAnswer = num1 ~/ num2;
              } else {
                num2 = 1;
                correctAnswer = num1 ~/ num2;
              }
              break;
            default:
              correctAnswer = 0;
          }
        }

        questionText = _formatQuestionText();
      } while (_answeredQuestionsThisSession.contains(questionText));
    }

    answerOptions = generateAnswerOptions(correctAnswer);
    _answeredQuestionsThisSession.add(questionText);
  }

  void _setInitialQuestion() {
    if (_wrongQuestionsToShowThisSession.isNotEmpty) {
      _useWrongQuestion();
    } else {
      regenerateNumbers();
    }
  }

  void _useWrongQuestion() {
    if (_wrongQuestionsToShowThisSession.isEmpty) {
      regenerateNumbers();
      return;
    }

    String nextQuestionText = _wrongQuestionsToShowThisSession.firstWhere(
      (q) => !_shownWrongQuestionsThisSession.contains(q),
      orElse: () => '',
    );

    if (nextQuestionText.isNotEmpty) {
      setState(() {
        numbers = _parseQuestion(nextQuestionText);
        correctAnswer =
            _calculateCorrectAnswer(numbers, widget.selectedOperation);
        answerOptions = generateAnswerOptions(correctAnswer);
        _shownWrongQuestionsThisSession.add(nextQuestionText);
        _answeredQuestionsThisSession.add(nextQuestionText);
      });
    } else {
      regenerateNumbers();
    }
  }

  void _updateHintMessage() {
    currentHintMessage = hintManager.getRandomHintMessage();
  }

  String formatTime(int seconds) {
    if (widget.sessionTimeLimit == null) {
      final minutes = (seconds / 60).floor();
      final secs = seconds % 60;
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    } else {
      int remaining = widget.sessionTimeLimit! - seconds;
      if (remaining < 0) remaining = 0;
      final minutes = (remaining / 60).floor();
      final secs = remaining % 60;
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  void checkAnswer(int selectedAnswer) {
    bool isCorrect = selectedAnswer == correctAnswer;
    String currentQuestion = _formatQuestionText();

    setState(() {
      answeredQuestions.add('$currentQuestion = $selectedAnswer '
          '(${isCorrect ? "Correct" : "Wrong, The correct answer is $correctAnswer"})');
      answeredCorrectly.add(isCorrect);

      if (!isCorrect) {
        if (!_wrongQuestionsThisSession.contains(currentQuestion)) {
          _wrongQuestionsThisSession.add(currentQuestion);
          WrongQuestionsService.saveWrongQuestion(
            question: currentQuestion,
            userAnswer: selectedAnswer,
            correctAnswer: correctAnswer,
            category:
                '${widget.selectedOperation.toString().split('.').last} - ${_getRangeDisplayName(widget.selectedRange)}', // Updated to Range
          );
        }
      } else if (_wrongQuestionsToShowThisSession.contains(currentQuestion)) {
        WrongQuestionsService.updateWrongQuestion(currentQuestion,
            correct: true);
      }

      if (isCorrect) {
        confettiManager.correctConfettiController.play();
      }

      if (_wrongQuestionsToShowThisSession.isNotEmpty) {
        String? nextWAQ = _wrongQuestionsToShowThisSession.firstWhere(
          (q) => !_shownWrongQuestionsThisSession.contains(q),
          orElse: () => '',
        );

        if (nextWAQ.isNotEmpty) {
          numbers = _parseQuestion(nextWAQ);
          correctAnswer =
              _calculateCorrectAnswer(numbers, widget.selectedOperation);
          answerOptions = generateAnswerOptions(correctAnswer);
          _shownWrongQuestionsThisSession.add(nextWAQ);
        } else {
          regenerateNumbers();
        }
      } else {
        regenerateNumbers();
      }

      _answeredQuestionsThisSession.add(currentQuestion);
    });

    _triggerTTSSpeech();
  }

  int _calculateCorrectAnswer(List<int> numbers, Operation operation) {
    if (numbers.length < 2) return 0;
    switch (operation) {
      case Operation.additionBeginner:
      case Operation.additionIntermediate:
      case Operation.additionAdvanced:
        return numbers[0] + numbers[1];
      case Operation.subtractionBeginner:
      case Operation.subtractionIntermediate:
        return numbers[0] - numbers[1];
      case Operation.multiplicationTables:
        return numbers[0] * numbers[1];
      case Operation.divisionBasic:
      case Operation.divisionMixed:
        return numbers[0] ~/ numbers[1];
      case Operation.lcm:
        return _lcm(numbers[0], numbers[1]);
      case Operation.gcf:
        return _gcd(numbers[0], numbers[1]);
    }
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  int _lcm(int a, int b) {
    return (a * b) ~/ _gcd(a, b);
  }

  List<int> _parseQuestion(String questionText) {
    RegExp regExp = RegExp(r'\d+');
    return regExp
        .allMatches(questionText)
        .map((m) => int.parse(m[0] ?? '0'))
        .toList();
  }

  String _formatQuestionText() {
    if (widget.selectedOperation == Operation.lcm) {
      if (widget.selectedRange.toString().contains('3Numbers')) { // Check Range enum for 3 numbers
        return 'LCM of ${numbers[0]}, ${numbers[1]}, ${numbers[2]}';
      } else {
        return 'LCM of ${numbers[0]}, ${numbers[1]}';
      }
    } else if (widget.selectedOperation == Operation.gcf) {
      return 'GCF of ${numbers[0]}, ${numbers[1]}';
    } else {
      return '${numbers[0]} ${OperatorHelper.getOperatorSymbol(widget.selectedOperation)} ${numbers[1]}';
    }
  }

  void _triggerTTSSpeech() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsHelper.playSpeech(widget.selectedOperation, numbers);
      setState(() {
        hasListenedToQuestion = true;
      });
    });
  }

  void endQuiz() {
    stopTimer();
    widget.switchToResultScreen(
      answeredQuestions,
      answeredCorrectly,
      _quizTimer.secondsPassed,
      widget.selectedOperation,
      widget.selectedRange, // Updated to Range
      widget.sessionTimeLimit,
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuitDialog(onQuit: widget.switchToStartScreen);
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

  void _showHintDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Hint',
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: theme.colorScheme.onSurface)),
          content: Text(currentHintMessage,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurface)),
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close',
                  style: TextStyle(color: theme.colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  // Helper method to convert Range enum to display string
  String _getRangeDisplayName(Range range) {
    switch (range) {
      // Addition Beginner
      case Range.additionBeginner1to5:
        return '1-5';
      case Range.additionBeginner6to10:
        return '6-10';
      // Addition Intermediate
      case Range.additionIntermediate10to20:
        return '10-20';
      case Range.additionIntermediate20to50:
        return '20-50';
      // Addition Advanced
      case Range.additionAdvanced50to100:
        return '50-100';
      case Range.additionAdvanced100to200:
        return '100-200';
      // Subtraction Beginner
      case Range.subtractionBeginner1to10:
        return '1-10';
      case Range.subtractionBeginner10to20:
        return '10-20';
      // Subtraction Intermediate
      case Range.subtractionIntermediate20to50:
        return '20-50';
      case Range.subtractionIntermediate50to100:
        return '50-100';
      // Multiplication Tables
      case Range.multiplicationTables2to5:
        return '2-5';
      case Range.multiplicationTables6to10:
        return '6-10';
      // Division Basic
      case Range.divisionBasicBy2:
        return 'Divided by 2';
      case Range.divisionBasicBy3:
        return 'Divided by 3';
      case Range.divisionBasicBy4:
        return 'Divided by 4';
      case Range.divisionBasicBy5:
        return 'Divided by 5';
      case Range.divisionBasicBy6:
        return 'Divided by 6';
      case Range.divisionBasicBy7:
        return 'Divided by 7';
      case Range.divisionBasicBy8:
        return 'Divided by 8';
      case Range.divisionBasicBy9:
        return 'Divided by 9';
      case Range.divisionBasicBy10:
        return 'Divided by 10';
      // Division Mixed
      case Range.divisionMixed:
        return 'Mixed Division';
      // LCM
      case Range.lcmUpto10:
        return 'upto 10';
      case Range.lcmUpto20:
        return 'upto 20';
      case Range.lcmUpto30:
        return 'upto 30';
      case Range.lcmUpto40:
        return 'upto 40';
      case Range.lcmUpto50:
        return 'upto 50';
      case Range.lcmUpto60:
        return 'upto 60';
      case Range.lcmUpto70:
        return 'upto 70';
      case Range.lcmUpto80:
        return 'upto 80';
      case Range.lcmUpto90:
        return 'upto 90';
      case Range.lcmUpto100:
        return 'upto 100';
      case Range.lcm3NumbersUpto10:
        return '3 numbers upto 10';
      case Range.lcm3NumbersUpto20:
        return '3 numbers upto 20';
      case Range.lcm3NumbersUpto30:
        return '3 numbers upto 30';
      case Range.lcm3NumbersUpto40:
        return '3 numbers upto 40';
      case Range.lcm3NumbersUpto50:
        return '3 numbers upto 50';
      // GCF
      case Range.gcfUpto10:
        return 'upto 10';
      case Range.gcfUpto20:
        return 'upto 20';
      case Range.gcfUpto30:
        return 'upto 30';
      case Range.gcfUpto40:
        return 'upto 40';
      case Range.gcfUpto50:
        return 'upto 50';
      case Range.gcfUpto60:
        return 'upto 60';
      case Range.gcfUpto70:
        return 'upto 70';
      case Range.gcfUpto80:
        return 'upto 80';
      case Range.gcfUpto90:
        return 'upto 90';
      case Range.gcfUpto100:
        return 'upto 100';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = AppTheme.getTheme(ref, widget.isDarkMode, context);
        final screenWidth = MediaQuery.of(context).size.width;
        final scale = screenWidth / 360;
        final adjustedScale = screenWidth > 600 ? scale.clamp(0.8, 1.2) : scale;
        final isTablet = screenWidth > 600;

        int displayTime = widget.sessionTimeLimit != null
            ? (widget.sessionTimeLimit! - _quizTimer.secondsPassed)
            : _quizTimer.secondsPassed;
        if (widget.sessionTimeLimit != null && displayTime < 0) displayTime = 0;

        if (!_isInitialized) {
          return Theme(
            data: theme,
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Theme(
          data: theme,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Practice',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.7),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0 * adjustedScale),
                  child: ElevatedButton.icon(
                    onPressed: _showQuitDialog,
                    icon: Icon(Icons.exit_to_app_rounded,
                        color: theme.colorScheme.onPrimary),
                    label: Text('Quit',
                        style: TextStyle(color: theme.colorScheme.onPrimary)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0 * adjustedScale),
                  child: ElevatedButton.icon(
                    onPressed: endQuiz,
                    icon: Icon(Icons.assessment,
                        color: theme.colorScheme.onPrimary),
                    label: Text('Results',
                        style: TextStyle(color: theme.colorScheme.onPrimary)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Container(
                color: theme.colorScheme.background,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    confettiManager.buildCorrectConfetti(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 16 * adjustedScale),
                        buildTimerCard(
                            formatTime(_quizTimer.secondsPassed), context),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _triggerTTSSpeech,
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        elevation: 8,
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        padding: EdgeInsets.all(isTablet
                                            ? screenWidth * 0.1
                                            : 40 * adjustedScale),
                                      ),
                                      child: Icon(
                                        Icons.record_voice_over,
                                        size: isTablet
                                            ? screenWidth * 0.1
                                            : 60 * adjustedScale,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: _showHintDialog,
                                        icon: Icon(Icons.lightbulb_outline,
                                            color: theme.iconTheme.color),
                                        style: IconButton.styleFrom(
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          shape: const CircleBorder(),
                                        ),
                                        tooltip: 'Show Hint',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: isTablet ? 40 : 40 * adjustedScale),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0 * adjustedScale),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20 * adjustedScale)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.brightness ==
                                                  Brightness.dark
                                              ? Colors.black.withOpacity(0.3)
                                              : Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16 * adjustedScale),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buildAnswerButton(
                                              answerOptions[0],
                                              () =>
                                                  checkAnswer(answerOptions[0]),
                                            ),
                                            SizedBox(
                                                width: isTablet
                                                    ? 20
                                                    : 12 * adjustedScale),
                                            buildAnswerButton(
                                              answerOptions[1],
                                              () =>
                                                  checkAnswer(answerOptions[1]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: isTablet
                                                ? 20
                                                : 12 * adjustedScale),
                                        buildAnswerButton(
                                          answerOptions[2],
                                          () => checkAnswer(answerOptions[2]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: isTablet ? 80 : 40 * adjustedScale),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 24 * adjustedScale,
                      right: 16 * adjustedScale,
                      child: buildPauseButton(_showPauseDialog, context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}