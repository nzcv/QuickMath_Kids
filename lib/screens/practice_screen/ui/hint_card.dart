import 'package:flutter/material.dart';

Widget buildHintCard(String currentHintMessage, bool isExpanded, VoidCallback onTap, BuildContext context) {
  final theme = Theme.of(context);
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Scale padding and font sizes
  double padding = screenWidth * 0.04; // 4% of screen width
  double fontSizeTitle = screenWidth * 0.045; // ~18 on 400px wide screen
  double fontSizeHint = screenWidth * 0.04;   // ~16 on 400px wide screen
  double iconSize = screenWidth * 0.06;       // Scales icon size

  return Card(
    color: theme.brightness == Brightness.dark ? Colors.grey[200] : Colors.grey[800],
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(screenWidth * 0.04), // Scales radius
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
                  size: iconSize.clamp(20, 30), // Min 20, max 30
                ),
                SizedBox(width: screenWidth * 0.02), // Scales spacing
                Text(
                  'Hint',
                  style: TextStyle(
                    fontSize: fontSizeTitle.clamp(16, 18), // Min 16, max 18
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
              SizedBox(height: screenHeight * 0.01), // Scales spacing
              AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  currentHintMessage,
                  style: TextStyle(
                    fontSize: fontSizeHint.clamp(14, 16), // Min 14, max 16
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