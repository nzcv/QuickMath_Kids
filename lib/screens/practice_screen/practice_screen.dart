import 'dart:async';
import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';
import 'package:QuickMath_Kids/screens/practice_screen/modals/quit_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/modals/pause_modal.dart';
import 'package:QuickMath_Kids/screens/practice_screen/modals/inactivity_modal.dart';
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
  final Function(List<String>, List<bool>, int, Operation, Range, int?)
      switchToResultScreen;
  final VoidCallback switchToStartScreen;
  final Function(String) triggerTTS;
  final Operation selectedOperation;
  final Range selectedRange;
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
  bool _isWrongAnswerQuestion = false;

  int correctAnswer = 0;
  String currentHintMessage = '';
  bool hasListenedToQuestion = false;

  final HintManager hintManager = HintManager();
  final QuizTimer _quizTimer = QuizTimer();
  late ConfettiManager confettiManager;
  late TTSHelper _ttsHelper;
  Timer? _inactivityTimer;

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
    _startInactivityTimer();
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
    _inactivityTimer?.cancel();
    confettiManager.dispose();
    super.dispose();
  }

  void stopTimer() => _quizTimer.stopTimer();
  void pauseTimer() => _quizTimer.pauseTimer();
  void resumeTimer() => _quizTimer.resumeTimer();

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 20), () {
      if (mounted) {
        pauseTimer(); // Pause the quiz timer
        _inactivityTimer?.cancel(); // Cancel the timer to prevent stacking
        _showNoActivityModal(); // Show the modal
      }
    });
  }

  void _showNoActivityModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InActivityModal(
          onResume: () {
            Navigator.pop(context); // Close the modal
            resumeTimer(); // Resume the quiz timer
            _startInactivityTimer(); // Restart the inactivity timer
          },
        );
      },
    );
  }

  Future<void> _loadWrongQuestions() async {
    List<Map<String, dynamic>> allWrongQuestions =
        await WrongQuestionsService.getWrongQuestions();

    setState(() {
      _wrongQuestions = [];
      _wrongQuestionsToShowThisSession = [];

      final currentOperation =
          widget.selectedOperation.toString().split('.').last;
      final rangeDisplayName = getRangeDisplayName(widget.selectedRange);
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

      if (widget.selectedOperation == Operation.lcmBeginner ||
          widget.selectedOperation == Operation.lcmIntermediate ||
          widget.selectedOperation == Operation.lcmAdvanced ||
          widget.selectedOperation == Operation.gcfBeginner ||
          widget.selectedOperation == Operation.gcfIntermediate ||
          widget.selectedOperation == Operation.gcfAdvanced) {
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
            case Operation.subtractionAdvanced:
              correctAnswer = numbers[0] - numbers[1];
              break;
            case Operation.multiplicationBeginner:
            case Operation.multiplicationIntermediate:
            case Operation.multiplicationAdvanced:
              correctAnswer = numbers[0] * numbers[1];
              break;
            case Operation.divisionBeginner:
            case Operation.divisionIntermediate:
            case Operation.divisionAdvanced:
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

        switch (widget.selectedOperation) {
          case Operation.additionBeginner:
          case Operation.additionIntermediate:
          case Operation.additionAdvanced:
            correctAnswer = num1 + num2;
            break;
          case Operation.subtractionBeginner:
          case Operation.subtractionIntermediate:
          case Operation.subtractionAdvanced:
            correctAnswer = num1 - num2;
            break;
          case Operation.multiplicationBeginner:
          case Operation.multiplicationIntermediate:
          case Operation.multiplicationAdvanced:
            correctAnswer = num1 * num2;
            break;
          case Operation.divisionBeginner:
          case Operation.divisionIntermediate:
          case Operation.divisionAdvanced:
            if (num2 != 0) {
              correctAnswer = num1 ~/ num2;
            } else {
              num2 = 1;
              correctAnswer = num1 ~/ num2;
            }
            break;
          case Operation.lcmBeginner:
          case Operation.lcmIntermediate:
          case Operation.lcmAdvanced:
            correctAnswer = _lcm(num1, num2);
            break;
          case Operation.gcfBeginner:
          case Operation.gcfIntermediate:
          case Operation.gcfAdvanced:
            correctAnswer = _gcd(num1, num2);
            break;
        }

        questionText = _formatQuestionText();
      } while (_answeredQuestionsThisSession.contains(questionText));
    }

    answerOptions = generateAnswerOptions(correctAnswer);
    _answeredQuestionsThisSession.add(questionText);
    _isWrongAnswerQuestion = false;
  }

  void _setInitialQuestion() {
    if (_wrongQuestionsToShowThisSession.isNotEmpty) {
      _useWrongQuestion();
      _isWrongAnswerQuestion = true;
    } else {
      regenerateNumbers();
      _isWrongAnswerQuestion = false;
    }
  }

  void _useWrongQuestion() {
    if (_wrongQuestionsToShowThisSession.isEmpty) {
      regenerateNumbers();
      _isWrongAnswerQuestion = false;
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
        _isWrongAnswerQuestion = true;
      });
    } else {
      regenerateNumbers();
      _isWrongAnswerQuestion = false;
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
    _startInactivityTimer();
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
                '${widget.selectedOperation.toString().split('.').last} - ${getRangeDisplayName(widget.selectedRange)}',
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
          _isWrongAnswerQuestion = true;
        } else {
          regenerateNumbers();
          _isWrongAnswerQuestion = false;
        }
      } else {
        regenerateNumbers();
        _isWrongAnswerQuestion = false;
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
      case Operation.subtractionAdvanced:
        return numbers[0] - numbers[1];
      case Operation.multiplicationBeginner:
      case Operation.multiplicationIntermediate:
      case Operation.multiplicationAdvanced:
        return numbers[0] * numbers[1];
      case Operation.divisionBeginner:
      case Operation.divisionIntermediate:
      case Operation.divisionAdvanced:
        return numbers[0] ~/ numbers[1];
      case Operation.lcmBeginner:
      case Operation.lcmIntermediate:
      case Operation.lcmAdvanced:
        return _lcm(numbers[0], numbers[1]);
      case Operation.gcfBeginner:
      case Operation.gcfIntermediate:
      case Operation.gcfAdvanced:
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
    if (widget.selectedOperation == Operation.lcmBeginner ||
        widget.selectedOperation == Operation.lcmIntermediate ||
        widget.selectedOperation == Operation.lcmAdvanced) {
      if (widget.selectedRange.toString().contains('3Numbers')) {
        return 'LCM of ${numbers[0]}, ${numbers[1]}, ${numbers[2]}';
      } else {
        return 'LCM of ${numbers[0]}, ${numbers[1]}';
      }
    } else if (widget.selectedOperation == Operation.gcfBeginner ||
        widget.selectedOperation == Operation.gcfIntermediate ||
        widget.selectedOperation == Operation.gcfAdvanced) {
      return 'GCF of ${numbers[0]}, ${numbers[1]}';
    } else {
      return '${numbers[0]} ${OperatorHelper.getOperatorSymbol(widget.selectedOperation)} ${numbers[1]}';
    }
  }

  void _triggerTTSSpeech() {
    _startInactivityTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsHelper.playSpeech(widget.selectedOperation, numbers);
      setState(() {
        hasListenedToQuestion = true;
      });
    });
  }

  void endQuiz() {
    _startInactivityTimer();
    stopTimer();
    widget.switchToResultScreen(
      answeredQuestions,
      answeredCorrectly,
      _quizTimer.secondsPassed,
      widget.selectedOperation,
      widget.selectedRange,
      widget.sessionTimeLimit,
    );
  }

  void _showQuitDialog() {
    _startInactivityTimer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuitDialog(onQuit: widget.switchToStartScreen);
      },
    );
  }

  void _showPauseDialog() {
    _startInactivityTimer();
    pauseTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PauseDialog(onResume: () {
          resumeTimer();
          _startInactivityTimer();
        });
      },
    );
  }

  void _showHintDialog() {
    _startInactivityTimer();
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
              onPressed: () {
                Navigator.pop(context);
                _startInactivityTimer();
              },
              child: Text('Close',
                  style: TextStyle(color: theme.colorScheme.primary)),
            ),
          ],
        );
      },
    );
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
                    if (_isWrongAnswerQuestion)
                      Positioned(
                        top: 8.0 * adjustedScale,
                        right: 8.0 * adjustedScale,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0 * adjustedScale,
                            vertical: 4.0 * adjustedScale,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius:
                                BorderRadius.circular(5 * adjustedScale),
                          ),
                          child: Text(
                            'Previous Wrong Answer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * adjustedScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 80 * adjustedScale),
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
                                          color: widget.isDarkMode
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