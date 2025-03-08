import 'package:flutter/material.dart';

Widget buildPauseButton(VoidCallback onPressed, BuildContext context) {
  final theme = Theme.of(context); 

  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.brightness == Brightness.dark
          ? Colors.blue[300]
          : Colors.blue[700],
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      elevation: 8,
    ),
    child: Icon(
      Icons.pause,
      size: 32,
      color: theme.brightness == Brightness.dark
          ? Colors.black 
          : Colors.white,
    ),
  );
}
