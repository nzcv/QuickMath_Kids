import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/screens/settings_screen/settings_screen.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_widgets.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_parameters.dart';
import 'package:QuickMath_Kids/screens/faq_screen.dart';
import 'package:QuickMath_Kids/screens/how_to_use_screen.dart';
import 'package:QuickMath_Kids/wrong_answer_storing/wrong_answer_screen.dart';

class StartScreen extends StatefulWidget {
  final Function(Operation, String, int) switchToPracticeScreen; // Updated signature
  final Function() switchToStartScreen;
  final Function(bool) toggleDarkMode;
  final bool isDarkMode;

  const StartScreen(
    this.switchToPracticeScreen,
    this.switchToStartScreen,
    this.toggleDarkMode, {
    required this.isDarkMode,
    super.key,
  });

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Operation _selectedOperation = Operation.addition_2A;
  String _selectedRange = 'Upto +5';
  int _selectedTimeLimit = 300; // Default: 5 minutes (in seconds)
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(StartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _isDarkMode = widget.isDarkMode;
      });
    }
  }

  // List of time limit options (in seconds)
  final List<DropdownMenuItem<int>> _timeLimitItems = [
    DropdownMenuItem(value: 60, child: Text('1 Minute')),
    DropdownMenuItem(value: 180, child: Text('3 Minutes')),
    DropdownMenuItem(value: 300, child: Text('5 Minutes')),
    DropdownMenuItem(value: 600, child: Text('10 Minutes')),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickMath Kids',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: _buildDrawer(context),
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Image.asset('assets/QuickMath_Kids_logo.png', scale: 2),
            const SizedBox(height: 15),
            Text(
              "Choose an Operation and Start Practicing",
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onBackground,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OperationDropdown(
              selectedOperation: _selectedOperation,
              onChanged: (Operation? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedOperation = newValue;
                    _selectedRange = getDefaultRange(newValue);
                    if (!getDropdownItems(_selectedOperation)
                        .any((item) => item.value == _selectedRange)) {
                      _selectedRange =
                          getDropdownItems(_selectedOperation).first.value!;
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            RangeDropdown(
              selectedRange: _selectedRange,
              items: getDropdownItems(_selectedOperation),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRange = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: DropdownButtonFormField<int>(
                value: _selectedTimeLimit,
                decoration: InputDecoration(
                  labelText: 'Session Time Limit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _timeLimitItems,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTimeLimit = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () {
                widget.switchToPracticeScreen(
                    _selectedOperation, _selectedRange, _selectedTimeLimit);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              label: Text(
                'Start Oral Practice',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('QuickMath Kids',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('FAQ', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title:
                const Text('How to use?', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToUseScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Wrong Answers History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WrongAnswersScreen(),
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
                widget.toggleDarkMode(value);
              });
            },
          ),
        ],
      ),
    );
  }
}