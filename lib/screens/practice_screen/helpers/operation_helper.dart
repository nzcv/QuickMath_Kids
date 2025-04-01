import 'package:QuickMath_Kids/question_logic/enum_values.dart';

class OperatorHelper {
  static String getOperatorSymbol(Operation operation) {
    if (operation == Operation.additionBeginner ||
        operation == Operation.additionIntermediate ||
        operation == Operation.additionAdvanced) {
      return '+';
    } else if (operation == Operation.subtractionBeginner ||
        operation == Operation.subtractionIntermediate) {
      return '-';
    } else if (operation == Operation.multiplicationTables) {
      return 'x';
    } else if (operation == Operation.divisionBasic||
        operation == Operation.divisionMixed) {
      return '÷';
    } else if (operation == Operation.lcm) {
      return 'LCM';
    } else if (operation == Operation.gcf) {
      return 'GCF';
    }
    return '';
  }
}
