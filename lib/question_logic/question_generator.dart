import 'dart:math';
import 'enum_values.dart';

class QuestionGenerator {
  List<int> generateTwoRandomNumbers(Operation operation, Range range) {
    final random = Random();
    int num1 = 0;
    int num2 = 0;
    int num3 = 0;
    int correctAnswer = 0;

    switch (operation) {
      case Operation.additionBeginner:
        if (range == Range.additionBeginner1to5) {
          num1 = random.nextInt(5) + 1;
          num2 = random.nextInt(5) + 1;
        } else if (range == Range.additionBeginner6to10) {
          num1 = random.nextInt(5) + 6;
          num2 = random.nextInt(5) + 1;
        }
        correctAnswer = num1 + num2;
        break;

      case Operation.additionIntermediate:
        if (range == Range.additionIntermediate10to20) {
          do {
            num1 = random.nextInt(11) + 10;
            num2 = random.nextInt(11) + 1;
          } while (num1 + num2 > 20);
        } else if (range == Range.additionIntermediate20to50) {
          do {
            num1 = random.nextInt(31) + 20;
            num2 = random.nextInt(31) + 1;
          } while (num1 + num2 > 50);
        }
        correctAnswer = num1 + num2;
        break;

      case Operation.additionAdvanced:
        if (range == Range.additionAdvanced50to100) {
          do {
            num1 = random.nextInt(51) + 50;
            num2 = random.nextInt(51) + 1;
          } while (num1 + num2 > 100);
        } else if (range == Range.additionAdvanced100to200) {
          do {
            num1 = random.nextInt(101) + 100;
            num2 = random.nextInt(101) + 1;
          } while (num1 + num2 > 200);
        }
        correctAnswer = num1 + num2;
        break;

      case Operation.subtractionBeginner:
        if (range == Range.subtractionBeginner1to10) {
          num1 = random.nextInt(10) + 1;
          num2 = random.nextInt(num1) + 1;
        } else if (range == Range.subtractionBeginner10to20) {
          num1 = random.nextInt(11) + 10;
          num2 = random.nextInt(num1 - 9) + 1;
        }
        correctAnswer = num1 - num2;
        break;

      case Operation.subtractionIntermediate:
        if (range == Range.subtractionIntermediate20to50) {
          num1 = random.nextInt(31) + 20;
          num2 = random.nextInt(num1 - 19) + 1;
        } else if (range == Range.subtractionIntermediate50to100) {
          num1 = random.nextInt(51) + 50;
          num2 = random.nextInt(num1 - 49) + 1;
        }
        correctAnswer = num1 - num2;
        break;

      case Operation.multiplicationTables:
        int multiplierRange = range == Range.multiplicationTables2to5 ? 5 : 10;
        int minMultiplier = range == Range.multiplicationTables2to5 ? 2 : 6;
        num1 = random.nextInt(10) + 1;
        num2 =
            random.nextInt(multiplierRange - minMultiplier + 1) + minMultiplier;
        correctAnswer = num1 * num2;
        break;

      case Operation.divisionBasic:
        int divisor;
        switch (range) {
          case Range.divisionBasicBy2:
            divisor = 2;
            break;
          case Range.divisionBasicBy3:
            divisor = 3;
            break;
          case Range.divisionBasicBy4:
            divisor = 4;
            break;
          case Range.divisionBasicBy5:
            divisor = 5;
            break;
          case Range.divisionBasicBy6:
            divisor = 6;
            break;
          case Range.divisionBasicBy7:
            divisor = 7;
            break;
          case Range.divisionBasicBy8:
            divisor = 8;
            break;
          case Range.divisionBasicBy9:
            divisor = 9;
            break;
          case Range.divisionBasicBy10:
            divisor = 10;
            break;
          default:
            divisor = 2;
        }
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
        int maxLimit;
        bool isThreeNumbers = false;
        switch (range) {
          case Range.lcmUpto10:
            maxLimit = 10;
            break;
          case Range.lcmUpto20:
            maxLimit = 20;
            break;
          case Range.lcmUpto30:
            maxLimit = 30;
            break;
          case Range.lcmUpto40:
            maxLimit = 40;
            break;
          case Range.lcmUpto50:
            maxLimit = 50;
            break;
          case Range.lcmUpto60:
            maxLimit = 60;
            break;
          case Range.lcmUpto70:
            maxLimit = 70;
            break;
          case Range.lcmUpto80:
            maxLimit = 80;
            break;
          case Range.lcmUpto90:
            maxLimit = 90;
            break;
          case Range.lcmUpto100:
            maxLimit = 100;
            break;
          case Range.lcm3NumbersUpto10:
            maxLimit = 10;
            isThreeNumbers = true;
            break;
          case Range.lcm3NumbersUpto20:
            maxLimit = 20;
            isThreeNumbers = true;
            break;
          case Range.lcm3NumbersUpto30:
            maxLimit = 30;
            isThreeNumbers = true;
            break;
          case Range.lcm3NumbersUpto40:
            maxLimit = 40;
            isThreeNumbers = true;
            break;
          case Range.lcm3NumbersUpto50:
            maxLimit = 50;
            isThreeNumbers = true;
            break;
          default:
            maxLimit = 10;
        }
        if (isThreeNumbers) {
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
        int maxLimit;
        switch (range) {
          case Range.gcfUpto10:
            maxLimit = 10;
            break;
          case Range.gcfUpto20:
            maxLimit = 20;
            break;
          case Range.gcfUpto30:
            maxLimit = 30;
            break;
          case Range.gcfUpto40:
            maxLimit = 40;
            break;
          case Range.gcfUpto50:
            maxLimit = 50;
            break;
          case Range.gcfUpto60:
            maxLimit = 60;
            break;
          case Range.gcfUpto70:
            maxLimit = 70;
            break;
          case Range.gcfUpto80:
            maxLimit = 80;
            break;
          case Range.gcfUpto90:
            maxLimit = 90;
            break;
          case Range.gcfUpto100:
            maxLimit = 100;
            break;
          default:
            maxLimit = 10;
        }
        num1 = random.nextInt(maxLimit) + 1;
        num2 = random.nextInt(maxLimit) + 1;
        correctAnswer = calculateGCF(num1, num2);
        break;
    }

    return num3 != 0
        ? [num1, num2, num3, correctAnswer]
        : [num1, num2, correctAnswer];
  }

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
