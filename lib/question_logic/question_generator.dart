
import 'dart:math';

enum Operation {
  addition_2A,
  addition_A,
  addition_B,
  subtraction_A,
  subtraction_B,
  multiplication_C,
  division_C,
  division_D,
  lcm,
  gcf,
}

class QuestionGenerator {
  int getRangeLimit(String dropdownValue) {
    if (dropdownValue == 'Divided by 2') {
      return 2;
    } else if (dropdownValue == 'Divided by 5') {
      return 5;
    } else if (dropdownValue == 'Divided by 10') {
      return 10;
    } else if (dropdownValue == 'Divided by 20') {
      return 20;
    } else if (dropdownValue == 'Divided by 50') {
      return 50;
    }

    return 10; // Default value
  }

  int calculateGCF(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a; // No forced minimum value
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

  List<int> generateTwoRandomNumbers(
      Operation operation, String dropdownValue) {
    final random = Random();
    int num1 = 0;
    int num2 = 0;
    int num3 = 0;
    int correctAnswer = 0;

    if (operation == Operation.addition_2A) {
      if (dropdownValue == 'Upto +5') {
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(5) + 1;
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Upto +10') {
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(10) + 1;
        correctAnswer = num1 + num2;
      }
    } else if (operation == Operation.addition_A) {
      if (dropdownValue == 'Sum of 15') {
        do {
          num1 = random.nextInt(16) + 1;
          num2 = random.nextInt(16) + 1;
        } while (num1 + num2 > 15);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 18') {
        do {
          num1 = random.nextInt(19) + 1;
          num2 = random.nextInt(19) + 1;
        } while (num1 + num2 > 18);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 20') {
        do {
          num1 = random.nextInt(21) + 1;
          num2 = random.nextInt(21) + 1;
        } while (num1 + num2 > 20);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 22') {
        do {
          num1 = random.nextInt(23) + 1;
          num2 = random.nextInt(23) + 1;
        } while (num1 + num2 > 22);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 24') {
        do {
          num1 = random.nextInt(25) + 1;
          num2 = random.nextInt(25) + 1;
        } while (num1 + num2 > 24);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 26') {
        do {
          num1 = random.nextInt(27) + 1;
          num2 = random.nextInt(27) + 1;
        } while (num1 + num2 > 26);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 28') {
        do {
          num1 = random.nextInt(29) + 1;
          num2 = random.nextInt(29) + 1;
        } while (num1 + num2 > 28);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum of 50') {
        num1 = random.nextInt(51) + 1;
        num2 = random.nextInt(51) + 1;
        correctAnswer = num1 + num2;
      }
    } else if (operation == Operation.addition_B) {
      if (dropdownValue == 'Sum upto 100') {
        do {
          num1 = random.nextInt(101) + 1;
          num2 = random.nextInt(101) + 1;
        } while (num1 + num2 > 100);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum upto 150') {
        do {
          num1 = random.nextInt(151) + 1;
          num2 = random.nextInt(151) + 1;
        } while (num1 + num2 > 150);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum upto 200') {
        do {
          num1 = random.nextInt(200) + 1;
          num2 = random.nextInt(200) + 1;
        } while (num1 + num2 > 200);
        correctAnswer = num1 + num2;
      } else if (dropdownValue == 'Sum upto 250') {
        do {
          num1 = random.nextInt(251) + 1;
          num2 = random.nextInt(251) + 1;
        } while (num1 + num2 > 250);
        correctAnswer = num1 + num2;
      }
    } else if (operation == Operation.subtraction_A) {
      if (dropdownValue.startsWith('Upto')) {
        int maxLimit = int.parse(dropdownValue.split(' ')[1]);
        num1 = random.nextInt(maxLimit + 10) + 1;
        num2 = random.nextInt(num1) + 1;
        correctAnswer = num1 - num2;
      }
    } else if (operation == Operation.subtraction_B) {
      if (dropdownValue == 'Less than 20') {
        num1 = random.nextInt(20) + 20;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
      } else if (dropdownValue == 'Less than 40') {
        num1 = random.nextInt(40) + 40;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
      } else if (dropdownValue == 'Less than 60') {
        num1 = random.nextInt(60) + 60;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
      } else if (dropdownValue == 'Less than 80') {
        num1 = random.nextInt(80) + 80;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
      } else if (dropdownValue == 'Less than 100') {
        num1 = random.nextInt(100) + 100;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
      }
    } else if (operation == Operation.multiplication_C) {
      if (dropdownValue.startsWith('x')) {
        int multiplier = int.parse(dropdownValue.substring(1));
        num1 = random.nextInt(10) + 1;
        num2 = multiplier;
        correctAnswer = num1 * num2;
      }
    } else if (operation == Operation.division_C) {
      if (dropdownValue.startsWith('Divided')) {
        int divisor = int.parse(dropdownValue.split(' ')[2]);
        correctAnswer = random.nextInt(10) + 1;
        num1 = correctAnswer * divisor;
        num2 = divisor;
      }
    } else if (operation == Operation.division_D) {
      num2 = random.nextInt(5) + 1;
      correctAnswer = random.nextInt(10) + 1;
      num1 = num2 * correctAnswer;
    } else if (operation == Operation.lcm) {
      // LCM logic
      int maxLimit = 10;
      if (dropdownValue.startsWith('upto')) {
        maxLimit = int.parse(dropdownValue.split(' ')[1]);
      }

      num1 = random.nextInt(maxLimit) + 1;
      num2 = random.nextInt(maxLimit) + 1;

      if (dropdownValue.contains('3 numbers')) {
        // 3-number LCM logic for specific ranges
        List<int> nums = [];

        // Validate range parameter
        if (dropdownValue == '3 numbers upto 10') {
          nums = _generateThreeUniqueRandomNumbers(10);
        } else if (dropdownValue == '3 numbers upto 20') {
          nums = _generateThreeUniqueRandomNumbers(20);
        } else if (dropdownValue == '3 numbers upto 30') {
          nums = _generateThreeUniqueRandomNumbers(30);
        } else if (dropdownValue == '3 numbers upto 40') {
          nums = _generateThreeUniqueRandomNumbers(40);
        } else if (dropdownValue == '3 numbers upto 50') {
          nums = _generateThreeUniqueRandomNumbers(50);
        } else {
          // Fallback to default range
          nums = _generateThreeUniqueRandomNumbers(10);
        }

        // Calculate LCM of all three numbers
        int correctAnswer = calculateLCM3(nums[0], nums[1], nums[2]);

        // Return the three numbers and their LCM
        return [...nums, correctAnswer];
      } else {
        // 2-number LCM
        correctAnswer = calculateLCM(num1, num2);
        return [num1, num2, correctAnswer];
      }
    } else if (operation == Operation.gcf) {
      // GCF logic
      int maxLimit = 10;
      if (dropdownValue.startsWith('upto')) {
        maxLimit = int.parse(dropdownValue.split(' ')[1]);
      }

      num1 = random.nextInt(maxLimit) + 1;
      num2 = random.nextInt(maxLimit) + 1;
      correctAnswer = calculateGCF(num1, num2);
      return [num1, num2, correctAnswer];
    }

    return num3 != 0
        ? [num1, num2, num3, correctAnswer]
        : [num1, num2, correctAnswer];
  }

  int generateRandomNumber() {
    final random = Random();
    return random.nextInt(100) + 1; // Generate random number between 1 and 100
  }
}
