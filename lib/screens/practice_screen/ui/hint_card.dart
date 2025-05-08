import 'package:flutter/material.dart';

Widget buildHintCard(String currentHintMessage, bool isExpanded, VoidCallback onTap, BuildContext context) {
  final theme = Theme.of(context);
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  double padding = screenWidth * 0.04;
  double fontSizeTitle = screenWidth * 0.045;
  double fontSizeHint = screenWidth * 0.04;
  double iconSize = screenWidth * 0.06;

  return Card(
    color: theme.brightness == Brightness.dark ? Colors.grey[200] : Colors.grey[800],
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(screenWidth * 0.04),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb,
                  color: theme.brightness == Brightness.dark
                      ? Colors.amber[400]
                      : Colors.amber[700],
                  size: iconSize.clamp(20, 30),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Hint',
                  style: TextStyle(
                    fontSize: fontSizeTitle.clamp(16, 18),
                    color: theme.brightness == Brightness.dark
                        ? Colors.black
                        : Colors.grey[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
              ],
            ),
            if (isExpanded) ...[
              SizedBox(height: screenHeight * 0.01),
              AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  currentHintMessage,
                  style: TextStyle(
                    fontSize: fontSizeHint.clamp(14, 16),
                    color: theme.brightness == Brightness.dark
                        ? Colors.black
                        : Colors.grey[400],
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