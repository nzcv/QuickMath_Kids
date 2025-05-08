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
      'correctCount': 0,
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

  // Update the removeWrongQuestion method to remove by question text instead of index
  static Future<void> removeWrongQuestion(String questionText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedQuestions = prefs.getStringList(_key) ?? [];

    storedQuestions.removeWhere((q) {
      final data = jsonDecode(q) as Map<String, dynamic>;
      return data['question'] == questionText;
    });

    await prefs.setStringList(_key, storedQuestions);
  }

// Update updateWrongQuestion to better handle question matching
  static Future<void> updateWrongQuestion(String questionText,
      {required bool correct}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedQuestions = prefs.getStringList(_key) ?? [];
    bool updated = false;

    for (int i = 0; i < storedQuestions.length; i++) {
      Map<String, dynamic> questionData = jsonDecode(storedQuestions[i]);
      if (questionData['question'].toString().trim() == questionText.trim()) {
        if (correct) {
          int correctCount = (questionData['correctCount'] ?? 0) + 1;
          questionData['correctCount'] = correctCount;

          if (correctCount >= 3) {
            storedQuestions.removeAt(i);
          } else {
            storedQuestions[i] = jsonEncode(questionData);
          }
        } else {
          questionData['correctCount'] = 0;
          storedQuestions[i] = jsonEncode(questionData);
        }
        updated = true;
        break;
      }
    }

    await prefs.setStringList(_key, storedQuestions);
  }

  static Future<void> clearWrongQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
