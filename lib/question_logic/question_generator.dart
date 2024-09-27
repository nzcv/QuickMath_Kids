import 'dart:math';

enum Operation {
  addition2A,
  additionA,
  additionB,
  subtractionA,
  subtractionB,
  multiplicationC,
  multiplicationD,
  divisionC,
  divisionD
}

class QuestionGenerator {
  final Random _random = Random();

  // Generate a random number within a range
  int _getRandomNumberInRange(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  List<int> generateTwoRandomNumbers(Operation operation, String dropdownValue) {
    int num1 = 0;
    int num2 = 0;
    int correctAnswer = 0;

    // Addition operations
    if (operation == Operation.addition2A) {
      // Addition of the form x + 1, x + 2, ..., x + 5
      num1 = _getRandomNumberInRange(10, 50); // Choose x in a reasonable range
      int increment = _random.nextInt(5) + 1; // Increment between 1 and 5
      num2 = num1 + increment; // This will be the result of num1 + increment
      correctAnswer = num2;
    } else if (operation == Operation.additionA) {
      // Sum of numbers from 15, 18, 20, 22, 24, 26, 28, 50
      List<int> possibleNumbers = [15, 18, 20, 22, 24, 26, 28, 50];
      num1 = possibleNumbers[_random.nextInt(possibleNumbers.length)];
      num2 = possibleNumbers[_random.nextInt(possibleNumbers.length)];
      correctAnswer = num1 + num2;
    } else if (operation == Operation.additionB) {
      // Sum of two-digit numbers with the sum up to 100, 150, 200, 250
      List<int> sumLimits = [100, 150, 200, 250];
      int maxSum = sumLimits[_random.nextInt(sumLimits.length)];
      num1 = _getRandomNumberInRange(10, maxSum ~/ 2);
      num2 = _getRandomNumberInRange(10, maxSum - num1);
      correctAnswer = num1 + num2;
    }

    // Subtraction operations
    else if (operation == Operation.subtractionA) {
      // Numbers up to 5, 7, 9, 11, etc. in 10 - x, 11 - x format
      List<int> upperLimits = [5, 7, 9, 11, 12, 14, 16, 18, 20];
      num1 = upperLimits[_random.nextInt(upperLimits.length)];
      num2 = _random.nextInt(num1) + 1; // Ensure num2 <= num1
      correctAnswer = num1 - num2;
    } else if (operation == Operation.subtractionB) {
      // Subtraction of two-digit numbers
      num1 = _getRandomNumberInRange(10, 99);
      num2 = _getRandomNumberInRange(10, num1); // Ensure num2 <= num1
      correctAnswer = num1 - num2;
    }

    // Multiplication operations
    else if (operation == Operation.multiplicationC) {
      // Multiplication of tables 2, 3, 4, 5, etc.
      List<int> possibleTables = [2, 3, 4, 5, 6, 7, 8, 9];
      num1 = possibleTables[_random.nextInt(possibleTables.length)];
      num2 = _getRandomNumberInRange(2, 10); // Random multiplier between 2 and 10
      correctAnswer = num1 * num2;
    }

    // Division operations
    else if (operation == Operation.divisionC) {
      // Division by 2, 3, 4, etc.
      List<int> possibleDivisors = [2, 3, 4, 5, 6, 7, 8, 9];
      num2 = possibleDivisors[_random.nextInt(possibleDivisors.length)];
      correctAnswer = _getRandomNumberInRange(2, 10); // Quotient between 2 and 10
      num1 = num2 * correctAnswer; // Ensure num1 is divisible by num2
    } else if (operation == Operation.divisionD) {
      // Division of two-digit numbers, quotient of 2 or more digits
      num2 = _getRandomNumberInRange(10, 99); // Two-digit divisor
      correctAnswer = _getRandomNumberInRange(10, 99); // Quotient with two or more digits
      num1 = num2 * correctAnswer;
    }

    return [num1, num2, correctAnswer];
  }

  // Generates a random number between 1 and 100
  int generateRandomNumber() {
    return _random.nextInt(100) + 1;
  }
}
