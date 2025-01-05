import 'package:QuickMath_Kids/question_logic/question_generator.dart';

class OperatorHelper {
  static String getOperatorSymbol(Operation operation) {
    if (operation == Operation.addition_2A ||
        operation == Operation.addition_A ||
        operation == Operation.addition_B) {
      return '+';
    } else if (operation == Operation.subtraction_A ||
        operation == Operation.subtraction_B) {
      return '-';
    } else if (operation == Operation.multiplication_C) {
      return 'x';
    } else if (operation == Operation.division_C ||
        operation == Operation.division_D) {
      return '÷';
    } else if (operation == Operation.lcm) {
      return 'LCM';
    } else if (operation == Operation.gcf) {
      return 'GCF';
    }
    return '';
  }
}
