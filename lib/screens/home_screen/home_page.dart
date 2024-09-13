import 'package:flutter/material.dart';
import 'package:oral_app_new/question_logic/question_generator.dart';
import 'package:oral_app_new/screens/home_screen/drawer/drawer.dart'; // Import the custom drawer
import 'package:oral_app_new/screens/home_screen/drawer/settings_screen.dart'; // Import the settings screen
import 'package:oral_app_new/screens/home_screen/dropdown_widgets.dart'; // Import the dropdown widgets

class StartScreen extends StatefulWidget {
  final Function(Operation, String) switchToPracticeScreen;
  final Function() switchToStartScreen;

  const StartScreen(this.switchToPracticeScreen, this.switchToStartScreen,
      {super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Operation _selectedOperation = Operation.addition; // Default operation
  String _selectedRange = 'Upto +5'; // Default range

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const SettingsScreen()), // Navigate to the settings screen
    );
  }

  void _navigateToHome() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumon Oral Practice',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings, // Directly open settings
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
            const SizedBox(height: 40),
            const Icon(Icons.volume_up, size: 200, color: Colors.black),
            const SizedBox(height: 80),
            const Text(
              "Choose an Operation and Start Practicing",
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            OperationDropdown(
              selectedOperation: _selectedOperation,
              onChanged: (Operation? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedOperation = newValue;
                    _selectedRange = _getDefaultRange(
                        newValue); // Update the range when operation changes
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            RangeDropdown(
              selectedRange: _selectedRange,
              items: _getDropdownItems(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRange = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 70),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
              onPressed: () {
                widget.switchToPracticeScreen(
                    _selectedOperation, _selectedRange);
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

  String _getDefaultRange(Operation operation) {
    if (operation == Operation.addition) {
      return 'Upto +5';
    } else if (operation == Operation.subtraction) {
      return 'Upto -5';
    } else if (operation == Operation.multiplication) {
      return 'Upto x5';
    } else if (operation == Operation.division) {
      return 'Upto ÷5';
    } else {
      return 'Select an option';
    }
  }

  List<DropdownMenuItem<String>> _getDropdownItems() {
    if (_selectedOperation == Operation.addition) {
      return [
        const DropdownMenuItem(
          value: 'Upto +5',
          child: Text('Upto +5', style: TextStyle(color: Colors.grey)),
        ),
        const DropdownMenuItem(
          value: 'Upto +10',
          child: Text('Upto +10', style: TextStyle(color: Colors.grey)),
        ),
      ];
    } else if (_selectedOperation == Operation.subtraction) {
      return [
        const DropdownMenuItem(
          value: 'Upto -3',
          child: Text('Upto -3', style: TextStyle(color: Colors.grey)),
        ),
        const DropdownMenuItem(
          value: 'Upto -5',
          child: Text('Upto -5', style: TextStyle(color: Colors.grey)),
        ),
      ];
    } else if (_selectedOperation == Operation.multiplication) {
      return [
        const DropdownMenuItem(
          value: 'Upto x3',
          child: Text('Upto x3', style: TextStyle(color: Colors.grey)),
        ),
        const DropdownMenuItem(
          value: 'Upto x5',
          child: Text('Upto x5', style: TextStyle(color: Colors.grey)),
        ),
      ];
    } else if (_selectedOperation == Operation.division) {
      return [
        const DropdownMenuItem(
          value: 'Upto ÷3',
          child: Text('Upto ÷3', style: TextStyle(color: Colors.grey)),
        ),
        const DropdownMenuItem(
          value: 'Upto ÷5',
          child: Text('Upto ÷5', style: TextStyle(color: Colors.grey)),
        ),
      ];
    } else {
      return [
        const DropdownMenuItem(
          value: 'Select an option',
          child: Text('Select an option', style: TextStyle(color: Colors.grey)),
        ),
      ];
    }
  }
}

