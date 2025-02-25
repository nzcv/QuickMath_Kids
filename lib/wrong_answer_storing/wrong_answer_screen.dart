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
      _wrongQuestions = questions; // Fallback to empty list if null
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
      // If removal fails, restore the item and notify the user
      setState(() {
        _wrongQuestions.insert(index, questionToRemove);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove question: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrong Answers History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wrongQuestions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No wrong answers yet!',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Keep practicing to improve your skills',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _wrongQuestions.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final question = _wrongQuestions[index];
                    // Use a unique identifier if available, otherwise combine fields
                    final uniqueKey = question['id'] != null
                        ? question['id'].toString()
                        : '${question['question']}_${index}_${question['timestamp'] ?? ''}';

                    return Dismissible(
                      key: ValueKey(uniqueKey), // Use a truly unique key
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _removeWrongQuestion(index);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.category,
                                      size: 16,
                                      color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    question['category'] ?? 'Unknown category',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Question: ${question['question'] ?? 'N/A'}',
                                style: const TextStyle(
                                    color: Colors.deepOrange, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.close,
                                      color: theme.colorScheme.error, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Your answer: ${question['userAnswer'] ?? 'N/A'}',
                                    style: TextStyle(
                                        color: theme.colorScheme.error),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.check,
                                      color: theme.colorScheme.primary,
                                      size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Correct answer: ${question['correctAnswer'] ?? 'N/A'}',
                                    style: TextStyle(
                                        color: theme.colorScheme.primary),
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