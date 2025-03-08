import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/home_screen/home_page.dart';
import 'package:QuickMath_Kids/billing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize BillingService
  final billingService = BillingService();
  await billingService.initialize();
  runApp(MyApp(billingService: billingService));
}

class MyApp extends StatefulWidget {
  final BillingService billingService;

  const MyApp({super.key, required this.billingService});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickMath Kids',
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
        colorScheme: _isDarkMode
            ? const ColorScheme.dark(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.grey,
                onSurface: Colors.white,
              )
            : const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
        scaffoldBackgroundColor: _isDarkMode ? Colors.black : Colors.grey[200],
      ),
      home: StartScreen(
        (operation, range, timeLimit) => print('Switch to PracticeScreen'),
        () => print('Switch to StartScreen'),
        toggleDarkMode,
        isDarkMode: _isDarkMode,
        billingService: widget.billingService, // Pass BillingService
      ),
    );
  }
}