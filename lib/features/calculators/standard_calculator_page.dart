import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/calc_button.dart';
import '../../features/calculator/calculator_provider.dart';
import '../../features/calculator/display_panel.dart';
import '../../features/calculator/panel_state.dart';
import '../../features/history/history_list_content.dart';
import '../../features/memory/memory_list_content.dart';
import '../../shared/navigation/panel_provider.dart';
import '../../extensions/extensions.dart';

/// Standard calculator page
///
/// This page contains the standard calculator layout without the header,
/// as the header is now provided by the AppShell.
///
/// Grid structure:
/// - Row 0: Display (spans all 4 columns)
/// - Row 1: Memory buttons (MC, MR, M+, M-, MS)
/// - Row 2-7: Button rows or panels (keypad/history/memory)
class StandardCalculatorPage extends ConsumerWidget {
  const StandardCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final keypadState = ref.watch(keypadAreaProvider);
    final memoryCount = ref.watch(calculatorProvider).memoryCount;
    final isMobileMode = ref.watch(layoutModeProvider).isMobileMode;

    return Stack(
      children: [
        // Main calculator grid (always visible)
        LayoutGrid(
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

          children: _buildKeypadGridChildren(context, ref, calculator, memoryCount, isMobileMode),
        ),
        // Floating panel overlay (only when showing history/memory in mobile mode)
        if (isMobileMode && keypadState.currentType != KeypadAreaType.keypad)
          _buildPanelOverlay(context, ref, keypadState),
      ],
    );
  }

  /// Build keypad grid children (always shows keypad buttons)
  List<Widget> _buildKeypadGridChildren(
    BuildContext context,
    WidgetRef ref,
    CalculatorNotifier calculator,
    int memoryCount,
    bool isMobileMode,
  ) {
    return [
      // Row 0: Display (spans all 4 columns)
      const DisplayPanel()
          .withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 4, rowSpan: 1),

      // Row 1: Memory buttons (spans all 4 columns, uses Row inside)
      (Container(
        color: context.theme.background,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: CalcButton(
                icon: CalculatorIcons.memoryClear,
                type: CalcButtonType.memory,
                onPressed: calculator.memoryClear,
                isDisabled: memoryCount == 0,
              ),
            ),
            Expanded(
              child: CalcButton(
                icon: CalculatorIcons.memoryRecall,
                type: CalcButtonType.memory,
                onPressed: calculator.memoryRecall,
                isDisabled: memoryCount == 0,
              ),
            ),
            Expanded(
              child: CalcButton(
                icon: CalculatorIcons.memoryAdd,
                type: CalcButtonType.memory,
                onPressed: calculator.memoryAdd,
              ),
            ),
            Expanded(
              child: CalcButton(
                icon: CalculatorIcons.memorySubtract,
                type: CalcButtonType.memory,
                onPressed: calculator.memorySubtract,
              ),
            ),
            Expanded(
              child: CalcButton(
                icon: CalculatorIcons.memoryStore,
                type: CalcButtonType.memory,
                onPressed: calculator.memoryStore,
              ),
            ),
            // M button to show memory panel (only in mobile mode)
            if (isMobileMode)
              Expanded(
                child: CalcButton(
                  icon: CalculatorIcons.showMemoryPanel,                  
                  type: CalcButtonType.memory,
                  onPressed: () {
                    ref.read(keypadAreaProvider.notifier).toggle(KeypadAreaType.memory);
                  },
                ),
              ),
          ],
        ),
      )).withGridPlacement(columnStart: 0, rowStart: 1, columnSpan: 4, rowSpan: 1),

      // Row 2-7: Standard keypad buttons (always show)
      ..._buildStandardKeypadButtons(calculator),
    ];
  }

  /// Build panel overlay with tap-outside-to-close functionality
  Widget _buildPanelOverlay(BuildContext context, WidgetRef ref, keypadState) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          // Close panel when tapping outside
          ref.read(keypadAreaProvider.notifier).showKeypad();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.3), // Semi-transparent overlay
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              return Align(
                alignment: isSmallScreen ? Alignment.bottomCenter : Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // Don't close when tapping inside the panel
                  },
                  child: Container(
                    width: isSmallScreen ? double.infinity : 320,
                    height: isSmallScreen ? constraints.maxHeight / 1.5 : 400,
                    decoration: BoxDecoration(
                      color: context.theme.background,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 0 : 8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isSmallScreen ? 0 : 8),
                      child: keypadState.currentType == KeypadAreaType.history
                          ? const HistoryListContent()
                          : const MemoryListContent(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Standard keypad buttons (rows 2-7)
  /// Returns a list of 24 buttons (4 columns × 6 rows)
  List<Widget> _buildStandardKeypadButtons(CalculatorNotifier calculator) {
    return [
      // Row 2: Clear row (%, CE, C, ⌫)
      _buildButton(calculator, icon: CalculatorIcons.percent, type: CalcButtonType.operator, onPressed: calculator.percent)
          .withGridPlacement(columnStart: 0, rowStart: 2),
      _buildButton(calculator, text: 'CE', type: CalcButtonType.operator, onPressed: calculator.clearEntry)
          .withGridPlacement(columnStart: 1, rowStart: 2),
      _buildButton(calculator, text: 'C', type: CalcButtonType.operator, onPressed: calculator.clear)
          .withGridPlacement(columnStart: 2, rowStart: 2),
      _buildButton(calculator, icon: CalculatorIcons.backspace, type: CalcButtonType.operator, onPressed: calculator.backspace)
          .withGridPlacement(columnStart: 3, rowStart: 2),

      // Row 3: Function row (1/x, x², √x, ÷)
      _buildButton(calculator, icon: CalculatorIcons.reciprocal, type: CalcButtonType.operator, onPressed: calculator.reciprocal)
          .withGridPlacement(columnStart: 0, rowStart: 3),
      _buildButton(calculator, icon: CalculatorIcons.square, type: CalcButtonType.operator, onPressed: calculator.square)
          .withGridPlacement(columnStart: 1, rowStart: 3),
      _buildButton(calculator, icon: CalculatorIcons.squareRoot, type: CalcButtonType.operator, onPressed: calculator.squareRoot)
          .withGridPlacement(columnStart: 2, rowStart: 3),
      _buildButton(calculator, icon: CalculatorIcons.divide, type: CalcButtonType.operator, onPressed: calculator.divide)
          .withGridPlacement(columnStart: 3, rowStart: 3),

      // Row 4: Number row (7, 8, 9, ×)
      _buildButton(calculator, text: '7', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(7))
          .withGridPlacement(columnStart: 0, rowStart: 4),
      _buildButton(calculator, text: '8', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(8))
          .withGridPlacement(columnStart: 1, rowStart: 4),
      _buildButton(calculator, text: '9', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(9))
          .withGridPlacement(columnStart: 2, rowStart: 4),
      _buildButton(calculator, icon: CalculatorIcons.multiply, type: CalcButtonType.operator, onPressed: calculator.multiply)
          .withGridPlacement(columnStart: 3, rowStart: 4),

      // Row 5: Number row (4, 5, 6, -)
      _buildButton(calculator, text: '4', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(4))
          .withGridPlacement(columnStart: 0, rowStart: 5),
      _buildButton(calculator, text: '5', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(5))
          .withGridPlacement(columnStart: 1, rowStart: 5),
      _buildButton(calculator, text: '6', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(6))
          .withGridPlacement(columnStart: 2, rowStart: 5),
      _buildButton(calculator, icon: CalculatorIcons.minus, type: CalcButtonType.operator, onPressed: calculator.subtract)
          .withGridPlacement(columnStart: 3, rowStart: 5),

      // Row 6: Number row (1, 2, 3, +)
      _buildButton(calculator, text: '1', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(1))
          .withGridPlacement(columnStart: 0, rowStart: 6),
      _buildButton(calculator, text: '2', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(2))
          .withGridPlacement(columnStart: 1, rowStart: 6),
      _buildButton(calculator, text: '3', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(3))
          .withGridPlacement(columnStart: 2, rowStart: 6),
      _buildButton(calculator, icon: CalculatorIcons.plus, type: CalcButtonType.operator, onPressed: calculator.add)
          .withGridPlacement(columnStart: 3, rowStart: 6),

      // Row 7: Last row (±, 0, ., =)
      _buildButton(calculator, icon: CalculatorIcons.negate, type: CalcButtonType.number, onPressed: calculator.inputNegate)
          .withGridPlacement(columnStart: 0, rowStart: 7),
      _buildButton(calculator, text: '0', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(0))
          .withGridPlacement(columnStart: 1, rowStart: 7),
      _buildButton(calculator, icon: CalculatorIcons.dot, type: CalcButtonType.number, onPressed: calculator.inputDecimal)
          .withGridPlacement(columnStart: 2, rowStart: 7),
      _buildButton(calculator, icon: CalculatorIcons.equals, type: CalcButtonType.emphasized, onPressed: calculator.equals)
          .withGridPlacement(columnStart: 3, rowStart: 7),
    ];
  }

  /// Helper to build a CalcButton
  Widget _buildButton(
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
