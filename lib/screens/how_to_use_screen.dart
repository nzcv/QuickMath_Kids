import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to Use QuickMath Kids',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
        shadowColor: theme.colorScheme.primary.withOpacity(0.5),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.background,
              theme.colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildIntro(context),
              const SizedBox(height: 20),
              _buildStep(
                context,
                "1. Select Your Math Operation",
                "From the home screen, pick an operation to practice: Addition, Subtraction, Multiplication, or Division.",
                Icons.calculate,
              ),
              _buildStep(
                context,
                "2. Choose a Difficulty Range",
                "Select a range that matches your skill level, like 'Up to +5' or 'Up to +10'.",
                Icons.tune,
              ),
              _buildStep(
                context,
                "3. Set a Time Limit (Optional)",
                "Tap the time limit field to open the scroll wheel. Choose a duration (1-60 minutes) or select 'No time limit'.",
                Icons.timer,
              ),
              _buildStep(
                context,
                "4. Begin Your Practice",
                "Hit 'Start Oral Practice' to launch the quiz. Questions will be spoken aloud.",
                Icons.play_circle_filled,
              ),
              _buildStep(
                context,
                "5. Answer Questions",
                "Listen to each question (tap the voice button to replay), then pick the correct answer.",
                Icons.volume_up,
              ),
              _buildStep(
                context,
                "6. Manage Your Session",
                "Pause to take a break or quit to return to the start screen.",
                Icons.pause_circle_outline,
              ),
              _buildStep(
                context,
                "7. Review Wrong Answers",
                "Check 'Wrong Answers History' in the drawer to practice missed questions.",
                Icons.history,
              ),
              _buildStep(
                context,
                "8. See Your Results",
                "View your time, total questions, and correct answers. Wrong answers are saved.",
                Icons.bar_chart,
              ),
              _buildStep(
                context,
                "9. Share Your Progress",
                "Tap 'Share Report' to create and send a PDF of your quiz performance.",
                Icons.share,
              ),
              const SizedBox(height: 20),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.school, color: theme.colorScheme.primary, size: 32),
        const SizedBox(width: 10),
        Text(
          "Get Started!",
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntro(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "QuickMath Kids makes math fun with audio-based questions. Follow these steps to start learning!",
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String title, String description, IconData icon) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Enjoy math anytime, anywhere, offline!",
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}