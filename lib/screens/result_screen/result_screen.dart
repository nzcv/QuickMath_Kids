import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/result_screen/result_row.dart';
import 'package:QuickMath_Kids/screens/result_screen/pdf_sharing.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final List<String> answeredQuestions;
  final List<bool> answeredCorrectly;
  final int totalTime;
  final Function switchToStartScreen;
  final bool isDarkMode;

  const ResultScreen(this.answeredQuestions, this.answeredCorrectly,
      this.totalTime, this.switchToStartScreen, this.isDarkMode,
      {super.key});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sharePDFReport() async {
    try {
      final file = await QuizPDFGenerator.generateQuizPDF(
        answeredQuestions: widget.answeredQuestions,
        answeredCorrectly: widget.answeredCorrectly,
        totalTime: widget.totalTime,
      );

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'QuickMath Kids Quiz Results',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing PDF: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    int minutes = widget.totalTime ~/ 60;
    int seconds = widget.totalTime % 60;

    int correctAnswers =
        widget.answeredCorrectly.where((correct) => correct).length;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Quiz Results',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isDarkMode ? Colors.blue[200] : Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 4,
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResultRowWidget(
                          icon: Icons.timer,
                          label: 'Time Taken:',
                          value: '$minutes:${seconds.toString().padLeft(2, '0')}',
                          theme: theme,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 10),
                        ResultRowWidget(
                          icon: Icons.question_answer,
                          label: 'Questions Attempted:',
                          value: '${widget.answeredQuestions.length}',
                          theme: theme,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 10),
                        ResultRowWidget(
                          icon: Icons.check_circle,
                          label: 'Correct Answers:',
                          value: '$correctAnswers',
                          theme: theme,
                          isDarkMode: isDarkMode,
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
                              color: isDarkMode ? Colors.red[300] : Colors.red[700],
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.answeredQuestions.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              widget.answeredCorrectly[index]
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: widget.answeredCorrectly[index]
                                  ? (isDarkMode ? Colors.green[300] : Colors.green[700])
                                  : (isDarkMode ? Colors.red[300] : Colors.red[700]),
                            ),
                            title: Text(
                              widget.answeredQuestions[index],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isDarkMode ? Colors.grey[200] : Colors.grey[800],
                              ),
                            ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.blue[800] : Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    label: const Text('Start Screen'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: _sharePDFReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.green[800] : Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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