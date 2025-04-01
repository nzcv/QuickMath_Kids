import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/question_logic/enum_values.dart';

List<DropdownMenuItem<Range>> getDropdownItems(Operation selectedOperation) {
  List<Range> ranges;
  switch (selectedOperation) {
    case Operation.additionBeginner:
      ranges = [Range.additionBeginner1to5, Range.additionBeginner6to10];
      break;
    case Operation.additionIntermediate:
      ranges = [
        Range.additionIntermediate10to20,
        Range.additionIntermediate20to50
      ];
      break;
    case Operation.additionAdvanced:
      ranges = [Range.additionAdvanced50to100, Range.additionAdvanced100to200];
      break;
    case Operation.subtractionBeginner:
      ranges = [
        Range.subtractionBeginner1to10,
        Range.subtractionBeginner10to20
      ];
      break;
    case Operation.subtractionIntermediate:
      ranges = [
        Range.subtractionIntermediate20to50,
        Range.subtractionIntermediate50to100
      ];
      break;
    case Operation.multiplicationTables:
      ranges = [
        Range.multiplicationTable2,
        Range.multiplicationTable3,
        Range.multiplicationTable4,
        Range.multiplicationTable5,
        Range.multiplicationTable6,
        Range.multiplicationTable7,
        Range.multiplicationTable8,
        Range.multiplicationTable9,
      ];
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
      child: Text(getRangeDisplayName(range)),
    );
  }).toList();
}