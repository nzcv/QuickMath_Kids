import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/billing/purchase_screen.dart';

class TimeWheelPicker extends StatefulWidget {
  final int initialIndex;
  final bool isPremium;
  final Function(int) onConfirm;

  const TimeWheelPicker({
    super.key,
    required this.initialIndex,
    required this.isPremium,
    required this.onConfirm,
  });

  @override
  _TimeWheelPickerState createState() => _TimeWheelPickerState();
}

class _TimeWheelPickerState extends State<TimeWheelPicker> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              onSelectedItemChanged: (index) {
                if (widget.isPremium) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
                // For free users, do not allow selection change
              },
              controller: FixedExtentScrollController(initialItem: _selectedIndex),
              childDelegate: ListWheelChildListDelegate(
                children: List.generate(
                  61,
                  (index) {
                    final isSelected = index == _selectedIndex;
                    final isLocked = !widget.isPremium && index != 2; // Lock all except 5 minutes for free users
                    String displayText;
                    if (index == 0) {
                      displayText = 'No Limit';
                    } else {
                      final minute = index;
                      displayText = '$minute minute${minute == 1 ? '' : 's'}';
                    }
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : Colors.transparent,
                          border: isSelected
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isLocked)
                              Icon(
                                Icons.lock,
                                size: 16,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            if (isLocked) const SizedBox(width: 8),
                            Text(
                              displayText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                color: isLocked
                                    ? theme.colorScheme.onSurface.withOpacity(0.5)
                                    : isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
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
              if (!widget.isPremium && _selectedIndex != 2) {
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