import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_widgets.dart';
import 'package:QuickMath_Kids/screens/home_screen/dropdowns/dropdown_parameters.dart';
import 'package:QuickMath_Kids/screens/home_screen/timer_wheel_picker.dart';
import 'package:QuickMath_Kids/screens/home_screen/drawer.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:QuickMath_Kids/app_theme.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:QuickMath_Kids/billing/purchase_screen.dart';
import 'package:flutter/foundation.dart';

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
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final int _freeUserDailyLimit = 3;
  int _refreshKey = 0;
  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedTimeLimit = 2 * 60;
    _selectedIndex = 2;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final savedOperationIndex = prefs.getInt('selectedOperation');
      if (savedOperationIndex != null &&
          savedOperationIndex >= 0 &&
          savedOperationIndex < Operation.values.length) {
        _selectedOperation = Operation.values[savedOperationIndex];
      }

      final savedRangeIndex = prefs.getInt('selectedRange');
      if (savedRangeIndex != null &&
          savedRangeIndex >= 0 &&
          savedRangeIndex < Range.values.length) {
        Range loadedRange = Range.values[savedRangeIndex];
        if (getDropdownItems(_selectedOperation)
            .any((item) => item.value == loadedRange)) {
          _selectedRange = loadedRange;
        } else {
          _selectedRange = getDefaultRange(_selectedOperation);
        }
      }

      final savedTimeLimit = prefs.getInt('selectedTimeLimit');
      if (savedTimeLimit != null) {
        if (savedTimeLimit == 0) {
          _selectedTimeLimit = null;
          _selectedIndex = 0;
        } else {
          _selectedTimeLimit = savedTimeLimit;
          _selectedIndex = savedTimeLimit ~/ 60;
        }
      } else {
        _selectedTimeLimit = null;
        _selectedIndex = 0;
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'selectedOperation', Operation.values.indexOf(_selectedOperation));
    await prefs.setInt('selectedRange', Range.values.indexOf(_selectedRange));
    await prefs.setInt('selectedTimeLimit', _selectedTimeLimit ?? 0);
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
    final billingService = ref.read(billingServiceProvider);
    final bool isPremium = billingService.isPremium;
    final freeTierDefaultIndex = 2;

    if (!isPremium && _selectedIndex != freeTierDefaultIndex) {
      _selectedIndex = freeTierDefaultIndex;
      _selectedTimeLimit = freeTierDefaultIndex * 60;
      _savePreferences();
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return TimeWheelPicker(
          initialIndex: _selectedIndex,
          isPremium: isPremium,
          onConfirm: (index) {
            setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                _selectedTimeLimit = null;
              } else {
                _selectedTimeLimit = _selectedIndex * 60;
              }
              _savePreferences();
            });
          },
          onPremiumStatusChanged: () {
            if (!billingService.isPremium &&
                _selectedIndex != freeTierDefaultIndex) {
              setState(() {
                _selectedIndex = freeTierDefaultIndex;
                _selectedTimeLimit = freeTierDefaultIndex * 60;
                _savePreferences();
              });
            }
          },
        );
      },
    );
  }

  Widget _buildQuizzesStatusCard(BuildContext context, ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final billingService = ref.watch(billingServiceProvider);
        return FutureBuilder<int>(
          key: ValueKey(_refreshKey),
          future: billingService.isPremium
              ? Future.value(-1)
              : _getRemainingQuizzes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final remaining = snapshot.data!;
              Color statusColor;
              IconData _statusIcon;
              if (remaining == -1) {
                statusColor = Colors.green;
                _statusIcon = Icons.star;
              } else if (remaining == 0) {
                statusColor = theme.colorScheme.error;
                _statusIcon = Icons.lock;
              } else if (remaining <= 1) {
                statusColor = Colors.orange;
                _statusIcon = Icons.warning;
              } else {
                statusColor = theme.colorScheme.primary;
                _statusIcon = Icons.check_circle;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  color: theme.colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          remaining == -1
                              ? Icons.star_rounded
                              : remaining <= 1
                                  ? Icons.warning_rounded
                                  : Icons.check_circle_rounded,
                          color: statusColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              remaining == -1
                                  ? 'Premium Member'
                                  : 'Daily Quizzes',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              remaining == -1
                                  ? 'Unlimited Access'
                                  : '$remaining/$_freeUserDailyLimit remaining',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (remaining != -1 && remaining <= 1) ...[
                          const Spacer(),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_rounded,
                                color: theme.colorScheme.primary),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PurchaseScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Future<int> _getRemainingQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastQuizDate = prefs.getString('last_quiz_date');

    if (lastQuizDate != today) {
      await prefs.setString('last_quiz_date', today);
      await prefs.setInt('daily_quizzes', 0);
      return _freeUserDailyLimit;
    }

    final quizzesTaken = prefs.getInt('daily_quizzes') ?? 0;
    return _freeUserDailyLimit - quizzesTaken;
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
            drawer: Consumer(
              builder: (context, ref, child) {
                final billingService = ref.watch(billingServiceProvider);
                return AppDrawer(
                  billingService: billingService,
                  switchToStartScreen: widget.switchToStartScreen,
                  isDarkMode: _isDarkMode,
                  toggleDarkMode: widget.toggleDarkMode,
                );
              },
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/QuickMath_Kids_logo.png',
                          width: isTablet ? 250 : 200,
                          height: isTablet ? 250 : 200,
                        ),
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
                              _savePreferences();
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
                              _savePreferences();
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
                              _selectedTimeLimit == null
                                  ? 'No time limit'
                                  : '${_selectedTimeLimit! ~/ 60} minute${_selectedTimeLimit! ~/ 60 == 1 ? '' : 's'}',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildQuizzesStatusCard(context, theme),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        onPressed: () async {
                          final isPremium =
                              ref.read(billingServiceProvider).isPremium;
                          final remaining =
                              isPremium ? -1 : await _getRemainingQuizzes();

                          if (!isPremium && remaining <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: theme.colorScheme.onError,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'You’ve reached your daily limit of $_freeUserDailyLimit quizzes. Upgrade to Premium for unlimited access!',
                                        style: TextStyle(
                                          color: theme.colorScheme.onError,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: theme.colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(16),
                                elevation: 6,
                                duration: const Duration(seconds: 5),
                                action: SnackBarAction(
                                  label: 'Upgrade',
                                  textColor: Colors.white,
                                  backgroundColor: theme.colorScheme.primary,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PurchaseScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                            return;
                          }

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
                      /*if (kDebugMode) ...[
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          iconAlignment: IconAlignment.end,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () async {
                            await ref
                                .read(billingServiceProvider)
                                .resetPremium();
                            final prefs = await SharedPreferences.getInstance();
                            final today =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            await prefs.setString('last_quiz_date', today);
                            await prefs.setInt('daily_quizzes', 0);
                            setState(() {
                              _selectedIndex = 2;
                              _selectedTimeLimit = 2 * 60;
                              _savePreferences();
                              _refreshKey++;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Premium status and settings reset to free tier.'),
                                backgroundColor: theme.colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(16),
                                elevation: 6,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          label: const Text('Reset Premium (Debug)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: isTablet ? 24 : 18,
                            ),
                          ),
                        ),
                      ],*/
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
