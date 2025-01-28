import 'package:flutter/material.dart';

Widget buildTimerCard(String time, BuildContext context) {
  final theme = Theme.of(context); // Get current theme

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    color:  theme.brightness == Brightness.dark
                  ? Colors.white // Light text for dark mode
                  : Colors.black, // Grey text for light mode, // Use the card color from the current theme
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Column(
        children: [
          Text(
            'Time',
            style: TextStyle(
              fontSize: 18,
              color: theme.brightness == Brightness.dark
                  ? Colors.black // Light text for dark mode
                  : Colors.grey[400], // Grey text for light mode
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 36,
              color: theme.brightness == Brightness.dark
                  ? Colors.blue[300] // Lighter blue for dark mode
                  : Colors.blue[700], // Darker blue for light mode
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
