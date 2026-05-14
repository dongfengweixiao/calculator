import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

import '../../core/services/calculator_service.dart';
import 'angle_mode_types.dart';
import 'radix_types.dart';
import 'trig_types.dart';
import 'word_size_types.dart';

/// 计算器 Model
///
/// 封装 CalculatorService，提供状态管理和 UI 操作方法。
/// 所有计算器页面（标准/科学/程序员）共享同一个 Model 和 Service 实例。
/// 进入不同页面时通过 [setMode] 切换 CalcEngine 模式。
class CalculatorModel extends SafeChangeNotifier {
  CalculatorModel({required CalculatorService service}) : _service = service {
    _service.initialize();
    _service.setMode(CalculatorMode.standard);
  }

  final CalculatorService _service;

  String _display = '0';
  String get display => _display;

  String _expression = '';
  String get expression => _expression;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _hexValue = '0';
  String get hexValue => _hexValue;

  String _decValue = '0';
  String get decValue => _decValue;

  String _octValue = '0';
  String get octValue => _octValue;

  String _binValue = '0';
  String get binValue => _binValue;

  RadixType _selectedRadix = RadixType.dec;
  RadixType get selectedRadix => _selectedRadix;

  int _parenCount = 0;
  int get parenCount => _parenCount;

  WordSize _wordSize = WordSize.qword;
  WordSize get wordSize => _wordSize;

  int _value = 0;
  int get value => _value;

  AngleMode _angleMode = AngleMode.degree;
  AngleMode get angleMode => _angleMode;

  bool _isFtoEActive = false;
  bool get isFtoEActive => _isFtoEActive;

  void _refresh() {
    _display = _service.getPrimaryDisplay();
    _expression = _service.getExpression();
    _hasError = _service.hasError();
    // 进制值
    _hexValue = _service.getResultHex();
    _decValue = _service.getResultDec();
    _octValue = _service.getResultOct();
    _binValue = formatBinary(_service.getResultBin());
    // 同步引擎的进制状态
    _selectedRadix = _radixFromEngine(_service.getRadix());
    // 同步括号计数
    _parenCount = _service.getParenthesisCount();
    // 同步值
    _value = int.tryParse(_decValue) ?? 0;
    // 同步角度模式
    final angleType = _service.getAngleType();
    _angleMode = switch (angleType) {
      0 => AngleMode.degree,
      1 => AngleMode.radian,
      2 => AngleMode.grads,
      _ => AngleMode.degree,
    };
    // BIN 被选中时，主显示区使用格式化后的二进制字符串
    if (_selectedRadix == RadixType.bin) {
      _display = _binValue;
    }
    notifyListeners();
  }

  /// 设置计算器模式（标准/科学/程序员）
  void setMode(CalculatorMode mode) {
    _service.setMode(mode);
    _refresh();
  }

  // 数字输入
  void inputDigit(int digit) {
    final commands = [
      CMD_0,
      CMD_1,
      CMD_2,
      CMD_3,
      CMD_4,
      CMD_5,
      CMD_6,
      CMD_7,
      CMD_8,
      CMD_9,
    ];
    if (digit >= 0 && digit <= 9) {
      _service.sendCommand(commands[digit]);
      _refresh();
    }
  }

  void inputDecimal() {
    _service.sendCommand(CMD_DECIMAL);
    _refresh();
  }

  void inputNegate() {
    _service.sendCommand(CMD_NEGATE);
    _refresh();
  }

  // 十六进制输入 (A-F)
  void inputHex(String hex) {
    final commands = {
      'A': CMD_A,
      'B': CMD_B,
      'C': CMD_C,
      'D': CMD_D,
      'E': CMD_E,
      'F': CMD_F,
    };
    final cmd = commands[hex.toUpperCase()];
    if (cmd != null) {
      _service.sendCommand(cmd);
      _refresh();
    }
  }

  // 四则运算
  void add() {
    _service.sendCommand(CMD_ADD);
    _refresh();
  }

  void subtract() {
    _service.sendCommand(CMD_SUBTRACT);
    _refresh();
  }

  void multiply() {
    _service.sendCommand(CMD_MULTIPLY);
    _refresh();
  }

