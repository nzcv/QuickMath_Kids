import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';

String getDefaultRange(Operation operation) {
  switch (operation) {
    case Operation.additionBeginner: return '1-5';
    case Operation.additionIntermediate: return '10-20';
    case Operation.additionAdvanced: return '50-100';
    case Operation.subtractionBeginner: return '1-10';
    case Operation.subtractionIntermediate: return '20-50';
    case Operation.multiplicationTables: return '2-5';
    case Operation.divisionBasic: return 'Divided by 2';
    case Operation.divisionMixed: return 'Mixed Division';
    case Operation.lcm: return 'upto 10';
    case Operation.gcf: return 'upto 10';
  }
}

List<DropdownMenuItem<String>> getDropdownItems(Operation selectedOperation) {
  switch (selectedOperation) {
    case Operation.additionBeginner:
      return const [
        DropdownMenuItem(value: '1-5', child: Text('1-5')),
        DropdownMenuItem(value: '6-10', child: Text('6-10')),
      ];
    case Operation.additionIntermediate:
      return const [
        DropdownMenuItem(value: '10-20', child: Text('10-20')),
        DropdownMenuItem(value: '20-50', child: Text('20-50')),
      ];
    case Operation.additionAdvanced:
      return const [
        DropdownMenuItem(value: '50-100', child: Text('50-100')),
        DropdownMenuItem(value: '100-200', child: Text('100-200')),
      ];
    case Operation.subtractionBeginner:
      return const [
        DropdownMenuItem(value: '1-10', child: Text('1-10')),
        DropdownMenuItem(value: '10-20', child: Text('10-20')),
      ];
    case Operation.subtractionIntermediate:
      return const [
        DropdownMenuItem(value: '20-50', child: Text('20-50')),
        DropdownMenuItem(value: '50-100', child: Text('50-100')),
      ];
    case Operation.multiplicationTables:
      return const [
        DropdownMenuItem(value: '2-5', child: Text('2-5')),
        DropdownMenuItem(value: '6-10', child: Text('6-10')),
      ];
    case Operation.divisionBasic:
      return const [
        DropdownMenuItem(value: 'Divided by 2', child: Text('Divided by 2')),
        DropdownMenuItem(value: 'Divided by 3', child: Text('Divided by 3')),
        DropdownMenuItem(value: 'Divided by 4', child: Text('Divided by 4')),
        DropdownMenuItem(value: 'Divided by 5', child: Text('Divided by 5')),
        DropdownMenuItem(value: 'Divided by 6', child: Text('Divided by 6')),
        DropdownMenuItem(value: 'Divided by 7', child: Text('Divided by 7')),
        DropdownMenuItem(value: 'Divided by 8', child: Text('Divided by 8')),
        DropdownMenuItem(value: 'Divided by 9', child: Text('Divided by 9')),
        DropdownMenuItem(value: 'Divided by 10', child: Text('Divided by 10')),
      ];
    case Operation.divisionMixed:
      return const [
        DropdownMenuItem(value: 'Mixed Division', child: Text('Mixed Division')),
      ];
    case Operation.lcm:
      return const [
        DropdownMenuItem(value: 'upto 10', child: Text('upto 10')),
        DropdownMenuItem(value: 'upto 20', child: Text('upto 20')),
        DropdownMenuItem(value: 'upto 30', child: Text('upto 30')),
        DropdownMenuItem(value: 'upto 40', child: Text('upto 40')),
        DropdownMenuItem(value: 'upto 50', child: Text('upto 50')),
        DropdownMenuItem(value: 'upto 60', child: Text('upto 60')),
        DropdownMenuItem(value: 'upto 70', child: Text('upto 70')),
        DropdownMenuItem(value: 'upto 80', child: Text('upto 80')),
        DropdownMenuItem(value: 'upto 90', child: Text('upto 90')),
        DropdownMenuItem(value: 'upto 100', child: Text('upto 100')),
        DropdownMenuItem(value: '3 numbers upto 10', child: Text('3 numbers upto 10')),
        DropdownMenuItem(value: '3 numbers upto 20', child: Text('3 numbers upto 20')),
        DropdownMenuItem(value: '3 numbers upto 30', child: Text('3 numbers upto 30')),
        DropdownMenuItem(value: '3 numbers upto 40', child: Text('3 numbers upto 40')),
        DropdownMenuItem(value: '3 numbers upto 50', child: Text('3 numbers upto 50')),
      ];
    case Operation.gcf:
      return const [
        DropdownMenuItem(value: 'upto 10', child: Text('upto 10')),
        DropdownMenuItem(value: 'upto 20', child: Text('upto 20')),
        DropdownMenuItem(value: 'upto 30', child: Text('upto 30')),
        DropdownMenuItem(value: 'upto 40', child: Text('upto 40')),
        DropdownMenuItem(value: 'upto 50', child: Text('upto 50')),
        DropdownMenuItem(value: 'upto 60', child: Text('upto 60')),
        DropdownMenuItem(value: 'upto 70', child: Text('upto 70')),
        DropdownMenuItem(value: 'upto 80', child: Text('upto 80')),
        DropdownMenuItem(value: 'upto 90', child: Text('upto 90')),
        DropdownMenuItem(value: 'upto 100', child: Text('upto 100')),
      ];
  }
}