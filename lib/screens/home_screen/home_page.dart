import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/screens/home_screen/drawer/drawer.dart';
import 'package:QuickMath_Kids/screens/settings_screen.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_widgets.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_parameters.dart';

class StartScreen extends StatefulWidget {
  final Function(Operation, String) switchToPracticeScreen;
  final Function() switchToStartScreen;

  const StartScreen(this.switchToPracticeScreen, this.switchToStartScreen,
      {super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Operation _selectedOperation = Operation.addition_2A; // Default operation
  String _selectedRange = 'Upto +5'; // Default range

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickMath Kids',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      drawer: CustomDrawer(
        onHomePressed: _navigateToHome,
        onSettingsPressed: _navigateToSettings,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            //const Icon(Icons.volume_up, size: 200, color: Colors.black),
            Image.asset('assets/QuickMath_Kids_logo.png', scale: 2),

            const SizedBox(height: 15),
            const Text(
              "Choose an Operation and Start Practicing",
              style: TextStyle(color: Colors.black, fontSize: 20),
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
                      _selectedRange = getDropdownItems(_selectedOperation).first.value!;
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
            const SizedBox(height: 40),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () {
                widget.switchToPracticeScreen(_selectedOperation, _selectedRange);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToHome() {
    Navigator.pop(context);
  }
}
