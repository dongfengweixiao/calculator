// ignore_for_file: constant_identifier_names


class CalculatorCommands {
  // ========================================================================
  // Digit Commands (0-9)
  // ========================================================================

  /// Digit command: 0
  static const int CMD_0 = 130;

  /// Digit command: 1
  static const int CMD_1 = 131;

  /// Digit command: 2
  static const int CMD_2 = 132;

  /// Digit command: 3
  static const int CMD_3 = 133;

  /// Digit command: 4
  static const int CMD_4 = 134;

  /// Digit command: 5
  static const int CMD_5 = 135;

  /// Digit command: 6
  static const int CMD_6 = 136;

  /// Digit command: 7
  static const int CMD_7 = 137;

  /// Digit command: 8
  static const int CMD_8 = 138;

  /// Digit command: 9
  static const int CMD_9 = 139;

  // ========================================================================
  // Hexadecimal Digit Commands (A-F)
  // ========================================================================

  static const int CMD_A = 140;
  static const int CMD_B = 141;
  static const int CMD_C = 142;
  static const int CMD_D = 143;
  static const int CMD_E = 144;
  static const int CMD_F = 145;

  // ========================================================================
  // Basic Operations
  // ========================================================================

  static const int CMD_ADD = 93;
  static const int CMD_SUBTRACT = 94;
  static const int CMD_MULTIPLY = 92;
  static const int CMD_DIVIDE = 91;
  static const int CMD_MOD = 95;
  static const int CMD_EQUALS = 121;
  static const int CMD_PERCENT = 118;
  static const int CMD_NEGATE = 80;
  static const int CMD_DECIMAL = 84;

  // ========================================================================
  // Clear Operations
  // ========================================================================

  static const int CMD_CLEAR = 81;
  static const int CMD_CENTR = 82;
  static const int CMD_BACKSPACE = 83;

  // ========================================================================
  // Memory Operations
  // ========================================================================

  static const int CMD_MC = 122;
  static const int CMD_MR = 123;
  static const int CMD_MS = 124;
  static const int CMD_MPLUS = 125;
  static const int CMD_MMINUS = 126;

  // ========================================================================
  // Scientific Functions - Basic
  // ========================================================================

  static const int CMD_SQUARE = 111;
  static const int CMD_SQRT = 110;
  static const int CMD_RECIPROCAL = 114;
  static const int CMD_CUBE = 112;
  static const int CMD_CUBEROOT = 116;

  // ========================================================================
  // Power Functions
  // ========================================================================

  static const int CMD_POWER = 97;
  static const int CMD_ROOT = 96;
  static const int CMD_POW2 = 412;
  static const int CMD_POWE = 205;
  static const int CMD_POW10 = 117;

  // ========================================================================
  // Exponential/Logarithmic
  // ========================================================================

  static const int CMD_LN = 108;
  static const int CMD_LOG = 109;
  static const int CMD_LOGBASEY = 500;
  static const int CMD_EXP = 127;

  // ========================================================================
  // Trigonometric
  // ========================================================================

  static const int CMD_SIN = 102;
  static const int CMD_COS = 103;
  static const int CMD_TAN = 104;

  // ========================================================================
  // Inverse Trigonometric
  // ========================================================================

  static const int CMD_ASIN = 202;
  static const int CMD_ACOS = 203;
  static const int CMD_ATAN = 204;

  // ========================================================================
  // Hyperbolic
  // ========================================================================

  static const int CMD_SINH = 105;
  static const int CMD_COSH = 106;
  static const int CMD_TANH = 107;

  // ========================================================================
  // Inverse Hyperbolic
  // ========================================================================

  static const int CMD_ASINH = 206;
  static const int CMD_ACOSH = 207;
  static const int CMD_ATANH = 208;

  // ========================================================================
  // Additional Trigonometric
  // ========================================================================

  static const int CMD_SEC = 400;
  static const int CMD_CSC = 402;
  static const int CMD_COT = 404;

