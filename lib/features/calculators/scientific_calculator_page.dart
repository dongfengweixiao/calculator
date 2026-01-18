import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/calculator/calculator_provider.dart';
import '../../features/calculator/display_panel.dart';
import '../../features/calculator/panel_state.dart';
import '../../features/scientific/scientific_provider.dart';
import '../../features/scientific/flyouts/flyout_container.dart';
import '../../features/history/history_list_content.dart';
import '../../features/memory/memory_list_content.dart';
import '../../shared/navigation/panel_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';
import '../../extensions/extensions.dart';

/// Scientific calculator page
///
/// This page contains the scientific calculator layout without the header,
/// as the header is now provided by the AppShell.
///
/// Grid structure: 5 columns × 11 rows (removed header row)
/// - Row 0: Display
/// - Row 1: DEG, F-E buttons
/// - Row 2: Memory buttons
/// - Row 3: Trig, Func flyout buttons
/// - Row 4-10: Keypad area (or history/memory panels)
class ScientificCalculatorPage extends ConsumerWidget {
  const ScientificCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final keypadState = ref.watch(keypadAreaProvider);
    final memoryCount = ref.watch(calculatorProvider).memoryCount;
    final isShifted = ref.watch(scientificShiftProvider);
    final isMobileMode = ref.watch(layoutModeProvider).isMobileMode;

    return Stack(
      children: [
        // Main calculator grid (always visible)
        LayoutGrid(
          // 5 equal columns
          columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],

          // 11 rows (removed header row compared to ScientificGridBody)
          rowSizes: [
            2.fr,    // Row 0: Display
            40.px,   // Row 1: DEG and F-E
            40.px,   // Row 2: Memory buttons
            40.px,   // Row 3: Trig and Func flyouts
            1.fr,    // Row 4-10: Keypad area (or panels)
            1.fr,
            1.fr,
            1.fr,
            1.fr,
            1.fr,
            1.fr,
          ],

          // Add gaps between columns and rows
          columnGap: 2,
          rowGap: 2,

          children: _buildKeypadGridChildren(context, ref, calculator, memoryCount, isShifted, isMobileMode),
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
    bool isShifted,
    bool isMobileMode,
  ) {
    return [
      // Row 0: Display (spans all 5 columns)
      const DisplayPanel()
          .withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 5, rowSpan: 1),

      // Row 1: DEG and F-E buttons
      _buildDEGButton(ref, calculator)
          .withGridPlacement(columnStart: 0, rowStart: 1),
      _buildFEButton(ref, calculator)
          .withGridPlacement(columnStart: 1, rowStart: 1),

      // Row 2: Memory buttons (spans all 5 columns, uses Row inside)
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
            // M button to show memory panel (only when width < 600px)
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
      )).withGridPlacement(columnStart: 0, rowStart: 2, columnSpan: 5, rowSpan: 1),

