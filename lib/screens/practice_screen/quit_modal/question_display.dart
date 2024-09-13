import 'package:flutter/material.dart';

class QuestionDisplay extends StatelessWidget {
  final String questionText;
  final TextEditingController textController;
  final Function(String) triggerTTS;

  const QuestionDisplay({
    required this.questionText,
    required this.textController,
    required this.triggerTTS,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.speaker),
            iconSize: 150,
            color: Colors.black,
            onPressed: () {
              triggerTTS(questionText);
            },
          ),
          const SizedBox(height: 20),
          Text(
            questionText,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'What\'s your answer?',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
