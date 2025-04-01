import 'package:QuickMath_Kids/question_logic/enum_values.dart';

class TTSHelper {
  final Function(String) triggerTTS;

  TTSHelper(this.triggerTTS);

  void playSpeech(
    Operation selectedOperation,
    List<int> numbers,
  ) {
    String operatorWord = '';
    switch (selectedOperation) {
      case Operation.additionBeginner:
      case Operation.additionIntermediate:
      case Operation.additionAdvanced:
        operatorWord = 'plus';
        break;
      case Operation.subtractionBeginner:
      case Operation.subtractionIntermediate:
        operatorWord = 'minus';
        break;
      case Operation.multiplicationTables:
        operatorWord = 'times';
        break;
      case Operation.divisionBasic:
      case Operation.divisionMixed:
        operatorWord = 'divided by';
        break;
      case Operation.lcm:
        operatorWord = 'LCM of ';
        break;
      case Operation.gcf:
        operatorWord = 'GCF of ';
        break;
    }

    String questionText;
    switch (selectedOperation) {
      case Operation.lcm:
        questionText = numbers.length > 3
            ? 'LCM of ${numbers[0]}, ${numbers[1]}, and ${numbers[2]}'
            : 'LCM of ${numbers[0]} and ${numbers[1]}';
        break;
      case Operation.gcf:
        questionText = '$operatorWord ${numbers[0]} and ${numbers[1]}';
        break;
      default:
        questionText = '${numbers[0]} $operatorWord ${numbers[1]} equals?';
    }

    triggerTTS(questionText);
  }
}
