import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/home_screen/home_page.dart';
import 'package:QuickMath_Kids/screens/practice_screen/practice_screen.dart';
import 'package:QuickMath_Kids/screens/result_screen/result_screen.dart';
import 'package:QuickMath_Kids/question_logic/tts_translator.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final billingFuture = container.read(billingServiceProvider).initialize();
  runApp(UncontrolledProviderScope(container: container, child: MyApp(billingFuture: billingFuture)));
}

class MyApp extends StatefulWidget {
  final Future<void> billingFuture;

  const MyApp({super.key, required this.billingFuture});

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
  Operation _selectedOperation = Operation.additionBeginner;
  Range _selectedRange = Range.additionBeginner1to5; // Updated to Range enum
  int? _selectedTimeLimit;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
    widget.billingFuture.then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlutterNativeSplash.remove();
      });
    });
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedRange = getDefaultRange(_selectedOperation); // Ensure default range matches operation
    });
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  void switchToPracticeScreen(Operation operation, Range range, int? timeLimit) {
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
    Range range, // Updated to Range
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
    return Consumer(
      builder: (context, ref, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(ref, _isDarkMode, context),
          home: Scaffold(
            body: activeScreen == 'start_screen'
                ? StartScreen(
                    switchToPracticeScreen,
                    switchToStartScreen,
                    toggleDarkMode,
                    isDarkMode: _isDarkMode,
                  )
                : activeScreen == 'practice_screen'
                    ? PracticeScreen(
                        (questions, correctAnswers, time, operation, range, timeLimit) =>
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
                        isDarkMode: _isDarkMode,
                      )
                    : ResultScreen(
                        answeredQuestions,
                        answeredCorrectly,
                        totalTimeInSeconds,
                        switchToStartScreen,
                        operation: _selectedOperation,
                        range: _selectedRange,
                        timeLimit: _selectedTimeLimit,
                      ),
          ),
        );
      },
    );
  }
}