// answer_options.dart
import 'dart:math';

List<int> generateAnswerOptions(int correctAnswer) {
  List<int> answerOptions = [correctAnswer];
  final random = Random();

  while (answerOptions.length < 3) {
    int option = correctAnswer + random.nextInt(10) - 5;

    // Ensure the options are unique and positive
    if (!answerOptions.contains(option) && option > 0) {
      answerOptions.add(option);
    }
  }

  answerOptions.shuffle();
  return answerOptions;
}
