import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/home_screen/home_page.dart';
import 'package:QuickMath_Kids/screens/practice_screen/practice_screen.dart';
import 'package:QuickMath_Kids/screens/result_screen/result_screen.dart';
import 'package:QuickMath_Kids/question_logic/tts_translator.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(billingServiceProvider).initialize();
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
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
  String _selectedRange = 'Upto +5';
  int? _selectedTimeLimit;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  void switchToPracticeScreen(
      Operation operation, String range, int? timeLimit) {
    setState(() {
      _selectedOperation = operation;
      _selectedRange = range;
      _selectedTimeLimit = timeLimit;
      activeScreen = 'practice_screen';
    });
  }

  void switchToStartScreen() {
    setState(() {
      activeScreen = 'start_screen';
    });
  }

  void switchToResultScreen(
    List<String> questions,
    List<bool> correctAnswers,
    int time,
    Operation operation,
    String range,
    int? timeLimit,
  ) {
    setState(() {
      answeredQuestions = questions;
      answeredCorrectly = correctAnswers;
      totalTimeInSeconds = time;
      _selectedOperation = operation;
      _selectedRange = range;
      _selectedTimeLimit = timeLimit;
      activeScreen = 'result_screen';
    });
  }

  void triggerTTS(String text, WidgetRef ref) {
    TTSService().speak(text, ref);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: _isDarkMode
          ? const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.black, // Changed to black for dark mode
              onSurface: Colors.white,
            )
          : const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
      scaffoldBackgroundColor:
          _isDarkMode ? Colors.black : Colors.grey[200], // Black in dark mode
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Consumer(
        builder: (context, ref, child) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: Consumer(
              builder: (context, ref, child) {
                return activeScreen == 'start_screen'
                    ? StartScreen(
                        switchToPracticeScreen,
                        switchToStartScreen,
                        toggleDarkMode,
                        isDarkMode: _isDarkMode,
                      )
                    : activeScreen == 'practice_screen'
                        ? PracticeScreen(
                            (questions, correctAnswers, time, operation, range,
                                    timeLimit) =>
                                switchToResultScreen(
                              questions,
                              correctAnswers,
                              time,
                              operation,
                              range,
                              timeLimit,
                            ),
                            switchToStartScreen,
                            (text) => triggerTTS(text, ref),
                            _selectedOperation,
                            _selectedRange,
                            _selectedTimeLimit,
                          )
                        : ResultScreen(
                            answeredQuestions,
                            answeredCorrectly,
                            totalTimeInSeconds,
                            switchToStartScreen,
                            operation: _selectedOperation,
                            range: _selectedRange,
                            timeLimit: _selectedTimeLimit,
                          );
              },
            ),
          );
        },
      ),
    );
  }
}
