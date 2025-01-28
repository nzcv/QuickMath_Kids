import 'package:flutter/material.dart';

class ResultRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final bool isDarkMode;

  const ResultRowWidget({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDarkMode ? Colors.blue[200] : Colors.blue[800],
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDarkMode ? Colors.grey[200] : Colors.grey[800],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDarkMode ? Colors.grey[200] : Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
