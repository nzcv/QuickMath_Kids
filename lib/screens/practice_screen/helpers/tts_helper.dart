import '../../../question_logic/question_generator.dart';

class TTSHelper {
  final Function(String) triggerTTS;

  TTSHelper(this.triggerTTS);

  void playSpeech(
    Operation selectedOperation,
    List<int> numbers,
  ) {
    String operatorWord = '';
    switch (selectedOperation) {
      case Operation.addition_2A:
      case Operation.addition_A:
      case Operation.addition_B:
        operatorWord = 'plus';
        break;
      case Operation.subtraction_A:
      case Operation.subtraction_B:
        operatorWord = 'minus';
        break;
      case Operation.multiplication_C:
        operatorWord = 'times';
        break;
      case Operation.division_C:
      case Operation.division_D:
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
