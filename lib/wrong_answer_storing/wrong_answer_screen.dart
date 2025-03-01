import 'package:flutter/material.dart';
import 'wrong_answer_service.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({Key? key}) : super(key: key);

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  List<Map<String, dynamic>> _wrongQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWrongQuestions();
  }

  Future<void> _loadWrongQuestions() async {
    setState(() {
      _isLoading = true;
    });

    final questions = await WrongQuestionsService.getWrongQuestions();

    setState(() {
      _wrongQuestions = questions;
      _isLoading = false;
    });
  }

  Future<void> _removeWrongQuestion(int index) async {
    final questionToRemove = _wrongQuestions[index];
    setState(() {
      _wrongQuestions.removeAt(index);
    });

    try {
      await WrongQuestionsService.removeWrongQuestion(index);
    } catch (e) {
      setState(() {
        _wrongQuestions.insert(index, questionToRemove);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove question: $e')),
      );
    }
  }

  Future<void> _clearAllWrongQuestions() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Wrong Answers'),
        content: const Text('Are you sure you want to clear all wrong answers? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await WrongQuestionsService.clearWrongQuestions();
        setState(() {
          _wrongQuestions.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All wrong answers cleared')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear questions: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrong Answers History'),
        actions: [
          if (!_isLoading && _wrongQuestions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all wrong answers',
              onPressed: _clearAllWrongQuestions,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wrongQuestions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 64, color: theme.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text('No wrong answers yet!', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Keep practicing to improve your skills', style: theme.textTheme.bodyLarge),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _wrongQuestions.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final question = _wrongQuestions[index];
                    final uniqueKey = question['timestamp'] ?? '${question['question']}_$index';

                    return Dismissible(
                      key: ValueKey(uniqueKey),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) => _removeWrongQuestion(index),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16), // Note: 'bottom' should replace 'custom'
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.category, size: 16, color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    question['category'] ?? 'Unknown category',
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Question: ${question['question'] ?? 'N/A'}',
                                style: const TextStyle(color: Colors.deepOrange, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.close, color: theme.colorScheme.error, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Your answer: ${question['userAnswer'] ?? 'N/A'}',
                                    style: TextStyle(color: theme.colorScheme.error),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.check, color: theme.colorScheme.primary, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Correct answer: ${question['correctAnswer'] ?? 'N/A'}',
                                    style: TextStyle(color: theme.colorScheme.primary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Times answered correctly: ${question['correctCount'] ?? 0}',
                                    style: TextStyle(color: Colors.yellow[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}