  void divide() {
    _service.sendCommand(CMD_DIVIDE);
    _refresh();
  }

  void equals() {
    _service.sendCommand(CMD_EQUALS);
    _refresh();
  }

  // 清除
  void clear() {
    _service.sendCommand(CMD_CLEAR);
    _refresh();
  }

  void clearEntry() {
    _service.sendCommand(CMD_CENTR);
    _refresh();
  }

  void backspace() {
    _service.sendCommand(CMD_BACKSPACE);
    _refresh();
  }

  // 百分比
  void percent() {
    _service.sendCommand(CMD_PERCENT);
    _refresh();
  }

  // 函数
  void reciprocal() {
    _service.sendCommand(CMD_RECIPROCAL);
    _refresh();
  }

  void square() {
    _service.sendCommand(CMD_SQUARE);
    _refresh();
  }

  void squareRoot() {
    _service.sendCommand(CMD_SQRT);
    _refresh();
  }

  void cube() {
    _service.sendCommand(CMD_CUBE);
    _refresh();
  }

  void cubeRoot() {
    _service.sendCommand(CMD_CUBEROOT);
    _refresh();
  }

  void power() {
    _service.sendCommand(CMD_POWER);
    _refresh();
  }

  void yRoot() {
    _service.sendCommand(CMD_ROOT);
    _refresh();
  }

  void pow10() {
    _service.sendCommand(CMD_POW10);
    _refresh();
  }

  void pow2() {
    _service.sendCommand(CMD_POW2);
    _refresh();
  }

  void log() {
    _service.sendCommand(CMD_LOG);
    _refresh();
  }

  void ln() {
    _service.sendCommand(CMD_LN);
    _refresh();
  }

  void logBaseY() {
    _service.sendCommand(CMD_LOGBASEY);
    _refresh();
  }

  void powE() {
    _service.sendCommand(CMD_POWE);
    _refresh();
  }

  void pi() {
    _service.sendCommand(CMD_PI);
    _refresh();
  }

  void euler() {
    _service.sendCommand(CMD_EULER);
    _refresh();
  }

  void invert() {
    _service.sendCommand(CMD_INV);
    _refresh();
  }

  void abs() {
    _service.sendCommand(CMD_ABS);
    _refresh();
  }

  void floor() {
    _service.sendCommand(CMD_FLOOR);
    _refresh();
  }

  void ceil() {
    _service.sendCommand(CMD_CEIL);
    _refresh();
  }

  void rand() {
    _service.sendCommand(CMD_RAND);
    _refresh();
  }

  void dms() {
    _service.sendCommand(CMD_DMS);
    _refresh();
  }

  void degrees() {
    _service.sendCommand(CMD_DEG);
    _refresh();
  }

  void radian() {
    _service.sendCommand(CMD_RAD);
    _refresh();
  }

  void grads() {
    _service.sendCommand(CMD_GRAD);
    _refresh();
  }

  void exp() {
    _service.sendCommand(CMD_EXP);
    _refresh();
  }

  void ftoE() {
    _service.sendCommand(CMD_FE);
    _isFtoEActive = !_isFtoEActive;
    _refresh();
  }

  void mod() {
    _service.sendCommand(CMD_MOD);
    _refresh();
  }

  // 位运算
  void and() {
    _service.sendCommand(CMD_AND);
    _refresh();
  }

  void or() {
    _service.sendCommand(CMD_OR);
    _refresh();
  }

  void not() {
    _service.sendCommand(CMD_NOT);
    _refresh();
  }

  void nand() {
    _service.sendCommand(CMD_NAND);
    _refresh();
  }

  void nor() {
    _service.sendCommand(CMD_NOR);
    _refresh();
  }

  void xor() {
    _service.sendCommand(CMD_XOR);
    _refresh();
  }

  // 位移操作
  void lsh() {
    _service.sendCommand(CMD_LSH);
    _refresh();
  }

  void rsh() {
    _service.sendCommand(CMD_RSH);
    _refresh();
  }

  void rshl() {
    _service.sendCommand(CMD_RSHL);
    _refresh();
  }

  void rol() {
    _service.sendCommand(CMD_ROL);
    _refresh();
  }

  void ror() {
    _service.sendCommand(CMD_ROR);
    _refresh();
  }