  // ========================================================================
  // Inverse Additional Trigonometric
  // ========================================================================

  static const int CMD_ASEC = 401;
  static const int CMD_ACSC = 403;
  static const int CMD_ACOT = 405;

  // ========================================================================
  // Additional Hyperbolic
  // ========================================================================

  static const int CMD_SECH = 406;
  static const int CMD_CSCH = 408;
  static const int CMD_COTH = 410;

  // ========================================================================
  // Inverse Additional Hyperbolic
  // ========================================================================

  static const int CMD_ASECH = 407;
  static const int CMD_ACSCH = 409;
  static const int CMD_ACOTH = 411;

  // ========================================================================
  // Other Scientific Functions
  // ========================================================================

  static const int CMD_FACTORIAL = 113;
  static const int CMD_ABS = 413;
  static const int CMD_FLOOR = 414;
  static const int CMD_CEIL = 415;
  static const int CMD_DMS = 115;
  static const int CMD_DEGREES = 324;

  // ========================================================================
  // Constants
  // ========================================================================

  static const int CMD_PI = 120;
  static const int CMD_EULER = 601;
  static const int CMD_RAND = 600;

  // ========================================================================
  // Parentheses
  // ========================================================================

  static const int CMD_OPENP = 128;
  static const int CMD_CLOSEP = 129;

  // ========================================================================
  // Toggle Functions
  // ========================================================================

  static const int CMD_FE = 119; // F-E toggle
  static const int CMD_INV = 146; // Inverse function

  // ========================================================================
  // Angle Mode
  // ========================================================================

  static const int CMD_DEG = 321;
  static const int CMD_RAD = 322;
  static const int CMD_GRAD = 323;
  static const int CMD_HYP = 325; // Hyperbolic mode toggle

  // ========================================================================
  // Bitwise Operations
  // ========================================================================

  static const int CMD_AND = 86; // Bitwise AND
  static const int CMD_OR = 87; // Bitwise OR
  static const int CMD_XOR = 88; // Bitwise XOR
  static const int CMD_NOT = 101; // Bitwise NOT (complement)
  static const int CMD_NAND = 501; // Bitwise NAND (NOT of AND)
  static const int CMD_NOR = 502; // Bitwise NOR (NOT of OR)

  // ========================================================================
  // Shift Operations
  // ========================================================================

  static const int CMD_LSH = 89; // Left Shift
  static const int CMD_RSH = 90; // Right Shift (Arithmetic)
  static const int CMD_RSHL = 505; // Right Shift (Logical)
  static const int CMD_ROL = 99; // Rotate Left
  static const int CMD_ROR = 100; // Rotate Right
  static const int CMD_ROLC = 416; // Rotate Left Through Carry
  static const int CMD_RORC = 417; // Rotate Right Through Carry

  // ========================================================================
  // Word Size Operations (Programmer Mode)
  // ========================================================================

  static const int CMD_QWORD = 317; // 64-bit
  static const int CMD_DWORD = 318; // 32-bit
  static const int CMD_WORD = 319; // 16-bit
  static const int CMD_BYTE = 320; // 8-bit

  // ========================================================================
  // Radix/Number Base (Programmer Mode)
  // ========================================================================

  static const int CMD_HEX = 313;
  static const int CMD_DEC = 314;
  static const int CMD_OCT = 315;
  static const int CMD_BIN = 316;

  // ========================================================================
  // Helper Methods
  // ========================================================================

  /// Map digit character to command (0-9, A-F)
  static int mapDigit(int digit) {
    const digitCommands = {
      0: CMD_0,
      1: CMD_1,
      2: CMD_2,
      3: CMD_3,
      4: CMD_4,
      5: CMD_5,
      6: CMD_6,
      7: CMD_7,
      8: CMD_8,
      9: CMD_9,
      10: CMD_A,
      11: CMD_B,
      12: CMD_C,
      13: CMD_D,
      14: CMD_E,
      15: CMD_F,
    };

    if (digit < 0 || digit > 15) {
      throw ArgumentError('Digit must be between 0 and 15');
    }

    return digitCommands[digit]!;
  }

