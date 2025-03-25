import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WrongQuestionsService {
  static const String _key = 'wrong_questions';

  static Future<void> saveWrongQuestion({
    required String question,
    required int userAnswer,
    required int correctAnswer,
    required String category,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingQuestions = prefs.getStringList(_key) ?? [];

    Map<String, dynamic> questionData = {
      'question': question,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'category': category,
      'correctSessionTimestamps': [], // List to track sessions where answered correctly
      'timestamp': DateTime.now().toIso8601String(),
    };

    existingQuestions.add(jsonEncode(questionData));
    await prefs.setStringList(_key, existingQuestions);
  }

  static Future<List<Map<String, dynamic>>> getWrongQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedQuestions = prefs.getStringList(_key) ?? [];
    return storedQuestions
        .map((string) => jsonDecode(string) as Map<String, dynamic>)
        .toList();
  }

  static Future<void> updateWrongQuestion(String question,
      {bool correct = false}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedQuestions = prefs.getStringList(_key) ?? [];
    bool updated = false;

    for (int i = 0; i < storedQuestions.length; i++) {
      Map<String, dynamic> questionData = jsonDecode(storedQuestions[i]);
      if (questionData['question'] == question) {
        List<String> correctSessionTimestamps =
            List<String>.from(questionData['correctSessionTimestamps'] ?? []);

        if (correct) {
          // Add the current session timestamp
          correctSessionTimestamps.add(DateTime.now().toIso8601String());
          // Keep only the last 3 timestamps
          if (correctSessionTimestamps.length > 3) {
            correctSessionTimestamps = correctSessionTimestamps.sublist(
                correctSessionTimestamps.length - 3);
          }
          questionData['correctSessionTimestamps'] = correctSessionTimestamps;

          // Check if the question was answered correctly in 3 consecutive sessions
          if (correctSessionTimestamps.length >= 3) {
            storedQuestions.removeAt(i); // Remove the question
          } else {
            storedQuestions[i] = jsonEncode(questionData);
          }
        } else {
          // Reset the correct session timestamps if answered incorrectly
          questionData['correctSessionTimestamps'] = [];
          storedQuestions[i] = jsonEncode(questionData);
        }
        updated = true;
        break;
      }
    }

    if (!updated && !correct) {
      return;
    }

    await prefs.setStringList(_key, storedQuestions);
  }

  static Future<void> removeWrongQuestion(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedQuestions = prefs.getStringList(_key) ?? [];
    if (index >= 0 && index < storedQuestions.length) {
      storedQuestions.removeAt(index);
      await prefs.setStringList(_key, storedQuestions);
    }
  }

  static Future<void> clearWrongQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}