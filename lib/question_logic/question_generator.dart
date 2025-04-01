import 'dart:math';

enum Operation {
  additionBeginner,
  additionIntermediate,
  additionAdvanced,
  subtractionBeginner,
  subtractionIntermediate,
  multiplicationTables,
  divisionBasic,
  divisionMixed,
  lcm,
  gcf,
}

class QuestionGenerator {
  List<int> generateTwoRandomNumbers(Operation operation, String dropdownValue) {
    final random = Random();
    int num1 = 0;
    int num2 = 0;
    int num3 = 0;
    int correctAnswer = 0;

    switch (operation) {
      case Operation.additionBeginner:
        if (dropdownValue == '1-5') {
          num1 = random.nextInt(5) + 1;
          num2 = random.nextInt(5) + 1;
        } else if (dropdownValue == '6-10') {
          num1 = random.nextInt(5) + 6;
          num2 = random.nextInt(5) + 1;
        }
        correctAnswer = num1 + num2;
        break;

      case Operation.additionIntermediate:
        if (dropdownValue == '10-20') {
          do {
            num1 = random.nextInt(11) + 10;
            num2 = random.nextInt(11) + 1;
          } while (num1 + num2 > 20);
        } else if (dropdownValue == '20-50') {
          do {
            num1 = random.nextInt(31) + 20;
            num2 = random.nextInt(31) + 1;
          } while (num1 + num2 > 50);
        }
        correctAnswer = num1 + num2;
        break;

      case Operation.additionAdvanced:
        if (dropdownValue == '50-100') {
          do {
            num1 = random.nextInt(51) + 50;
            num2 = random.nextInt(51) + 1;
          } while (num1 + num2 > 100);
        } else if (dropdownValue == '100-200') {
          do {
            num1 = random.nextInt(101) + 100;
            num2 = random.nextInt(101) + 1;
          } while (num1 + num2 > 200);
        }
        correctAnswer = num1 + num2;
        break;

      case Operation.subtractionBeginner:
        if (dropdownValue == '1-10') {
          num1 = random.nextInt(10) + 1;
          num2 = random.nextInt(num1) + 1;
        } else if (dropdownValue == '10-20') {
          num1 = random.nextInt(11) + 10;
          num2 = random.nextInt(num1 - 9) + 1;
        }
        correctAnswer = num1 - num2;
        break;

      case Operation.subtractionIntermediate:
        if (dropdownValue == '20-50') {
          num1 = random.nextInt(31) + 20;
          num2 = random.nextInt(num1 - 19) + 1;
        } else if (dropdownValue == '50-100') {
          num1 = random.nextInt(51) + 50;
          num2 = random.nextInt(num1 - 49) + 1;
        }
        correctAnswer = num1 - num2;
        break;

      case Operation.multiplicationTables:
        int multiplierRange = dropdownValue == '2-5' ? 5 : 10;
        int minMultiplier = dropdownValue == '2-5' ? 2 : 6;
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(multiplierRange - minMultiplier + 1) + minMultiplier;
        correctAnswer = num1 * num2;
        break;

      case Operation.divisionBasic:
        int divisor = int.parse(dropdownValue.split(' ').last);
        correctAnswer = random.nextInt(10) + 1;
        num1 = correctAnswer * divisor;
        num2 = divisor;
        break;

      case Operation.divisionMixed:
        num2 = random.nextInt(9) + 2; // 2 to 10
        correctAnswer = random.nextInt(10) + 1; // 1 to 10
        num1 = num2 * correctAnswer;
        break;

      case Operation.lcm:
        int maxLimit = dropdownValue.contains('3 numbers') 
            ? int.parse(dropdownValue.split(' ').last)
            : int.parse(dropdownValue.split(' ').last);
        if (dropdownValue.contains('3 numbers')) {
          List<int> nums = _generateThreeUniqueRandomNumbers(maxLimit);
          correctAnswer = calculateLCM3(nums[0], nums[1], nums[2]);
          return [...nums, correctAnswer];
        } else {
          num1 = random.nextInt(maxLimit) + 1;
          num2 = random.nextInt(maxLimit) + 1;
          correctAnswer = calculateLCM(num1, num2);
        }
        break;

      case Operation.gcf:
        int maxLimit = int.parse(dropdownValue.split(' ').last);
        num1 = random.nextInt(maxLimit) + 1;
        num2 = random.nextInt(maxLimit) + 1;
        correctAnswer = calculateGCF(num1, num2);
        break;
    }

    return num3 != 0 
        ? [num1, num2, num3, correctAnswer] 
        : [num1, num2, correctAnswer];
  }

  // Rest of the existing helper methods remain unchanged
  int calculateGCF(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  int calculateLCM(int a, int b) {
    return (a * b) ~/ calculateGCF(a, b);
  }

  int calculateLCM3(int a, int b, int c) {
    int lcm = calculateLCM(a, b);
    return calculateLCM(lcm, c);
  }

  List<int> _generateThreeUniqueRandomNumbers(int maxLimit) {
    final random = Random();
    Set<int> nums = {};
    while (nums.length < 3) {
      nums.add(random.nextInt(maxLimit) + 1);
    }
    return nums.toList();
  }
}