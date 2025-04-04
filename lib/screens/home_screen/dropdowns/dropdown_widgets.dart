import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';

class OperationDropdown extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        height: isTablet ? 60 : 50,
        child: DropdownButtonFormField<Operation>(
          value: selectedOperation,
          items: Operation.values.map((operation) {
            return DropdownMenuItem(
              value: operation,
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
            );
          }).toList(),
          onChanged: onChanged,
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
  }
}

class RangeDropdown extends StatelessWidget {
  final Range selectedRange;
  final List<DropdownMenuItem<Range>> items;
  final ValueChanged<Range?> onChanged;

  const RangeDropdown({
    required this.selectedRange,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        height: isTablet ? 60 : 50,
        child: DropdownButtonFormField<Range>(
          value: selectedRange,
          items: items,
          onChanged: onChanged,
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
