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
  multiplicationTables2to5,
  multiplicationTables6to10,
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
      return Range.multiplicationTables2to5;
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