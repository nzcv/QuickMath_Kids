import 'package:flutter/material.dart';

Widget buildHintCard(String currentHintMessage, bool isExpanded, VoidCallback onTap, BuildContext context) {
  final theme = Theme.of(context); // Get the current theme

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb,
                  color: theme.brightness == Brightness.dark
                      ? Colors.amber[400] // Dark mode: lighter amber
                      : Colors.amber[700], // Light mode: darker amber
                ),
                const SizedBox(width: 8),
                Text(
                  'Hint',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[300] // Dark mode: lighter text
                        : Colors.grey[500], // Light mode: standard grey
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  currentHintMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[400] // Dark mode: lighter hint message
                        : Colors.grey[300], // Light mode: standard grey
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
