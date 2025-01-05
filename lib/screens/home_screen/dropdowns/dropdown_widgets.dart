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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: DropdownButtonFormField<Operation>(
        value: selectedOperation,
        items: Operation.values.map((operation) {
          return DropdownMenuItem(
            value: operation,
            child: Text(
              operation.name.toUpperCase(),
              style: const TextStyle(color: Color.fromARGB(137, 56, 52, 52)),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField<String>(
          value: selectedRange,
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: Color.fromARGB(137, 56, 52, 52)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
