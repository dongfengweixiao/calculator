import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/calculator/calculator_provider.dart';
import '../../features/calculator/display_panel.dart';
import '../../features/calculator/panel_state.dart';
import '../../features/memory/memory_list_content.dart';
import '../../shared/navigation/panel_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';
import '../../features/programmer/programmer_provider.dart';
import '../../features/programmer/services/programmer_button_service.dart';
import '../../features/programmer/flyouts/bitwise_flyout.dart';
import '../../features/programmer/flyouts/shift_flyout.dart';
import '../../features/programmer/widgets/bit_flip_keypad.dart';
import '../../extensions/extensions.dart';

/// Programmer calculator page
///
/// This page contains the programmer calculator layout without the header,
/// as the header is now provided by the AppShell.
///
/// Grid structure: 5 columns × 13 rows (removed header row)
/// - Row 0: Display
/// - Row 1: HEX button
/// - Row 2: DEC button
/// - Row 3: OCT button
/// - Row 4: BIN button
/// - Row 5: Control buttons
/// - Row 6: Bitwise and Shift flyout buttons
/// - Row 7-12: Main button grid (or memory panel)
class ProgrammerCalculatorPage extends ConsumerWidget {
  const ProgrammerCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmerState = ref.watch(programmerProvider);
    final calculatorState = ref.watch(calculatorProvider);
    final buttonService = ProgrammerButtonService(ref);
    final keypadState = ref.watch(keypadAreaProvider);
    final currentPath = GoRouterState.of(context).uri.path;
    final isProgrammerMode = currentPath == '/programmer';
    final isMobileMode = ref.watch(layoutModeProvider).isMobileMode;

