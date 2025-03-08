import 'package:flutter/material.dart';

Widget buildTimerCard(String time, BuildContext context) {
  final theme = Theme.of(context);

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    color:  theme.brightness == Brightness.dark
                  ? Colors.white 
                  : Colors.black, 
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
                  ? Colors.black 
                  : Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 36,
              color: theme.brightness == Brightness.dark
                  ? Colors.blue[300] 
                  : Colors.blue[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
