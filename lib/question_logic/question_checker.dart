class QuestionChecker {
  static String checkAnswer(int userAnswer, int correctAnswer) {
    return userAnswer == correctAnswer ? "Correct" : "Wrong";
  }
}
