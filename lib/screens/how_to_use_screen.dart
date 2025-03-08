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
              "Get Started with QuickMath Kids!",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "QuickMath Kids makes math practice fun and interactive with audio-based questions. Follow these steps to start learning:",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            _buildStep(
              context,
              "1. Select Your Math Operation",
              "From the home screen, pick an operation to practice: Addition, Subtraction, Multiplication, or Division.",
            ),
            _buildStep(
              context,
              "2. Choose a Difficulty Range",
              "Select a range that matches your skill level, like 'Up to +5' or 'Up to +10'.",
            ),
            _buildStep(
              context,
              "3. Set a Time Limit (Optional)",
              "Tap the time limit field to open the scroll wheel. Choose a duration (1-60 minutes) or select 'No time limit' to practice endlessly.",
            ),
            _buildStep(
              context,
              "4. Begin Your Practice",
              "Hit 'Start Oral Practice' to launch the quiz. Questions will be spoken aloud based on your choices.",
            ),
            _buildStep(
              context,
              "5. Answer Questions",
              "Listen to each question (tap the voice button to replay), then pick the correct answer from three options.",
            ),
            _buildStep(
              context,
              "6. Manage Your Session",
              "Pause to take a break or quit to return to the start screen. With a time limit, the session ends automatically when time’s up.",
            ),
            _buildStep(
              context,
              "7. Review Wrong Answers",
              "Missed a question? Check 'Wrong Answers History' in the drawer to see what you got wrong and practice again.",
            ),
            _buildStep(
              context,
              "8. See Your Results",
              "Finish by tapping 'Results' to view your time, total questions, and correct answers. Wrong answers are saved for later review.",
            ),
            _buildStep(
              context,
              "9. Share Your Progress",
              "From the results screen, tap 'Share Report' to create and send a PDF of your quiz performance.",
            ),
            const SizedBox(height: 20),
            Text(
              "Enjoy sharpening your math skills with QuickMath Kids—practice anytime, anywhere, offline!",
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