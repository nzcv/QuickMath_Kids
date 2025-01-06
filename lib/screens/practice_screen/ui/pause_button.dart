import'package:flutter/material.dart';

Widget buildPauseButton(VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[700],
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      elevation: 8,
    ),
    child: const Icon(
      Icons.pause,
      size: 32,
      color: Colors.white,
    ),
  );
}