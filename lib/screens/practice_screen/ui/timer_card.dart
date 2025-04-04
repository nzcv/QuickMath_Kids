import 'package:flutter/material.dart';

Widget buildTimerCard(String time, BuildContext context) {
  final theme = Theme.of(context);
  final screenWidth = MediaQuery.of(context).size.width;
  final scale = screenWidth / 360; // Base scaling factor
  final adjustedScale = screenWidth > 600 ? scale.clamp(0.8, 1.2) : scale;
  final isTablet = screenWidth > 600;

  // Use padding from the theme or scale appropriately
  double paddingHorizontal = isTablet ? screenWidth * 0.06 : 16 * adjustedScale;
  double paddingVertical = isTablet ? screenWidth * 0.03 : 8 * adjustedScale;

  // Determine background and text colors based on theme brightness
  final isDarkMode = theme.brightness == Brightness.dark;
  final cardBackgroundColor = isDarkMode ? Colors.white : Colors.black;
  final textColor = isDarkMode ? Colors.black : Colors.white;

  return Card(
    elevation: theme.cardTheme.elevation, // Use theme's elevation
    shape: theme.cardTheme.shape, // Use theme's shape (rounded corners)
    color: cardBackgroundColor, // Override the card's background color
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      child: Column(
        children: [
          Text(
            'Time',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor, // Override text color
            ),
          ),
          SizedBox(height: 4 * adjustedScale),
          Text(
            time,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: textColor, // Override text color (not using primary color anymore)
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}