import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:QuickMath_Kids/billing/purchase_screen.dart';

class OperationDropdown extends ConsumerWidget {
  final Operation selectedOperation;
  final ValueChanged<Operation?> onChanged;

  const OperationDropdown({
    required this.selectedOperation,
    required this.onChanged,
    super.key,
  });

  String _getDisplayName(Operation operation) {
    switch (operation) {
      case Operation.additionBeginner:
        return 'Addition: Beginner';
      case Operation.additionIntermediate:
        return 'Addition: Intermediate';
      case Operation.additionAdvanced:
        return 'Addition: Advanced';
      case Operation.subtractionBeginner:
        return 'Subtraction: Beginner';
      case Operation.subtractionIntermediate:
        return 'Subtraction: Intermediate';
      case Operation.subtractionAdvanced:
        return 'Subtraction: Advanced';
      case Operation.multiplicationBeginner:
        return 'Multiplication: Beginner';
      case Operation.multiplicationIntermediate:
        return 'Multiplication: Intermediate';
      case Operation.multiplicationAdvanced:
        return 'Multiplication: Advanced';
      case Operation.divisionBeginner:
        return 'Division: Beginner';
      case Operation.divisionIntermediate:
        return 'Division: Intermediate';
      case Operation.divisionAdvanced:
        return 'Division: Advanced';
      case Operation.lcmBeginner:
        return 'LCM: Beginner';
      case Operation.lcmIntermediate:
        return 'LCM: Intermediate';
      case Operation.lcmAdvanced:
        return 'LCM: Advanced';
      case Operation.gcfBeginner:
        return 'GCF: Beginner';
      case Operation.gcfIntermediate:
        return 'GCF: Intermediate';
      case Operation.gcfAdvanced:
        return 'GCF: Advanced';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SizedBox(
            height: isTablet ? 60 : 50,
            child: DropdownButtonFormField<Operation>(
              value: selectedOperation,
              items: Operation.values.map((operation) {
                return DropdownMenuItem<Operation>(
                  value: operation,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getDisplayName(operation),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.brightness == Brightness.dark
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Operation? newValue) {
                if (newValue == null) return;
                onChanged(newValue);
              },
              isExpanded: true,
              decoration: InputDecoration(
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
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: theme.colorScheme.secondary, width: 2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RangeDropdown extends ConsumerWidget {
  final Range selectedRange;
  final List<DropdownMenuItem<Range>> items;
  final ValueChanged<Range?> onChanged;

  const RangeDropdown({
    required this.selectedRange,
    required this.items,
    required this.onChanged,
    super.key,
  });

  static const Set<Range> _paidRanges = {
    // Addition
    Range.additionBeginnerMixed1to10,
    Range.additionIntermediateMixed10to50,
    Range.additionAdvancedMixed1to200,
    // Subtraction
    Range.subtractionBeginnerMixed1to20,
    Range.subtractionIntermediate40to50,
    Range.subtractionIntermediateMixed20to50,
    Range.subtractionAdvancedMixed50to200,
    Range.subtractionAdvancedMixed1to200,
    // Multiplication
    Range.multiplicationBeginnerX5,
    Range.multiplicationBeginnerMixedX2toX5,
    Range.multiplicationIntermediateX9,
    Range.multiplicationIntermediateMixedX6toX9,
    Range.multiplicationAdvancedX12,
    Range.multiplicationAdvancedMixedX10toX12,
    Range.multiplicationAdvancedMixedX2toX12,
    // Division
    Range.divisionBeginnerBy5,
    Range.divisionBeginnerMixedBy2to5,
    Range.divisionIntermediateBy9,
    Range.divisionIntermediateMixedBy6to9,
    Range.divisionAdvancedMixedBy2to10,
    // LCM
    Range.lcmBeginnerUpto20,
    Range.lcmBeginnerMixedUpto20,
    Range.lcmIntermediateUpto60,
    Range.lcmIntermediateMixedUpto60,
    Range.lcmAdvanced3NumbersUpto50,
    Range.lcmAdvancedMixedUpto100,
    Range.lcmAdvancedMixed3NumbersUpto50,
    // GCF
    Range.gcfBeginnerMixedUpto20,
    Range.gcfIntermediateUpto60,
    Range.gcfIntermediateMixedUpto60,
    Range.gcfAdvancedUpto100,
    Range.gcfAdvancedMixedUpto100,
  };

  void _navigateToPurchaseScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PurchaseScreen()),
    );
  }

  void _showPremiumSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You need premium access for this'),
        action: SnackBarAction(
          label: 'Unlock',
          onPressed: () => _navigateToPurchaseScreen(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;
    final billingService = ref.watch(billingServiceProvider);
    final isPremium = billingService.isPremium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        height: isTablet ? 60 : 50,
        child: DropdownButtonFormField<Range>(
          value: selectedRange,
          items: items.map((item) {
            final range = item.value!;
            final isLocked = _paidRanges.contains(range) && !isPremium;

            return DropdownMenuItem<Range>(
              value: range,
              enabled: !isLocked, // Disable item if locked
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getRangeDisplayName(range),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isLocked
                            ? theme.colorScheme.onSurface.withOpacity(0.5)
                            : theme.brightness == Brightness.dark
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onBackground,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
            );
          }).toList(),
          onChanged: (Range? newValue) {
            if (newValue == null) return;
            if (_paidRanges.contains(newValue) && !isPremium) {
              _showPremiumSnackBar(context);
              return;
            }
            onChanged(newValue);
          },
          isExpanded: true,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.brightness == Brightness.dark
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onBackground,
          ),
          decoration: InputDecoration(
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
              borderSide:
                  BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: theme.colorScheme.secondary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}