  /// Check if command is a digit (0-9)
  static bool isDigit(int command) {
    return command >= CMD_0 && command <= CMD_9;
  }

  /// Check if command is a hex digit (0-9, A-F)
  static bool isHexDigit(int command) {
    return (command >= CMD_0 && command <= CMD_9) ||
        (command >= CMD_A && command <= CMD_F);
  }

  /// Check if command is a basic operation
  static bool isBasicOperation(int command) {
    return command == CMD_ADD ||
        command == CMD_SUBTRACT ||
        command == CMD_MULTIPLY ||
        command == CMD_DIVIDE ||
        command == CMD_MOD ||
        command == CMD_EQUALS ||
        command == CMD_PERCENT;
  }

  /// Check if command is a clear operation
  static bool isClearOperation(int command) {
    return command == CMD_CLEAR ||
        command == CMD_CENTR ||
        command == CMD_BACKSPACE;
  }

  /// Check if command is a memory operation
  static bool isMemoryOperation(int command) {
    return command == CMD_MC ||
        command == CMD_MR ||
        command == CMD_MS ||
        command == CMD_MPLUS ||
        command == CMD_MMINUS;
  }

  /// Check if command is a scientific function
  static bool isScientificFunction(int command) {
    // Basic scientific
    if (command == CMD_SQUARE ||
        command == CMD_SQRT ||
        command == CMD_RECIPROCAL ||
        command == CMD_CUBE ||
        command == CMD_CUBEROOT) {
      return true;
    }

    // Power functions
    if (command == CMD_POWER ||
        command == CMD_ROOT ||
        command == CMD_POW2 ||
        command == CMD_POWE ||
        command == CMD_POW10) {
      return true;
    }

    // Exponential/Logarithmic
    if (command == CMD_LN ||
        command == CMD_LOG ||
        command == CMD_LOGBASEY ||
        command == CMD_EXP) {
      return true;
    }

    // Trigonometric
    if (command == CMD_SIN ||
        command == CMD_COS ||
        command == CMD_TAN ||
        command == CMD_ASIN ||
        command == CMD_ACOS ||
        command == CMD_ATAN) {
      return true;
    }

    // Hyperbolic
    if (command == CMD_SINH ||
        command == CMD_COSH ||
        command == CMD_TANH ||
        command == CMD_ASINH ||
        command == CMD_ACOSH ||
        command == CMD_ATANH) {
      return true;
    }

    // Additional trig
    if (command == CMD_SEC ||
        command == CMD_CSC ||
        command == CMD_COT ||
        command == CMD_ASEC ||
        command == CMD_ACSC ||
        command == CMD_ACOT) {
      return true;
    }

    // Additional hyperbolic
    if (command == CMD_SECH ||
        command == CMD_CSCH ||
        command == CMD_COTH ||
        command == CMD_ASECH ||
        command == CMD_ACSCH ||
        command == CMD_ACOTH) {
      return true;
    }

    // Other scientific functions
    if (command == CMD_FACTORIAL ||
        command == CMD_ABS ||
        command == CMD_FLOOR ||
        command == CMD_CEIL ||
        command == CMD_DMS ||
        command == CMD_DEGREES) {
      return true;
    }

    return false;
  }

  /// Check if command is a bitwise operation
  static bool isBitwiseOperation(int command) {
    return command == CMD_AND ||
        command == CMD_OR ||
        command == CMD_XOR ||
        command == CMD_NOT ||
        command == CMD_NAND ||
        command == CMD_NOR;
  }

  /// Check if command is a shift operation
  static bool isShiftOperation(int command) {
    return command == CMD_LSH ||
        command == CMD_RSH ||
        command == CMD_RSHL ||
        command == CMD_ROL ||
        command == CMD_ROR ||
        command == CMD_ROLC ||
        command == CMD_RORC;
  }

  /// Private constructor to prevent instantiation
  CalculatorCommands._();
}