  void rolc() {
    _service.sendCommand(CMD_ROLC);
    _refresh();
  }

  void rorc() {
    _service.sendCommand(CMD_RORC);
    _refresh();
  }

  void openParen() {
    _service.sendCommand(CMD_OPENP);
    _refresh();
  }

  void closeParen() {
    _service.sendCommand(CMD_CLOSEP);
    _refresh();
  }

  void factorial() {
    _service.sendCommand(CMD_FACTORIAL);
    _refresh();
  }

  // 三角函数
  void sendTrigFunction(TrigFunction func) {
    final command = switch (func) {
      TrigFunction.sin => CMD_SIN,
      TrigFunction.cos => CMD_COS,
      TrigFunction.tan => CMD_TAN,
      TrigFunction.sec => CMD_SEC,
      TrigFunction.csc => CMD_CSC,
      TrigFunction.cot => CMD_COT,
      TrigFunction.invSin => CMD_ASIN,
      TrigFunction.invCos => CMD_ACOS,
      TrigFunction.invTan => CMD_ATAN,
      TrigFunction.invSec => CMD_ASEC,
      TrigFunction.invCsc => CMD_ACSC,
      TrigFunction.invCot => CMD_ACOT,
      TrigFunction.sinh => CMD_SINH,
      TrigFunction.cosh => CMD_COSH,
      TrigFunction.tanh => CMD_TANH,
      TrigFunction.sech => CMD_SECH,
      TrigFunction.csch => CMD_CSCH,
      TrigFunction.coth => CMD_COTH,
      TrigFunction.invSinh => CMD_ASINH,
      TrigFunction.invCosh => CMD_ACOSH,
      TrigFunction.invTanh => CMD_ATANH,
      TrigFunction.invSech => CMD_ASECH,
      TrigFunction.invCsch => CMD_ACSCH,
      TrigFunction.invCoth => CMD_ACOTH,
    };
    _service.sendCommand(command);
    _refresh();
  }

  // 字长操作
  void setWordSize(WordSize size) {
    _wordSize = size;
    final command = switch (size) {
      WordSize.qword => CMD_QWORD,
      WordSize.dword => CMD_DWORD,
      WordSize.word => CMD_WORD,
      WordSize.byte => CMD_BYTE,
    };
    _service.sendCommand(command);
    _refresh();
  }

  // 位翻转操作
  void toggleBit(int bitIndex) {
    // 发送位操作命令
    final command = _service.getBitPositionCommand(bitIndex);
    _service.sendCommand(command);
    _refresh();
  }

  // 进制操作
  static RadixType _radixFromEngine(int value) => switch (value) {
    16 => RadixType.hex,
    8 => RadixType.oct,
    2 => RadixType.bin,
    _ => RadixType.dec,
  };

  static CalcRadixType _radixToEngine(RadixType radix) => switch (radix) {
    RadixType.hex => CalcRadixType.CALC_RADIX_HEX,
    RadixType.dec => CalcRadixType.CALC_RADIX_DECIMAL,
    RadixType.oct => CalcRadixType.CALC_RADIX_OCTAL,
    RadixType.bin => CalcRadixType.CALC_RADIX_BINARY,
  };

  /// 格式化二进制字符串，每段按4位左补0
  ///
  /// 规则：
  /// - 整个字符串为 '0' 时不填充
  /// - 其余情况每段不满4位时左侧补0至4位
  static String formatBinary(String binary) {
    if (binary == '0') return '0';
    return binary
        .split(' ')
        .map((segment) => segment.padLeft(4, '0'))
        .join(' ');
  }

  void setRadix(RadixType radix) {
    _service.setRadix(_radixToEngine(radix));
    _refresh();
  }

  // 内存操作
  void memoryClear() {
    _service.memoryClear();
    _refresh();
  }

  void memoryRecall() {
    _service.memoryRecall();
    _refresh();
  }

  void memoryAdd() {
    _service.memoryAdd();
    _refresh();
  }

  void memorySubtract() {
    _service.memorySubtract();
    _refresh();
  }

  void memoryStore() {
    _service.memoryStore();
    _refresh();
  }

  @override
  Future<void> dispose() async {
    _service.dispose();
    super.dispose();
  }
}
