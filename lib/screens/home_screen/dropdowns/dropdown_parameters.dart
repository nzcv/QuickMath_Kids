import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';

List<DropdownMenuItem<Range>> getDropdownItems(Operation selectedOperation) {
  List<Range> ranges;
  switch (selectedOperation) {
    case Operation.additionBeginner:
      ranges = [Range.additionBeginner1to5, Range.additionBeginner6to10];
      break;
    case Operation.additionIntermediate:
      ranges = [Range.additionIntermediate10to20, Range.additionIntermediate20to50];
      break;
    case Operation.additionAdvanced:
      ranges = [Range.additionAdvanced50to100, Range.additionAdvanced100to200];
      break;
    case Operation.subtractionBeginner:
      ranges = [Range.subtractionBeginner1to10, Range.subtractionBeginner10to20];
      break;
    case Operation.subtractionIntermediate:
      ranges = [Range.subtractionIntermediate20to50, Range.subtractionIntermediate50to100];
      break;
    case Operation.multiplicationTables:
      ranges = [Range.multiplicationTables2to5, Range.multiplicationTables6to10];
      break;
    case Operation.divisionBasic:
      ranges = [
        Range.divisionBasicBy2,
        Range.divisionBasicBy3,
        Range.divisionBasicBy4,
        Range.divisionBasicBy5,
        Range.divisionBasicBy6,
        Range.divisionBasicBy7,
        Range.divisionBasicBy8,
        Range.divisionBasicBy9,
        Range.divisionBasicBy10,
      ];
      break;
    case Operation.divisionMixed:
      ranges = [Range.divisionMixed];
      break;
    case Operation.lcm:
      ranges = [
        Range.lcmUpto10,
        Range.lcmUpto20,
        Range.lcmUpto30,
        Range.lcmUpto40,
        Range.lcmUpto50,
        Range.lcmUpto60,
        Range.lcmUpto70,
        Range.lcmUpto80,
        Range.lcmUpto90,
        Range.lcmUpto100,
        Range.lcm3NumbersUpto10,
        Range.lcm3NumbersUpto20,
        Range.lcm3NumbersUpto30,
        Range.lcm3NumbersUpto40,
        Range.lcm3NumbersUpto50,
      ];
      break;
    case Operation.gcf:
      ranges = [
        Range.gcfUpto10,
        Range.gcfUpto20,
        Range.gcfUpto30,
        Range.gcfUpto40,
        Range.gcfUpto50,
        Range.gcfUpto60,
        Range.gcfUpto70,
        Range.gcfUpto80,
        Range.gcfUpto90,
        Range.gcfUpto100,
      ];
      break;
  }

  return ranges.map((range) {
    return DropdownMenuItem<Range>(
      value: range,
      child: Text(_getRangeDisplayName(range)),
    );
  }).toList();
}

String _getRangeDisplayName(Range range) {
  switch (range) {
    // Addition Beginner
    case Range.additionBeginner1to5:
      return '1-5';
    case Range.additionBeginner6to10:
      return '6-10';
    // Addition Intermediate
    case Range.additionIntermediate10to20:
      return '10-20';
    case Range.additionIntermediate20to50:
      return '20-50';
    // Addition Advanced
    case Range.additionAdvanced50to100:
      return '50-100';
    case Range.additionAdvanced100to200:
      return '100-200';
    // Subtraction Beginner
    case Range.subtractionBeginner1to10:
      return '1-10';
    case Range.subtractionBeginner10to20:
      return '10-20';
    // Subtraction Intermediate
    case Range.subtractionIntermediate20to50:
      return '20-50';
    case Range.subtractionIntermediate50to100:
      return '50-100';
    // Multiplication Tables
    case Range.multiplicationTables2to5:
      return '2-5';
    case Range.multiplicationTables6to10:
      return '6-10';
    // Division Basic
    case Range.divisionBasicBy2:
      return 'Divided by 2';
    case Range.divisionBasicBy3:
      return 'Divided by 3';
    case Range.divisionBasicBy4:
      return 'Divided by 4';
    case Range.divisionBasicBy5:
      return 'Divided by 5';
    case Range.divisionBasicBy6:
      return 'Divided by 6';
    case Range.divisionBasicBy7:
      return 'Divided by 7';
    case Range.divisionBasicBy8:
      return 'Divided by 8';
    case Range.divisionBasicBy9:
      return 'Divided by 9';
    case Range.divisionBasicBy10:
      return 'Divided by 10';
    // Division Mixed
    case Range.divisionMixed:
      return 'Mixed Division';
    // LCM
    case Range.lcmUpto10:
      return 'upto 10';
    case Range.lcmUpto20:
      return 'upto 20';
    case Range.lcmUpto30:
      return 'upto 30';
    case Range.lcmUpto40:
      return 'upto 40';
    case Range.lcmUpto50:
      return 'upto 50';
    case Range.lcmUpto60:
      return 'upto 60';
    case Range.lcmUpto70:
      return 'upto 70';
    case Range.lcmUpto80:
      return 'upto 80';
    case Range.lcmUpto90:
      return 'upto 90';
    case Range.lcmUpto100:
      return 'upto 100';
    case Range.lcm3NumbersUpto10:
      return '3 numbers upto 10';
    case Range.lcm3NumbersUpto20:
      return '3 numbers upto 20';
    case Range.lcm3NumbersUpto30:
      return '3 numbers upto 30';
    case Range.lcm3NumbersUpto40:
      return '3 numbers upto 40';
    case Range.lcm3NumbersUpto50:
      return '3 numbers upto 50';
    // GCF
    case Range.gcfUpto10:
      return 'upto 10';
    case Range.gcfUpto20:
      return 'upto 20';
    case Range.gcfUpto30:
      return 'upto 30';
    case Range.gcfUpto40:
      return 'upto 40';
    case Range.gcfUpto50:
      return 'upto 50';
    case Range.gcfUpto60:
      return 'upto 60';
    case Range.gcfUpto70:
      return 'upto 70';
    case Range.gcfUpto80:
      return 'upto 80';
    case Range.gcfUpto90:
      return 'upto 90';
    case Range.gcfUpto100:
      return 'upto 100';
  }
}