    // Initialize when in programmer mode
    if (isProgrammerMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(programmerProvider.notifier).initialize();
      });
    }

    // Listen to calculator state changes and update programmer display values
    // This ensures that when users input numbers, all base displays are synchronized
    ref.listen<CalculatorState>(calculatorProvider, (previous, next) {
      // Always update in programmer mode, not just when display changes
      // This is important for bit flip operations which may change the internal value
      // without changing the primary display (e.g., when toggling bits in non-current radix)
      if (isProgrammerMode) {
        ref.read(programmerProvider.notifier).updateValuesFromCalculator();
      }
    });

    return Stack(
      children: [
        // Main calculator grid (always visible)
        LayoutGrid(
          // 5 equal columns
          columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],

          // 13 rows with different heights (removed header row)
          rowSizes: [
            2.fr, // Row 0: Display
            40.px, // Row 1: HEX
            40.px, // Row 2: DEC
            40.px, // Row 3: OCT
            40.px, // Row 4: BIN
            40.px, // Row 5: Control buttons
            40.px, // Row 6: Bitwise and Shift flyouts
            1.fr, // Row 7: A, <<, >>, C/CE, DEL
            1.fr, // Row 8: B, (, ), %, ÷
            1.fr, // Row 9: C, 7, 8, 9, ×
            1.fr, // Row 10: D, 4, 5, 6, -
            1.fr, // Row 11: E, 1, 2, 3, +
            1.fr, // Row 12: F, ±, 0, ., =
          ],

          // Add gaps between columns and rows
          columnGap: 2,
          rowGap: 2,

          children: _buildKeypadGridChildren(
            context,
            ref,
            programmerState,
            calculatorState,
            buttonService,
            isMobileMode,
          ),
        ),
        // Floating panel overlay (only when showing memory in mobile mode)
        if (isMobileMode && keypadState.currentType != KeypadAreaType.keypad)
          _buildPanelOverlay(context, ref, keypadState),
      ],
    );
  }

  /// Build keypad grid children (shows content based on input mode)
  List<Widget> _buildKeypadGridChildren(
    BuildContext context,
    WidgetRef ref,
    ProgrammerState programmerState,
    CalculatorState calculatorState,
    ProgrammerButtonService buttonService,
    bool isMobileMode,
  ) {
    // Build base buttons and control buttons (rows 0-6)
    final baseChildren = [
      // Row 0: Display (spans all 5 columns)
      const DisplayPanel().withGridPlacement(
        columnStart: 0,
        rowStart: 0,
        columnSpan: 5,
        rowSpan: 1,
      ),

      // Row 1: HEX button
      _buildBaseButton(
        context,
        'HEX',
        programmerState.hexValue,
        programmerState.currentBase == ProgrammerBase.hex,
        () => _handleBaseSelected(ref, ProgrammerBase.hex),
      ).withGridPlacement(
        columnStart: 0,
        rowStart: 1,
        columnSpan: 5,
        rowSpan: 1,
      ),

      // Row 2: DEC button
      _buildBaseButton(
        context,
        'DEC',
        programmerState.decValue,
        programmerState.currentBase == ProgrammerBase.dec,
        () => _handleBaseSelected(ref, ProgrammerBase.dec),
      ).withGridPlacement(
        columnStart: 0,
        rowStart: 2,
        columnSpan: 5,
        rowSpan: 1,
      ),

      // Row 3: OCT button
      _buildBaseButton(
        context,
        'OCT',
        programmerState.octValue,
        programmerState.currentBase == ProgrammerBase.oct,
        () => _handleBaseSelected(ref, ProgrammerBase.oct),
      ).withGridPlacement(
        columnStart: 0,
        rowStart: 3,
        columnSpan: 5,
        rowSpan: 1,
      ),

      // Row 4: BIN button
      _buildBaseButton(
        context,
        'BIN',
        programmerState.binValue,
        programmerState.currentBase == ProgrammerBase.bin,
        () => _handleBaseSelected(ref, ProgrammerBase.bin),
      ).withGridPlacement(
        columnStart: 0,
        rowStart: 4,
        columnSpan: 5,
        rowSpan: 1,
      ),

      // Row 5: Control buttons (spans all 5 columns, horizontal layout)
      Builder(
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.theme.background,
            border: Border(
              top: BorderSide(color: context.theme.divider, width: 1),
              bottom: BorderSide(color: context.theme.divider, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Full keypad button
              Expanded(
                child: _ControlButton(
                  icon: CalculatorIcons.fullKeypad,
                  tooltip: '全键盘',
                  isSelected:
                      programmerState.inputMode ==
                      ProgrammerInputMode.fullKeypad,
                  onTap: () =>
                      ref.read(programmerProvider.notifier).toggleInputMode(),
                ),
              ),
              const SizedBox(width: 8),
              // Bit flip button
              Expanded(
                child: _ControlButton(
                  icon: CalculatorIcons.bitFlip,
                  tooltip: '位翻转',
                  isSelected:
                      programmerState.inputMode == ProgrammerInputMode.bitFlip,
                  onTap: () =>
                      ref.read(programmerProvider.notifier).toggleInputMode(),
                ),
              ),
              const SizedBox(width: 8),
              // Word size button
              Expanded(
                child: _ControlButton(
                  label: programmerState.wordSize.label,
                  isSelected: false,
                  onTap: () =>
                      ref.read(programmerProvider.notifier).cycleWordSize(),
                ),
              ),
              const SizedBox(width: 8),
              // MS button
              Expanded(
                child: _ControlButton(
                  icon: CalculatorIcons.memoryStore,
                  isSelected: false,
                  onTap: () {
                    final calculator = ref.read(calculatorProvider.notifier);
                    calculator.memoryStore();
                  },
                ),
              ),
              // M button to show memory panel (only in mobile mode)
              if (isMobileMode) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _ControlButton(
                    label: 'M',
                    isSelected: false,
                    onTap: () {
                      ref
                          .read(keypadAreaProvider.notifier)
                          .toggle(KeypadAreaType.memory);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ).withGridPlacement(
        columnStart: 0,
        rowStart: 5,
        columnSpan: 5,
        rowSpan: 1,
      ),

      // Row 6: Bitwise and Shift flyout buttons (horizontal layout, left aligned)
      Builder(
        builder: (context) => Container(
          color: context.theme.background,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              BitwiseFlyoutButton(
                programmer: ref.read(programmerProvider.notifier),
                theme: context.theme,
              ),
              const SizedBox(width: 8),
              ShiftFlyoutButton(
                programmer: ref.read(programmerProvider.notifier),
                theme: context.theme,
                currentMode: programmerState.shiftMode,
              ),
            ],
          ),
        ),
      ).withGridPlacement(
        columnStart: 0,
        rowStart: 6,
        columnSpan: 5,
        rowSpan: 1,
      ),
    ];

    // Add content for rows 7-12 based on input mode
    if (programmerState.inputMode == ProgrammerInputMode.bitFlip) {
      // Bit flip keypad (spans all remaining rows)
      return [
        ...baseChildren,
        const BitFlipKeypad().withGridPlacement(
          columnStart: 0,
          rowStart: 7,
          columnSpan: 5,
          rowSpan: 6,
        ),
      ];
    } else {
      // Standard programmer keypad buttons
      return [
        ...baseChildren,
        ..._buildProgrammerKeypadButtons(
          ref,
          programmerState,
          calculatorState,
          buttonService,
        ),
      ];
    }
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
          color: Colors.black.withValues(
            alpha: 0.3,
          ), // Semi-transparent overlay
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              return Align(
                alignment: isSmallScreen
                    ? Alignment.bottomCenter
                    : Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // Don't close when tapping inside the panel
                  },
                  child: Container(
                    width: isSmallScreen ? double.infinity : 320,
                    height: isSmallScreen ? constraints.maxHeight / 1.5 : 400,
                    decoration: BoxDecoration(
                      color: context.theme.background,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 0 : 8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 0 : 8,
                      ),
                      child: const MemoryListContent(),
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

  /// Handle base selection (HEX/DEC/OCT/BIN)
  void _handleBaseSelected(WidgetRef ref, ProgrammerBase base) {
    // Update programmer provider state (will also sync radix to calculator engine)
    ref.read(programmerProvider.notifier).setCurrentBase(base);
  }

  /// Build base conversion button (HEX/DEC/OCT/BIN)
  Widget _buildBaseButton(
    BuildContext context,
    String label,
    String value,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      color: context.theme.background,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.theme.textPrimary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isSelected ? context.theme.accent : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: context.theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: context.theme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build programmer calculator button
  Widget _buildProgrammerButton(
    String label,
    WidgetRef ref,
    ProgrammerState programmerState,
    CalculatorState calculatorState,
    ProgrammerButtonService buttonService,
  ) {
    final isDisabled = buttonService.isButtonDisabled(label, programmerState);
    final labelInfo = _getLabelInfo(label, calculatorState);
    final buttonType = _getButtonType(label);

    return CalcButton(
      text: labelInfo.displayLabel,
      icon: labelInfo.icon,
      type: buttonType,
      isDisabled: isDisabled,
      onPressed: isDisabled
          ? null
          : () => buttonService.handleButtonPress(label, programmerState),
    );
  }

  /// Get label info for button (handles special labels like C/CE)
  _LabelInfo _getLabelInfo(String label, CalculatorState calculatorState) {
    IconData? icon;
    String displayLabel = label;

    if (label == 'C/CE') {
      final showCE = calculatorState.display != '0';
      displayLabel = showCE ? 'CE' : 'C';
    } else if (label == 'DEL') {
      icon = CalculatorIcons.backspace;
      displayLabel = ''; // Use icon only
    } else if (label == '+') {
      icon = CalculatorIcons.plus;
      displayLabel = ''; // Use icon only
    } else if (label == '-') {
      icon = CalculatorIcons.minus;
      displayLabel = ''; // Use icon only
    } else if (label == '×') {
      icon = CalculatorIcons.multiply;
      displayLabel = ''; // Use icon only
    } else if (label == '÷') {
      icon = CalculatorIcons.divide;
      displayLabel = ''; // Use icon only
    } else if (label == '=') {
      icon = CalculatorIcons.equals;
      displayLabel = ''; // Use icon only
    } else if (label == '%') {
      icon = CalculatorIcons.percent;
      displayLabel = ''; // Use icon only
    } else if (label == '±') {
      icon = CalculatorIcons.negate;
      displayLabel = ''; // Use icon only
    } else if (label == '.') {
      icon = CalculatorIcons.dot;
      displayLabel = ''; // Use icon only
    }

    return _LabelInfo(displayLabel: displayLabel, icon: icon);
  }

  /// Get button type based on label
  CalcButtonType _getButtonType(String label) {
    if (label == '=') {
      return CalcButtonType.emphasized;
    } else if ([
      '+',
      '-',
      '×',
      '÷',
      '%',
      '<<',
      '>>',
      '(',
      ')',
      'DEL',
    ].contains(label)) {
      return CalcButtonType.operator;
    } else if (label == 'C/CE') {
      // C/CE button is always operator style (clear button)
      return CalcButtonType.operator;
    } else {
      return CalcButtonType.number;
    }
  }

  /// Programmer keypad buttons (rows 7-12)
  /// Returns a list of 30 buttons (5 columns × 6 rows) for full keypad mode
  List<Widget> _buildProgrammerKeypadButtons(
    WidgetRef ref,
    ProgrammerState programmerState,
    CalculatorState calculatorState,
    ProgrammerButtonService buttonService,
  ) {
    // Only show full keypad when in fullKeypad mode
    if (programmerState.inputMode != ProgrammerInputMode.fullKeypad) {
      return [];
    }

    return [
      // Row 7: A, <<, >>, C/CE, DEL
      _buildProgrammerButton(
        'A',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 0, rowStart: 7),
      _buildProgrammerButton(
        '<<',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 1, rowStart: 7),
      _buildProgrammerButton(
        '>>',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 2, rowStart: 7),
      _buildProgrammerButton(
        'C/CE',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 3, rowStart: 7),
      _buildProgrammerButton(
        'DEL',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 4, rowStart: 7),

      // Row 8: B, (, ), %, ÷
      _buildProgrammerButton(
        'B',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 0, rowStart: 8),
      _buildProgrammerButton(
        '(',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 1, rowStart: 8),
      _buildProgrammerButton(
        ')',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 2, rowStart: 8),
      _buildProgrammerButton(
        '%',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 3, rowStart: 8),
      _buildProgrammerButton(
        '÷',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 4, rowStart: 8),

      // Row 9: C, 7, 8, 9, ×
      _buildProgrammerButton(
        'C',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 0, rowStart: 9),
      _buildProgrammerButton(
        '7',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 1, rowStart: 9),
      _buildProgrammerButton(
        '8',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 2, rowStart: 9),
      _buildProgrammerButton(
        '9',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 3, rowStart: 9),
      _buildProgrammerButton(
        '×',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 4, rowStart: 9),

      // Row 10: D, 4, 5, 6, -
      _buildProgrammerButton(
        'D',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 0, rowStart: 10),
      _buildProgrammerButton(
        '4',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 1, rowStart: 10),
      _buildProgrammerButton(
        '5',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 2, rowStart: 10),
      _buildProgrammerButton(
        '6',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 3, rowStart: 10),
      _buildProgrammerButton(
        '-',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 4, rowStart: 10),

      // Row 11: E, 1, 2, 3, +
      _buildProgrammerButton(
        'E',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 0, rowStart: 11),
      _buildProgrammerButton(
        '1',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 1, rowStart: 11),
      _buildProgrammerButton(
        '2',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 2, rowStart: 11),
      _buildProgrammerButton(
        '3',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 3, rowStart: 11),
      _buildProgrammerButton(
        '+',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 4, rowStart: 11),

      // Row 12: F, ±, 0, ., =
      _buildProgrammerButton(
        'F',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 0, rowStart: 12),
      _buildProgrammerButton(
        '±',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 1, rowStart: 12),
      _buildProgrammerButton(
        '0',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 2, rowStart: 12),
      _buildProgrammerButton(
        '.',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 3, rowStart: 12),
      _buildProgrammerButton(
        '=',
        ref,
        programmerState,
        calculatorState,
        buttonService,
      ).withGridPlacement(columnStart: 4, rowStart: 12),
    ];
  }
}

/// Label info for button display
class _LabelInfo {
  final String displayLabel;
  final IconData? icon;

  _LabelInfo({required this.displayLabel, this.icon});
}

/// Control button widget for mode and word size toggles
class _ControlButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _ControlButton({
    this.label,
    this.icon,
    this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? context.theme.textPrimary.withValues(alpha: 0.1)
                : (_isHovered
                      ? context.theme.textPrimary.withValues(alpha: 0.05)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: context.theme.textPrimary, size: 18),
                  if (widget.label != null) const SizedBox(width: 6),
                ],
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: TextStyle(
                      color: context.theme.textPrimary,
                      fontSize: 14,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
