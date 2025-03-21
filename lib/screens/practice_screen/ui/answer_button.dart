import 'package:flutter/material.dart';

Widget buildAnswerButton(int answer, VoidCallback onPressed) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final theme = Theme.of(context);
      final screenWidth = MediaQuery.of(context).size.width;
      final buttonWidth = screenWidth * 0.5; // 35% of screen width, max 140
      final buttonHeight = screenWidth * 0.500; // Scales with width, ~50 on 400px
      final fontSize = screenWidth * 0.05; // ~20 on a 400px wide screen

      return SizedBox(
        width: buttonWidth.clamp(80, 170), // Min 80, max 140
        height: buttonHeight.clamp(40, 70), // Min 40, max 50
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.06), // Scales radius
            ),
            elevation: 4,
          ),
          child: Text(
            answer.toString(),
<<<<<<< Updated upstream
            style: TextStyle(
              fontSize: fontSize.clamp(16, 20), // Min 16, max 20
=======
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: fontSize.clamp(16, 20),
>>>>>>> Stashed changes
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}