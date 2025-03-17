import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:QuickMath_Kids/screens/settings_screen/settings_screen.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_widgets.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_parameters.dart';
import 'package:QuickMath_Kids/screens/faq/faq_screen.dart';
import 'package:QuickMath_Kids/screens/how_to_use_screen.dart';
import 'package:QuickMath_Kids/wrong_answer_storing/wrong_answer_screen.dart';
import 'package:QuickMath_Kids/quiz_history/quiz_history_screen.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:QuickMath_Kids/billing/purchase_screen.dart';

class StartScreen extends ConsumerStatefulWidget {
  final Function(Operation, String, int?) switchToPracticeScreen;
  final VoidCallback switchToStartScreen;
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

class _StartScreenState extends ConsumerState<StartScreen> {
  Operation _selectedOperation = Operation.addition_2A;
  String _selectedRange = 'Upto +5';
  int? _selectedTimeLimit;
  int _selectedMinutes = 5;
  bool _noLimit = true;
  bool _isDarkMode = false;
  //bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedTimeLimit = null;
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

  void _showTimeWheelPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Set Time Limit',
                          style: Theme.of(context).textTheme.titleLarge),
                      Row(
                        children: [
                          const Text('No Limit'),
                          Switch(
                            value: _noLimit,
                            onChanged: (value) {
                              setModalState(() {
                                _noLimit = value;
                              });
                            },
                            activeTrackColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!_noLimit)
                    SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setModalState(() {
                            _selectedMinutes = index + 1;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final minute = index + 1;
                            final isSelected = minute == _selectedMinutes;
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2)
                                      : Colors.transparent,
                                  border: isSelected
                                      ? Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2)
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$minute minute${minute == 1 ? '' : 's'}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 60,
                        ),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_noLimit) {
                          _selectedTimeLimit = null;
                        } else {
                          _selectedTimeLimit = _selectedMinutes * 60;
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final billingService = ref.watch(billingServiceProvider);

    if (!billingService.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickMath Kids'),
        /*actions: [
          IconButton(
            icon: _isRestoring
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRestoring
                ? null
                : () async {
                    setState(() {
                      _isRestoring = true;
                    });
                    final billingService = ref.read(billingServiceProvider);
                    await billingService.restorePurchase();
                    setState(() {
                      _isRestoring = false;
                    });
                    if (billingService.isPremium) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Premium status restored')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No premium purchase found')),
                      );
                    }
                  },
          ),
        ],*/
      ),
      drawer: _buildDrawer(context),
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
              style: const TextStyle(
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
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: InkWell(
                onTap: () => _showTimeWheelPicker(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Session Time Limit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: Text(
                    _selectedTimeLimit != null
                        ? '${_selectedTimeLimit! ~/ 60} minute${_selectedTimeLimit! ~/ 60 == 1 ? '' : 's'}'
                        : 'No time limit',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                widget.switchToPracticeScreen(
                    _selectedOperation, _selectedRange, _selectedTimeLimit);
              },
              label: Text(
                'Start Oral Practice',
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
            /*ElevatedButton(
              onPressed: () async {
                final billingService = ref.read(billingServiceProvider);
                await billingService.resetPremium();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Premium access reset. You can purchase again.')),
                );
              },
              child: const Text('Reset Premium'),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final billingService = ref.watch(billingServiceProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('QuickMath Kids', style: TextStyle(fontSize: 24)),
          ),
          if (!billingService.isPremium)
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: const Text(
                'Premium Required',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: !billingService.isPremium
                ? BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null,
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                if (billingService.isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()),
                  );
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('FAQ'),
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
            title: const Text('How to use?'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToUseScreen()),
              );
            },
          ),
          if (!billingService.isPremium)
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: const Text(
                'Premium Required',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: !billingService.isPremium
                ? BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null,
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Wrong Answers History'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                if (billingService.isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WrongAnswersScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()),
                  );
                }
              },
            ),
          ),
          if (!billingService.isPremium)
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: const Text(
                'Premium Required',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: !billingService.isPremium
                ? BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null,
            child: ListTile(
              leading: const Icon(Icons.history_toggle_off),
              title: const Text('Quiz History'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                if (billingService.isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizHistoryScreen(widget.switchToStartScreen),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()),
                  );
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text('Purchase Premium'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PurchaseScreen()),
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
