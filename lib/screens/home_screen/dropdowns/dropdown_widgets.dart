import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';

class OperationDropdown extends StatelessWidget {
  final Operation selectedOperation;
  final ValueChanged<Operation?> onChanged;

  const OperationDropdown({
    required this.selectedOperation,
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
        height: isTablet ? 60 : 50, // Increased height on tablets
        child: DropdownButtonFormField<Operation>(
          value: selectedOperation,
          items: Operation.values.map((operation) {
            return DropdownMenuItem(
              value: operation,
              child: Text(
                operation.name.toUpperCase(),
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
              vertical: isTablet ? 20 : 10, // Increased vertical padding on tablets
              horizontal: isTablet ? 30 : 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class RangeDropdown extends StatelessWidget {
  final String selectedRange;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

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
        height: isTablet ? 60 : 50, // Increased height on tablets
        child: DropdownButtonFormField<String>(
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
              vertical: isTablet ? 20 : 10, // Increased vertical padding on tablets
              horizontal: isTablet ? 30 : 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}