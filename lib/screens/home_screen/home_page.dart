import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_widgets.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_parameters.dart';
import 'package:QuickMath_Kids/screens/home_screen/drawer.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:QuickMath_Kids/app_theme.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';

class StartScreen extends ConsumerStatefulWidget {
  final Function(Operation, Range, int?) switchToPracticeScreen;
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
  Operation _selectedOperation = Operation.additionBeginner;
  Range _selectedRange = Range.additionBeginner1to5;
  int? _selectedTimeLimit;
  int _selectedIndex = 0; // 0 for "No Limit", 1-60 for minutes
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedTimeLimit = null;
    _selectedIndex = 0; // Default to "No Limit"
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
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Set Time Limit', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      diameterRatio: 1.5,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setModalState(() {
                          _selectedIndex = index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final isSelected = index == _selectedIndex;
                          String displayText;
                          if (index == 0) {
                            displayText = 'No Limit';
                          } else {
                            final minute = index; // 1 to 60
                            displayText =
                                '$minute minute${minute == 1 ? '' : 's'}';
                          }
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.2)
                                    : Colors.transparent,
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 2)
                                    : null,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                displayText,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 20,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 61, // 0 for "No Limit", 1-60 for minutes
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedIndex == 0) {
                          _selectedTimeLimit = null; // "No Limit"
                        } else {
                          _selectedTimeLimit =
                              _selectedIndex * 60; // Convert minutes to seconds
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
    final billingService = ref.watch(billingServiceProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (!billingService.isInitialized) {
      return Consumer(
        builder: (context, ref, child) {
          final theme = AppTheme.getTheme(ref, widget.isDarkMode, context);
          return Theme(
            data: theme,
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final theme = AppTheme.getTheme(ref, widget.isDarkMode, context);
        return Theme(
          data: theme,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('QuickMath Kids'),
              actions: [],
            ),
            drawer: AppDrawer(
              billingService: billingService,
              switchToStartScreen: widget.switchToStartScreen,
              isDarkMode: _isDarkMode,
              toggleDarkMode: widget.toggleDarkMode,
            ),
            body: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: isTablet ? 700 : double.infinity),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/QuickMath_Kids_logo.png',
                        width: isTablet ? 250 : 200,
                        height: isTablet ? 250 : 200,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Choose an Operation and Start Practicing",
                        style: theme.textTheme.headlineMedium,
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
                              if (!getDropdownItems(_selectedOperation).any(
                                  (item) => item.value == _selectedRange)) {
                                _selectedRange =
                                    getDropdownItems(_selectedOperation)
                                        .first
                                        .value!;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      RangeDropdown(
                        selectedRange: _selectedRange,
                        items: getDropdownItems(_selectedOperation),
                        onChanged: (Range? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedRange = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () => _showTimeWheelPicker(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Session Time Limit',
                              filled: true,
                              fillColor: theme.brightness == Brightness.dark
                                  ? theme.colorScheme.surface
                                  : Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isTablet ? 20 : 10,
                                horizontal: isTablet ? 30 : 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.secondary,
                                    width: 2),
                              ),
                            ),
                            child: Text(
                              _selectedTimeLimit != null
                                  ? '${_selectedTimeLimit! ~/ 60} minute${_selectedTimeLimit! ~/ 60 == 1 ? '' : 's'}'
                                  : 'No time limit',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        onPressed: () {
                          widget.switchToPracticeScreen(_selectedOperation,
                              _selectedRange, _selectedTimeLimit);
                        },
                        label: const Text('Start Oral Practice'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: isTablet ? 24 : 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}