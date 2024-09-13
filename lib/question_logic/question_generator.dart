import 'dart:math';

enum Operation { addition, subtraction, multiplication, division }

class QuestionGenerator {
  // Define range limits for different dropdown options
  int getRangeLimit(String dropdownValue) {
    if (dropdownValue == 'Upto +3') {
      return 3;
    } else if (dropdownValue == 'Upto +5') {
      return 5;
    } else if (dropdownValue == 'Upto +10') {
      return 10;
    } else if (dropdownValue == 'Subtract 3') {
      return 3;
    } else if (dropdownValue == 'Subtract 5') {
      return 5;
    } else if (dropdownValue == 'Multiply by 3') {
      return 3;
    } else if (dropdownValue == 'Multiply by 5') {
      return 5;
    } else if (dropdownValue == 'Divide by 3') {
      return 3;
    } else if (dropdownValue == 'Divide by 5') {
      return 5;
    } else {
      return 10; // Default value
    }
  }

  List<int> generateTwoRandomNumbers(Operation operation, String dropdownValue) {
    final random = Random();
    int num1 = 0;
    int num2 = 0;
    int correctAnswer = 0;

    int rangeLimit = getRangeLimit(dropdownValue);

    if (operation == Operation.addition) {
      num1 = random.nextInt(50) + 1;
      num2 = random.nextInt(rangeLimit) + 1;
      correctAnswer = num1 + num2;
    } else if (operation == Operation.subtraction) {
      num1 = random.nextInt(rangeLimit) + 1;
      num2 = random.nextInt(num1) + 1; // Ensure num2 <= num1
      correctAnswer = num1 - num2;
    } else if (operation == Operation.multiplication) {
      num1 = random.nextInt(10) + 1;
      num2 = random.nextInt(rangeLimit) + 1;
      correctAnswer = num1 * num2;
    } else if (operation == Operation.division) {
      num2 = random.nextInt(10) + 1; // num2 should be between 1 and rangeLimit
      correctAnswer = random.nextInt(10) + 1; // correctAnswer should be between 1 and rangeLimit
      num1 = num2 * correctAnswer; // num1 is a multiple of num2
    }

    return [num1, num2, correctAnswer];
  }

  int generateRandomNumber() {
    final random = Random();
    return random.nextInt(100) + 1; // Generate random number between 1 and 100
  }
}