      // Row 3: Trig and Func flyout buttons (horizontal layout, left aligned)
      (Container(
        color: context.theme.background,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            TrigFlyoutButton(
              ref: ref,
              calculator: calculator,
              theme: context.theme,
            ),
            const SizedBox(width: 8),
            FuncFlyoutButton(
              calculator: calculator,
              theme: context.theme,
            ),
          ],
        ),
      )).withGridPlacement(columnStart: 0, rowStart: 3, columnSpan: 5, rowSpan: 1),

      // Row 4-10: Scientific keypad buttons (always show)
      ..._buildScientificKeypadButtons(ref, calculator, isShifted),
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

  /// Build DEG button
  Widget _buildDEGButton(
    WidgetRef ref,
    CalculatorNotifier calculator,
  ) {
    final scientificState = ref.watch(scientificProvider);

    return CalcButton(
      text: scientificState.angleType.label,
      onPressed: () {
        final notifier = ref.read(scientificProvider.notifier);
        notifier.toggleAngleType();
        calculator.setAngleType(scientificState.angleType.value);
      },
      type: CalcButtonType.function,
    );
  }

  /// Build F-E toggle button
  Widget _buildFEButton(
    WidgetRef ref,
    CalculatorNotifier calculator,
  ) {
    final scientificState = ref.watch(scientificProvider);

    return CalcButton(
      text: 'F-E',
      onPressed: () {
        final notifier = ref.read(scientificProvider.notifier);
        notifier.toggleFE();
        calculator.toggleFE();
      },
      type: scientificState.isFEChecked ? CalcButtonType.emphasized : CalcButtonType.function,
    );
  }

  /// Build Shift toggle button
  Widget _buildShiftButton(
    WidgetRef ref,
  ) {
    final isShifted = ref.watch(scientificShiftProvider);

    return CalcButton(
      icon: CalculatorIcons.shift,
      onPressed: () {
        ref.read(scientificShiftProvider.notifier).toggle();
      },
      type: isShifted ? CalcButtonType.emphasized : CalcButtonType.operator,
    );
  }

  /// Build CE/C button (shared position, shows CE when there's input)
  Widget _buildCECButton(
    WidgetRef ref,
    CalculatorNotifier calculator,
  ) {
    final calcState = ref.watch(calculatorProvider);
    final showCE = calcState.display != '0';

    return CalcButton(
      key: ValueKey('ce_button_${showCE ? 'CE' : 'C'}'),
      text: showCE ? 'CE' : 'C',
      // Always call clearEntry() - it internally decides CE vs C behavior
      onPressed: calculator.clearEntry,
      type: CalcButtonType.operator,
    );
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

  /// Scientific keypad buttons (rows 4-10)
  /// Returns a list of 35 buttons (5 columns × 7 rows)
  List<Widget> _buildScientificKeypadButtons(WidgetRef ref, CalculatorNotifier calculator, bool isShifted) {
    return [
      // Row 4: Shift, π, e, CE/C, ⌫
      _buildShiftButton(ref)
          .withGridPlacement(columnStart: 0, rowStart: 4),
      _buildButton(calculator, icon: CalculatorIcons.pi, type: CalcButtonType.operator, onPressed: calculator.pi)
          .withGridPlacement(columnStart: 1, rowStart: 4),
      _buildButton(calculator, text: 'e', type: CalcButtonType.operator, onPressed: calculator.euler)
          .withGridPlacement(columnStart: 2, rowStart: 4),
      _buildCECButton(ref, calculator)
          .withGridPlacement(columnStart: 3, rowStart: 4),
      _buildButton(calculator, icon: CalculatorIcons.backspace, type: CalcButtonType.operator, onPressed: calculator.backspace)
          .withGridPlacement(columnStart: 4, rowStart: 4),

      // Row 5: x², 1/x, |x|, exp, mod
      _buildButton(calculator, icon: !isShifted ? CalculatorIcons.square : CalculatorIcons.cube, type: CalcButtonType.operator, onPressed: !isShifted ? calculator.square : calculator.cube)
          .withGridPlacement(columnStart: 0, rowStart: 5),
      _buildButton(calculator, icon: CalculatorIcons.reciprocal, type: CalcButtonType.operator, onPressed: calculator.reciprocal)
          .withGridPlacement(columnStart: 1, rowStart: 5),
      _buildButton(calculator, icon: CalculatorIcons.absoluteValue, type: CalcButtonType.operator, onPressed: calculator.abs)
          .withGridPlacement(columnStart: 2, rowStart: 5),
      _buildButton(calculator, text: 'exp', type: CalcButtonType.operator, onPressed: calculator.exp)
          .withGridPlacement(columnStart: 3, rowStart: 5),
      _buildButton(calculator, text: 'mod', type: CalcButtonType.operator, onPressed: calculator.mod)
          .withGridPlacement(columnStart: 4, rowStart: 5),

      // Row 6: √x, (, ), n!, ÷
      _buildButton(calculator, icon: !isShifted ? CalculatorIcons.squareRoot : CalculatorIcons.cubeRoot, type: CalcButtonType.operator, onPressed: isShifted ? calculator.squareRoot : calculator.cubeRoot)
          .withGridPlacement(columnStart: 0, rowStart: 6),
      _buildButton(calculator, text: '(', type: CalcButtonType.operator, onPressed: calculator.openParen)
          .withGridPlacement(columnStart: 1, rowStart: 6),
      _buildButton(calculator, text: ')', type: CalcButtonType.operator, onPressed: calculator.closeParen)
          .withGridPlacement(columnStart: 2, rowStart: 6),
      _buildButton(calculator, icon: CalculatorIcons.factorial, type: CalcButtonType.operator, onPressed: calculator.factorial)
          .withGridPlacement(columnStart: 3, rowStart: 6),
      _buildButton(calculator, icon: CalculatorIcons.divide, type: CalcButtonType.operator, onPressed: calculator.divide)
          .withGridPlacement(columnStart: 4, rowStart: 6),

      // Row 7: x^y, 7, 8, 9, ×
      _buildButton(calculator, icon: !isShifted ? CalculatorIcons.power : CalculatorIcons.yRoot, type: CalcButtonType.operator, onPressed: !isShifted ? calculator.power : calculator.yRoot)
          .withGridPlacement(columnStart: 0, rowStart: 7),
      _buildButton(calculator, text: '7', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(7))
          .withGridPlacement(columnStart: 1, rowStart: 7),
      _buildButton(calculator, text: '8', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(8))
          .withGridPlacement(columnStart: 2, rowStart: 7),
      _buildButton(calculator, text: '9', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(9))
          .withGridPlacement(columnStart: 3, rowStart: 7),
      _buildButton(calculator, icon: CalculatorIcons.multiply, type: CalcButtonType.operator, onPressed: calculator.multiply)
          .withGridPlacement(columnStart: 4, rowStart: 7),

      // Row 8: 10^x, 4, 5, 6, -
      _buildButton(calculator, icon: !isShifted ? CalculatorIcons.powerOf10 : CalculatorIcons.powerOf2, type: CalcButtonType.operator, onPressed: !isShifted ? calculator.pow10 : calculator.pow2)
          .withGridPlacement(columnStart: 0, rowStart: 8),
      _buildButton(calculator, text: '4', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(4))
          .withGridPlacement(columnStart: 1, rowStart: 8),
      _buildButton(calculator, text: '5', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(5))
          .withGridPlacement(columnStart: 2, rowStart: 8),
      _buildButton(calculator, text: '6', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(6))
          .withGridPlacement(columnStart: 3, rowStart: 8),
      _buildButton(calculator, icon: CalculatorIcons.minus, type: CalcButtonType.operator, onPressed: calculator.subtract)
          .withGridPlacement(columnStart: 4, rowStart: 8),

      // Row 9: log, 1, 2, 3, +
      _buildButton(calculator, text: !isShifted ? 'log' : '', icon: isShifted ? CalculatorIcons.logBaseY : null ,type: CalcButtonType.operator, onPressed: calculator.log)
          .withGridPlacement(columnStart: 0, rowStart: 9),
      _buildButton(calculator, text: '1', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(1))
          .withGridPlacement(columnStart: 1, rowStart: 9),
      _buildButton(calculator, text: '2', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(2))
          .withGridPlacement(columnStart: 2, rowStart: 9),
      _buildButton(calculator, text: '3', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(3))
          .withGridPlacement(columnStart: 3, rowStart: 9),
      _buildButton(calculator, icon: CalculatorIcons.plus, type: CalcButtonType.operator, onPressed: calculator.add)
          .withGridPlacement(columnStart: 4, rowStart: 9),

      // Row 10: ln, ±, 0, ., =
      _buildButton(calculator, text: !isShifted ? 'ln' : '', icon: isShifted ? CalculatorIcons.powerOfE : null, type: CalcButtonType.operator, onPressed: calculator.ln)
          .withGridPlacement(columnStart: 0, rowStart: 10),
      _buildButton(calculator, icon: CalculatorIcons.negate, type: CalcButtonType.number, onPressed: calculator.inputNegate)
          .withGridPlacement(columnStart: 1, rowStart: 10),
      _buildButton(calculator, text: '0', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(0))
          .withGridPlacement(columnStart: 2, rowStart: 10),
      _buildButton(calculator, icon: CalculatorIcons.dot, type: CalcButtonType.number, onPressed: calculator.inputDecimal)
          .withGridPlacement(columnStart: 3, rowStart: 10),
      _buildButton(calculator, icon: CalculatorIcons.equals, type: CalcButtonType.emphasized, onPressed: calculator.equals)
          .withGridPlacement(columnStart: 4, rowStart: 10),
    ];
  }
}
