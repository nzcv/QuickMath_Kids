import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/result_screen/result_row.dart';
import 'package:QuickMath_Kids/screens/result_screen/pdf_sharing.dart';
import 'package:QuickMath_Kids/quiz_history/quiz_history_service.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatefulWidget {
  final String? title;
  final List<String> answeredQuestions;
  final List<bool> answeredCorrectly;
  final int totalTime;
  final Operation? operation;
  final Range? range;
  final int? timeLimit;
  final Function switchToStartScreen;
  final bool isFromHistory;

  const ResultScreen(
    this.answeredQuestions,
    this.answeredCorrectly,
    this.totalTime,
    this.switchToStartScreen, {
    super.key,
    this.title,
    this.operation,
    this.range,
    this.timeLimit,
  }) : isFromHistory = false;

  const ResultScreen.fromHistory({
    required this.title,
    required this.answeredQuestions,
    required this.answeredCorrectly,
    required this.totalTime,
    required this.switchToStartScreen,
    this.operation,
    this.range,
    this.timeLimit,
    super.key,
  }) : isFromHistory = true;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String? _quizTitle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    if (!widget.isFromHistory) {
      _promptForTitle();
    } else {
      _quizTitle = widget.title;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _promptForTitle() async {
    final now = DateTime.now();
    final baseTitle =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final uniqueTitle = await QuizHistoryService.generateUniqueTitle(baseTitle);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final controller = TextEditingController(text: uniqueTitle);
        return AlertDialog(
          title: const Text('Save Quiz'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter quiz title',
              hintText: 'e.g., 28-03-2025',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _quizTitle =
                      controller.text.isEmpty ? uniqueTitle : controller.text;
                });
                _saveQuiz();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveQuiz() async {
  if (_quizTitle == null || widget.operation == null || widget.range == null)
    return;

  try {
    await QuizHistoryService.saveQuiz(
      title: _quizTitle!,
      timestamp: DateTime.now().toIso8601String(),
      operation: widget.operation!,
      range: widget.range!,
      timeLimit: widget.timeLimit,
      totalTime: widget.totalTime,
      answeredQuestions: widget.answeredQuestions,
      answeredCorrectly: widget.answeredCorrectly,
    );

    // Increment daily quiz count
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastQuizDate = prefs.getString('last_quiz_date');
    int quizzesTaken = prefs.getInt('daily_quizzes') ?? 0;

    if (lastQuizDate == today) {
      quizzesTaken++;
    } else {
      quizzesTaken = 1;
      await prefs.setString('last_quiz_date', today);
    }
    await prefs.setInt('daily_quizzes', quizzesTaken);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz saved successfully')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save quiz: $e')),
    );
  }}}

  Future<void> _sharePDFReport() async {
    try {
      final file = await QuizPDFGenerator.generateQuizPDF(
        answeredQuestions: widget.answeredQuestions,
        answeredCorrectly: widget.answeredCorrectly,
        totalTime: widget.totalTime,
      );
      await Share.shareXFiles(
        [XFile(file.path)],
        subject:
            'QuickMath Kids Quiz Results${_quizTitle != null ? ' - $_quizTitle' : ''}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing PDF: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int minutes = widget.totalTime ~/ 60;
    int seconds = widget.totalTime % 60;
    int correctAnswers =
        widget.answeredCorrectly.where((correct) => correct).length;

    // Determine the card background and text colors based on the theme
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Quiz Results',
        textAlign: TextAlign.center,
      )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  color: Colors
                      .white60, // Set card background color based on theme
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResultRowWidget(
                          icon: Icons.timer,
                          label: 'Time Taken:',
                          value:
                              '$minutes:${seconds.toString().padLeft(2, '0')}',
                          theme: theme.copyWith(
                            textTheme:
                                theme.textTheme.apply(bodyColor: textColor),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ResultRowWidget(
                          icon: Icons.question_answer,
                          label: 'Questions Attempted:',
                          value: '${widget.answeredQuestions.length}',
                          theme: theme.copyWith(
                            textTheme:
                                theme.textTheme.apply(bodyColor: textColor),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ResultRowWidget(
                          icon: Icons.check_circle,
                          label: 'Correct Answers:',
                          value: '$correctAnswers',
                          theme: theme.copyWith(
                            textTheme:
                                theme.textTheme.apply(bodyColor: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: widget.answeredQuestions.isEmpty
                    ? Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'No questions attended!',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.answeredQuestions.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              widget.answeredCorrectly[index]
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: widget.answeredCorrectly[index]
                                  ? Colors.green
                                  : Colors
                                      .red, // Keep these specific colors for correctness
                            ),
                            title: Text(widget.answeredQuestions[index]),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () => widget.switchToStartScreen(),
                    label: const Text('Start Screen'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: _sharePDFReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    label: const Text('Share Report'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}