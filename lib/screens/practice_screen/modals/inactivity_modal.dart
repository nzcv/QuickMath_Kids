import 'package:flutter/material.dart';

class InActivityModal extends StatelessWidget {
  final VoidCallback onResume;

  const InActivityModal({required this.onResume, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'No Activity Detected',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Text(
        'You have been inactive for a while.',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: onResume,
          child: Text(
            'Resume Quiz',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
