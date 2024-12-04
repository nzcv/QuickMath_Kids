import 'package:flutter/material.dart';
import 'package:oral_app/question_logic/question_generator.dart'; // Import the Operation enum

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
    case Operation.lcm:
      return 'upto 10';
    case Operation.gcf:
      return 'upto 10';
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
          value: 'Sum of 18',
          child: Text('Sum of 18', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 20',
          child: Text('Sum of 20', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 22',
          child: Text('Sum of 22', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 24',
          child: Text('Sum of 24', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 26',
          child: Text('Sum of 26', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum of 28',
          child: Text('Sum of 28', style: TextStyle(color: Colors.grey)),
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
        DropdownMenuItem(
          value: 'Sum upto 200',
          child: Text('Sum upto 200', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Sum upto 250',
          child: Text('Sum upto 250', style: TextStyle(color: Colors.grey)),
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
        DropdownMenuItem(
          value: 'Upto 9',
          child: Text('Upto 9', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto 11',
          child: Text('Upto 11', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto 13',
          child: Text('Upto 13', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto 15',
          child: Text('Upto 15', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto 17',
          child: Text('Upto 17', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Upto 19',
          child: Text('Upto 19', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.subtraction_B:
      return const [
        DropdownMenuItem(
          value: 'Less than 20',
          child: Text('Difference less than 20',
              style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Less than 40',
          child: Text('Difference less than 40',
              style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Less than 60',
          child: Text('Difference less than 60',
              style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Less than 80',
          child: Text('Difference less than 80',
              style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Less than 100',
          child: Text('Difference less than 100',
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
        DropdownMenuItem(
          value: 'x4',
          child: Text('x4', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'x5',
          child: Text('x5', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'x6',
          child: Text('x6', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'x7',
          child: Text('x7', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'x8',
          child: Text('x8', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'x9',
          child: Text('x9', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.division_C:
      return const [
        DropdownMenuItem(
          value: 'Divided by 2',
          child: Text('Divided by 2', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 3',
          child: Text('Divided by 3', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 4',
          child: Text('Divided by 4', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 5',
          child: Text('Divided by 5', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 6',
          child: Text('Divided by 6', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 7',
          child: Text('Divided by 7', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 8',
          child: Text('Divided by 8', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'Divided by 9',
          child: Text('Divided by 9', style: TextStyle(color: Colors.grey)),
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
    case Operation.lcm:
      return const [
        DropdownMenuItem(
          value: 'upto 10',
          child: Text('upto 10', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 20',
          child: Text('upto 20', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 30',
          child: Text('upto 30', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 40',
          child: Text('upto 40', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 50',
          child: Text('upto 50', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 60',
          child: Text('upto 60', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 70',
          child: Text('upto 70', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 80',
          child: Text('upto 80', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 90',
          child: Text('upto 90', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 100',
          child: Text('upto 100', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: '3 numbers upto 10',
          child: Text('3 numbers upto 10', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: '3 numbers upto 20',
          child: Text('3 numbers upto 20', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: '3 numbers upto 30',
          child: Text('3 numbers upto 30', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: '3 numbers upto 40',
          child: Text('3 numbers upto 40', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: '3 numbers upto 50',
          child: Text('3 numbers upto 50', style: TextStyle(color: Colors.grey)),
        ),
      ];
    case Operation.gcf:
      return const [
        DropdownMenuItem(
          value: 'None',
          child: Text('None', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 10',
          child: Text('upto 10', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 20',
          child: Text('upto 20', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 30',
          child: Text('upto 30', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 40',
          child: Text('upto 40', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 50',
          child: Text('upto 50', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 60',
          child: Text('upto 60', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 70',
          child: Text('upto 70', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 80',
          child: Text('upto 80', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 90',
          child: Text('upto 90', style: TextStyle(color: Colors.grey)),
        ),
        DropdownMenuItem(
          value: 'upto 100',
          child: Text('upto 100', style: TextStyle(color: Colors.grey)),
        ),
      ];
    default:
      return [];
  }
}
