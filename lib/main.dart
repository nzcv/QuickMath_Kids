import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oral_app_new/screens/home_screen/home_page.dart';
import 'package:oral_app_new/screens/practice_screen/practice_screen.dart';
import 'package:oral_app_new/screens/result_screen.dart';
import 'package:oral_app_new/question_logic/tts_translator.dart';
import 'package:oral_app_new/question_logic/question_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String activeScreen = 'start_screen';
  List<String> answeredQuestions = [];
  List<bool> answeredCorrectly = [];
  int totalTimeInSeconds = 0;
  Operation _selectedOperation = Operation.addition_2A;
  String _selectedRange = 'Upto +5'; // Default range

  void switchToPracticeScreen(Operation operation, String range) {
    setState(() {
      _selectedOperation = operation;
      _selectedRange = range;
      activeScreen = 'practice_screen';
    });
  }

  void switchToStartScreen() {
    setState(() {
      activeScreen = 'start_screen';
    });
  }

  void switchToResultScreen(
      List<String> questions, List<bool> correctAnswers, int time) {
    setState(() {
      answeredQuestions = questions;
      answeredCorrectly = correctAnswers;
      totalTimeInSeconds = time;
      activeScreen = 'result_screen';
    });
  }

  void triggerTTS(String text, WidgetRef ref) {
    TTSService().speak(text, ref); // Pass WidgetRef to TTSService
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF009DDC),
        primary: const Color(0xFF009DDC),
        secondary: Colors.red,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
      ),
      textTheme: GoogleFonts.latoTextTheme(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Consumer(
          builder: (context, ref, child) {
            return activeScreen == 'start_screen'
                ? StartScreen(switchToPracticeScreen, switchToStartScreen)
                : activeScreen == 'practice_screen'
                    ? PracticeScreen(
                        (questions, correctAnswers, time) =>
                            switchToResultScreen(
                                questions, correctAnswers, time),
                        switchToStartScreen, // Pass directly as VoidCallback
                        (text) => triggerTTS(text, ref),
                        _selectedOperation,
                        _selectedRange,
                      )
                    : ResultScreen(answeredQuestions, answeredCorrectly,
                        totalTimeInSeconds, switchToStartScreen);
          },
        ),
      ),
    );
  }
}
