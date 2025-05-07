import 'dart:async';
import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/billing/purchase_screen.dart';

class TimeWheelPicker extends StatefulWidget {
  final int initialIndex;
  final bool isPremium;
  final Function(int) onConfirm;
  final VoidCallback? onPremiumStatusChanged;

  const TimeWheelPicker({
    super.key,
    required this.initialIndex,
    required this.isPremium,
    required this.onConfirm,
    this.onPremiumStatusChanged,
  });

  @override
  _TimeWheelPickerState createState() => _TimeWheelPickerState();
}

class _TimeWheelPickerState extends State<TimeWheelPicker> {
  late int _selectedIndex;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _startInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  // Start or reset the inactivity timer
  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void didUpdateWidget(TimeWheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPremium != widget.isPremium) {
      // Premium status changed - reset to free default if needed
      if (!widget.isPremium && _selectedIndex != 2) {
        setState(() {
          _selectedIndex = 2;
        });
      }
      widget.onPremiumStatusChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final freeTierDefaultIndex = 2; // 2 minutes is index 2

    return Container(
      height: 340,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Set Time Limit',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.isPremium
                ? 'Choose any time limit'
                : 'Free users are limited to 2 minutes. Upgrade to Premium for more options!',
            style: TextStyle(
              fontSize: 14,
              color: widget.isPremium ? Colors.black : Colors.red,
              fontStyle: widget.isPremium ? FontStyle.normal : FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                if (widget.isPremium) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
                _startInactivityTimer(); // Reset timer on scroll
              },
              controller:
                  FixedExtentScrollController(initialItem: _selectedIndex),
              childDelegate: ListWheelChildListDelegate(
                children: List.generate(
                  61,
                  (index) {
                    final isSelected = index == _selectedIndex;
                    final isLocked =
                        !widget.isPremium && index != freeTierDefaultIndex;
                    final displayText = index == 0
                        ? 'No Limit'
                        : '$index minute${index == 1 ? '' : 's'}';

                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        color: isSelected ? Colors.blue.withOpacity(0.2) : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isLocked) ...[
                              const Icon(Icons.lock,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              displayText,
                              style: TextStyle(
                                fontSize: 20,
                                color: isLocked
                                    ? Colors.grey
                                    : isSelected
                                        ? Colors.blue
                                        : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isLocked) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                color: Colors.amber,
                                child: const Text(
                                  'Premium',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              _startInactivityTimer(); // Reset timer on button press
              if (!widget.isPremium && _selectedIndex != freeTierDefaultIndex) {
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
                            'Custom time limits are a Premium feature. Upgrade to unlock!',
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
                        _startInactivityTimer(); // Reset timer on action press
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PurchaseScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                );
                return;
              }

              widget.onConfirm(_selectedIndex);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}