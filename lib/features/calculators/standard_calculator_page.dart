import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/calc_button.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/navigation/navigation_provider.dart';
import '../../features/calculator/calculator_provider.dart';
import '../../features/calculator/display_panel.dart';

/// Standard calculator page
///
/// This page contains the standard calculator layout without the header,
/// as the header is now provided by the AppShell.
///
/// Grid structure:
/// - Row 0: Display (spans all 4 columns)
/// - Row 1: Memory buttons (MC, MR, M+, M-, MS)
/// - Row 2-7: Button rows
class StandardCalculatorPage extends ConsumerWidget {
  const StandardCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);
    final showHistoryPanel = ref.watch(showHistoryPanelProvider);
    final memoryCount = ref.watch(calculatorProvider).memoryCount;

    return LayoutGrid(
      // 4 equal columns
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],

      // 8 rows (removed header row compared to StandardGridBody)
      rowSizes: [
        2.fr,    // Row 0: Display
        40.px,   // Row 1: Memory buttons
        1.fr,    // Row 2: Clear row (%, CE, C, ⌫)
        1.fr,    // Row 3: Function row (1/x, x², √x, ÷)
        1.fr,    // Row 4: Number row (7, 8, 9, ×)
        1.fr,    // Row 5: Number row (4, 5, 6, -)
        1.fr,    // Row 6: Number row (1, 2, 3, +)
        1.fr,    // Row 7: Last row (±, 0, ., =)
      ],

      // Add gaps between columns and rows
      columnGap: 0,
      rowGap: 0,

      children: [
        // Row 0: Display (spans all 4 columns)
        const DisplayPanel()
            .withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 4, rowSpan: 1),

        // Row 1: Memory buttons (spans all 4 columns, uses Row inside)
        (Container(
          color: theme.background,
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: CalcButton(
                  text: 'MC',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryClear,
                  isDisabled: memoryCount == 0,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'MR',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryRecall,
                  isDisabled: memoryCount == 0,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'M+',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryAdd,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'M-',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memorySubtract,
                ),
              ),
              Expanded(
                child: CalcButton(
                  text: 'MS',
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryStore,
                ),
              ),
              // Add M button when history panel is hidden (no right panel)
              if (!showHistoryPanel)
                Expanded(
                  child: CalcButton(
                    text: 'M',
                    type: CalcButtonType.memory,
                    onPressed: calculator.memoryRecall,
                    isDisabled: memoryCount == 0,
                  ),
                ),
            ],
          ),
        )).withGridPlacement(columnStart: 0, rowStart: 1, columnSpan: 4, rowSpan: 1),

        // Row 2: Clear row (%, CE, C, ⌫)
        _buildButton(theme, calculator, icon: CalculatorIcons.percent, type: CalcButtonType.operator, onPressed: calculator.percent)
            .withGridPlacement(columnStart: 0, rowStart: 2),
        _buildButton(theme, calculator, text: 'CE', type: CalcButtonType.operator, onPressed: calculator.clearEntry)
            .withGridPlacement(columnStart: 1, rowStart: 2),
        _buildButton(theme, calculator, text: 'C', type: CalcButtonType.operator, onPressed: calculator.clear)
            .withGridPlacement(columnStart: 2, rowStart: 2),
        _buildButton(theme, calculator, icon: CalculatorIcons.backspace, type: CalcButtonType.operator, onPressed: calculator.backspace)
            .withGridPlacement(columnStart: 3, rowStart: 2),

        // Row 3: Function row (1/x, x², √x, ÷)
        _buildButton(theme, calculator, icon: CalculatorIcons.reciprocal, type: CalcButtonType.operator, onPressed: calculator.reciprocal)
            .withGridPlacement(columnStart: 0, rowStart: 3),
        _buildButton(theme, calculator, icon: CalculatorIcons.square, type: CalcButtonType.operator, onPressed: calculator.square)
            .withGridPlacement(columnStart: 1, rowStart: 3),
        _buildButton(theme, calculator, icon: CalculatorIcons.squareRoot, type: CalcButtonType.operator, onPressed: calculator.squareRoot)
            .withGridPlacement(columnStart: 2, rowStart: 3),
        _buildButton(theme, calculator, icon: CalculatorIcons.divide, type: CalcButtonType.operator, onPressed: calculator.divide)
            .withGridPlacement(columnStart: 3, rowStart: 3),

        // Row 4: Number row (7, 8, 9, ×)
        _buildButton(theme, calculator, text: '7', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(7))
            .withGridPlacement(columnStart: 0, rowStart: 4),
        _buildButton(theme, calculator, text: '8', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(8))
            .withGridPlacement(columnStart: 1, rowStart: 4),
        _buildButton(theme, calculator, text: '9', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(9))
            .withGridPlacement(columnStart: 2, rowStart: 4),
        _buildButton(theme, calculator, icon: CalculatorIcons.multiply, type: CalcButtonType.operator, onPressed: calculator.multiply)
            .withGridPlacement(columnStart: 3, rowStart: 4),

        // Row 5: Number row (4, 5, 6, -)
        _buildButton(theme, calculator, text: '4', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(4))
            .withGridPlacement(columnStart: 0, rowStart: 5),
        _buildButton(theme, calculator, text: '5', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(5))
            .withGridPlacement(columnStart: 1, rowStart: 5),
        _buildButton(theme, calculator, text: '6', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(6))
            .withGridPlacement(columnStart: 2, rowStart: 5),
        _buildButton(theme, calculator, icon: CalculatorIcons.minus, type: CalcButtonType.operator, onPressed: calculator.subtract)
            .withGridPlacement(columnStart: 3, rowStart: 5),

        // Row 6: Number row (1, 2, 3, +)
        _buildButton(theme, calculator, text: '1', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(1))
            .withGridPlacement(columnStart: 0, rowStart: 6),
        _buildButton(theme, calculator, text: '2', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(2))
            .withGridPlacement(columnStart: 1, rowStart: 6),
        _buildButton(theme, calculator, text: '3', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(3))
            .withGridPlacement(columnStart: 2, rowStart: 6),
        _buildButton(theme, calculator, icon: CalculatorIcons.plus, type: CalcButtonType.operator, onPressed: calculator.add)
            .withGridPlacement(columnStart: 3, rowStart: 6),

        // Row 7: Last row (±, 0, ., =)
        _buildButton(theme, calculator, icon: CalculatorIcons.negate, type: CalcButtonType.number, onPressed: calculator.inputNegate)
            .withGridPlacement(columnStart: 0, rowStart: 7),
        _buildButton(theme, calculator, text: '0', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(0))
            .withGridPlacement(columnStart: 1, rowStart: 7),
        _buildButton(theme, calculator, text: '.', type: CalcButtonType.number, onPressed: calculator.inputDecimal)
            .withGridPlacement(columnStart: 2, rowStart: 7),
        _buildButton(theme, calculator, icon: CalculatorIcons.equals, type: CalcButtonType.emphasized, onPressed: calculator.equals)
            .withGridPlacement(columnStart: 3, rowStart: 7),
      ],
    );
  }

  /// Helper to build a CalcButton
  Widget _buildButton(
    CalculatorTheme theme,
    CalculatorNotifier calculator, {
    String? text,
    IconData? icon,
    CalcButtonType type = CalcButtonType.number,
    VoidCallback? onPressed,
  }) {
    return CalcButton(
      text: text,
      icon: icon,
      type: type,
      onPressed: onPressed,
    );
  }
}
