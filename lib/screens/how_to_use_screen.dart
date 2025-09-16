import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How to Use QuickMath Kids',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Container(
        color: theme.colorScheme.background,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isTablet ? 800 : 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildIntro(context),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  _buildFooter(context),
                ],
              ),
            ),
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
        Icon(Icons.school, color: theme.colorScheme.primary, size: 36),
        const SizedBox(width: 12),
        Text(
          "Get Started!",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildIntro(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "QuickMath Kids makes math fun with audio-based questions. Follow these steps to start learning!",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
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
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
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
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}