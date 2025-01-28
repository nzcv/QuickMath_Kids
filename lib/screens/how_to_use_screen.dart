import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use QuickMath Kids',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              "Welcome to QuickMath Kids!",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "QuickMath Kids is designed to help children practice basic math operations in a fun and interactive way. Here's how to use the app:",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            _buildStep(
              context,
              "1. Choose an Operation",
              "On the home screen, select the math operation you want to practice (e.g., Addition, Subtraction, Multiplication, Division).",
            ),
            _buildStep(
              context,
              "2. Select a Range",
              "Choose the difficulty range for the questions (e.g., 'Upto +5', 'Upto +10').",
            ),
            _buildStep(
              context,
              "3. Start Practicing",
              "Tap the 'Start Oral Practice' button to begin. The app will generate questions based on your selected operation and range.",
            ),
            _buildStep(
              context,
              "4. Answer the Questions",
              "Listen to the question and select the correct answer from the options provided. You can also tap the voice button to hear the question again.",
            ),
            _buildStep(
              context,
              "5. View Results",
              "After completing the quiz, you can view your results, including the time taken, number of correct answers, and a detailed breakdown of your performance.",
            ),
            _buildStep(
              context,
              "6. Share Your Results",
              "You can share your quiz results as a PDF report with your parents or teachers.",
            ),
            const SizedBox(height: 20),
            Text(
              "We hope you enjoy using QuickMath Kids to improve your math skills!",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String title, String description) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}