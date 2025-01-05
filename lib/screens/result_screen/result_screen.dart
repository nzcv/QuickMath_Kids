import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/result_screen/pdf_sharing.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final List<String> answeredQuestions;
  final List<bool> answeredCorrectly;
  final int totalTime;
  final Function switchToStartScreen;

  const ResultScreen(this.answeredQuestions, this.answeredCorrectly,
      this.totalTime, this.switchToStartScreen,
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
            backgroundColor: Colors.red.shade700, // Darker red for better contrast
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

    return Scaffold(
      // Light gray background for better contrast with white cards
      backgroundColor: Colors.grey[100],
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
                    color: Colors.blue[800], // Darker blue for better contrast
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 4,
                  color: Colors.white, // Explicit white background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultRow(
                          icon: Icons.timer,
                          label: 'Time Taken:',
                          value: '$minutes:${seconds.toString().padLeft(2, '0')}',
                          theme: theme,
                        ),
                        const SizedBox(height: 10),
                        _buildResultRow(
                          icon: Icons.question_answer,
                          label: 'Questions Attempted:',
                          value: '${widget.answeredQuestions.length}',
                          theme: theme,
                        ),
                        const SizedBox(height: 10),
                        _buildResultRow(
                          icon: Icons.check_circle,
                          label: 'Correct Answers:',
                          value: '$correctAnswers',
                          theme: theme,
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
                              color: Colors.red[700], // Darker red for better contrast
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
                                  ? Colors.green[700] // Darker green
                                  : Colors.red[700], // Darker red
                            ),
                            title: Text(
                              widget.answeredQuestions[index],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[800], // Dark gray for text
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
                      backgroundColor: Colors.blue[700], // Darker blue
                      foregroundColor: Colors.white, // White text
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
                      backgroundColor: Colors.green[700], // Darker green
                      foregroundColor: Colors.white, // White text
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

  Widget _buildResultRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700]), // Darker blue for icons
        const SizedBox(width: 10),
        Text(
          '$label ',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey[800], // Dark gray for labels
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey[900], // Nearly black for values
          ),
        ),
      ],
    );
  }
}












//////ofofonofnrfoelobifrioflkoif