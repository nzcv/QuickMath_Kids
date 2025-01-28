import 'package:flutter/material.dart';

Widget buildPauseButton(VoidCallback onPressed, BuildContext context) {
  final theme = Theme.of(context); // Get the current theme

  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.brightness == Brightness.dark
          ? Colors.blue[300] // Lighter blue for dark mode
          : Colors.blue[700], // Darker blue for light mode
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      elevation: 8,
    ),
    child: Icon(
      Icons.pause,
      size: 32,
      color: theme.brightness == Brightness.dark
          ? Colors.black // Dark mode: icon color darker
          : Colors.white, // Light mode: icon color white
    ),
  );
}
