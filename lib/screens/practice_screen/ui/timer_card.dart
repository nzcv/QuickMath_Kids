import 'package:flutter/material.dart';

Widget buildTimerCard(String time, BuildContext context) {
  final theme = Theme.of(context);
  final screenWidth = MediaQuery.of(context).size.width;
  final scale = screenWidth / 360; 
  final adjustedScale = screenWidth > 600 ? scale.clamp(0.8, 1.2) : scale;
  final isTablet = screenWidth > 600;

  double paddingHorizontal = isTablet ? screenWidth * 0.06 : 16 * adjustedScale;
  double paddingVertical = isTablet ? screenWidth * 0.03 : 8 * adjustedScale;

  final isDarkMode = theme.brightness == Brightness.dark;
  final cardBackgroundColor = isDarkMode ? Colors.white : Colors.black;
  final textColor = isDarkMode ? Colors.black : Colors.white;

  return Card(
    elevation: theme.cardTheme.elevation, 
    shape: theme.cardTheme.shape, 
    color: cardBackgroundColor, 
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
              color: textColor, 
            ),
          ),
          SizedBox(height: 4 * adjustedScale),
          Text(
            time,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: textColor, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}