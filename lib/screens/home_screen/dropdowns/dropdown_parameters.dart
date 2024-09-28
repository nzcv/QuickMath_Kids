import 'package:flutter/material.dart';
import 'package:oral_app_new/question_logic/question_generator.dart'; // Import the Operation enum

// Method to get default range based on operation
String getDefaultRange(Operation operation) {
  switch (operation) {
    case Operation.addition_2A:
      return 'Upto +5';
    case Operation.addition_A:
      return 'Sum of 15';
    case Operation.addition_B:
      return 'Sum upto 100';
    case Operation.subtraction_A:
      return 'Upto 5';
    case Operation.subtraction_B:
      return 'Difference less than 20';
    case Operation.multiplication_C:
      return 'x2';
    case Operation.division_C:
      return 'Divided by 2';
    case Operation.division_D:
      return 'Divided by 10';
    default:
      return 'Select an option';
  }
}

// Method to get dropdown items based on operation
List<DropdownMenuItem<String>> getDropdownItems(Operation selectedOperation) {
  switch (selectedOperation) {
    case Operation.addition_2A:
      return const [
        DropdownMenuItem(
          value: 'Upto +5',
          child: Text('Upto +5', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto +10',
          child: Text('Upto +10', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.addition_A:
      return const [
        DropdownMenuItem(
          value: 'Sum of 15',
          child: Text('Sum of 15', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 18',
          child: Text('Sum of 18', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 50',
          child: Text('Sum of 50', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.addition_B:
      return const [
        DropdownMenuItem(
          value: 'Sum upto 100',
          child: Text('Sum upto 100', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum upto 150',
          child: Text('Sum upto 150', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.subtraction_A:
      return const [
        DropdownMenuItem(
          value: 'Upto 5',
          child: Text('Upto 5', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto 7',
          child: Text('Upto 7', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.subtraction_B:
      return const [
        DropdownMenuItem(
          value: 'Difference less than 20',
          child: Text('Difference less than 20',
              style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Difference less than 50',
          child: Text('Difference less than 50',
              style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.multiplication_C:
      return const [
        DropdownMenuItem(
          value: 'x2',
          child: Text('x2', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'x3',
          child: Text('x3', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.division_C:
      return const [
        DropdownMenuItem(
          value: 'Divided by 2',
          child: Text('Divided by 2', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 10',
          child: Text('Divided by 10', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.division_D:
      return const [
        DropdownMenuItem(
          value: 'Divided by 10',
          child: Text('Divided by 10', style: TextStyle(color: Colors.grey)),
        ),
      ];
    default:
      return [];
  }
}
