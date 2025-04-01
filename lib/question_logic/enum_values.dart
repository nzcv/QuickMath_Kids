enum Operation {
  additionBeginner,
  additionIntermediate,
  additionAdvanced,
  subtractionBeginner,
  subtractionIntermediate,
  multiplicationTables,
  divisionBasic,
  divisionMixed,
  lcm,
  gcf,
}

enum Range {
  // Addition Beginner
  additionBeginner1to5,
  additionBeginner6to10,
  // Addition Intermediate
  additionIntermediate10to20,
  additionIntermediate20to50,
  // Addition Advanced
  additionAdvanced50to100,
  additionAdvanced100to200,
  // Subtraction Beginner
  subtractionBeginner1to10,
  subtractionBeginner10to20,
  // Subtraction Intermediate
  subtractionIntermediate20to50,
  subtractionIntermediate50to100,
  // Multiplication Tables
  multiplicationTable2,
  multiplicationTable3,
  multiplicationTable4,
  multiplicationTable5,
  multiplicationTable6,
  multiplicationTable7,
  multiplicationTable8,
  multiplicationTable9,
  // Division Basic
  divisionBasicBy2,
  divisionBasicBy3,
  divisionBasicBy4,
  divisionBasicBy5,
  divisionBasicBy6,
  divisionBasicBy7,
  divisionBasicBy8,
  divisionBasicBy9,
  divisionBasicBy10,
  // Division Mixed
  divisionMixed,
  // LCM
  lcmUpto10,
  lcmUpto20,
  lcmUpto30,
  lcmUpto40,
  lcmUpto50,
  lcmUpto60,
  lcmUpto70,
  lcmUpto80,
  lcmUpto90,
  lcmUpto100,
  lcm3NumbersUpto10,
  lcm3NumbersUpto20,
  lcm3NumbersUpto30,
  lcm3NumbersUpto40,
  lcm3NumbersUpto50,
  // GCF
  gcfUpto10,
  gcfUpto20,
  gcfUpto30,
  gcfUpto40,
  gcfUpto50,
  gcfUpto60,
  gcfUpto70,
  gcfUpto80,
  gcfUpto90,
  gcfUpto100,
}

Range getDefaultRange(Operation operation) {
  switch (operation) {
    case Operation.additionBeginner:
      return Range.additionBeginner1to5;
    case Operation.additionIntermediate:
      return Range.additionIntermediate10to20;
    case Operation.additionAdvanced:
      return Range.additionAdvanced50to100;
    case Operation.subtractionBeginner:
      return Range.subtractionBeginner1to10;
    case Operation.subtractionIntermediate:
      return Range.subtractionIntermediate20to50;
    case Operation.multiplicationTables:
      return Range.multiplicationTable2;
    case Operation.divisionBasic:
      return Range.divisionBasicBy2;
    case Operation.divisionMixed:
      return Range.divisionMixed;
    case Operation.lcm:
      return Range.lcmUpto10;
    case Operation.gcf:
      return Range.gcfUpto10;
  }
}

  // Helper method to convert Range enum to display string
  String getRangeDisplayName(Range range) {
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
      case Range.multiplicationTable2:
        return 'x2';
      case Range.multiplicationTable3:
        return 'x3';
      case Range.multiplicationTable4:
        return 'x4';
      case Range.multiplicationTable5:
        return 'x5';
      case Range.multiplicationTable6:
        return 'x6';
      case Range.multiplicationTable7:
        return 'x7';
      case Range.multiplicationTable8:
        return 'x8';
      case Range.multiplicationTable9:
        return 'x9';
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
