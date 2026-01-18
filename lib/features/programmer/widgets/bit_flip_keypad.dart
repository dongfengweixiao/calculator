import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../extensions/extensions.dart';
import '../../programmer/programmer_provider.dart';

/// Bit flip keypad widget for programmer mode
///
/// Fixed 8 rows x 16 columns layout:
/// - Odd rows (1,3,5,7): Bit toggle buttons, from bit 63 to 0 (MSB to LSB)
/// - Even rows (2,4,6,8): Bit number labels (only show 60,56,52,48,44,40,36,32,28,24,20,16,12,8,4,0)
/// - Every 4 columns has a gap, every 2 rows has a gap
/// - Adapts to word size (QWORD/DWORD/WORD/BYTE) by disabling bits beyond word size
class BitFlipKeypad extends ConsumerWidget {
  const BitFlipKeypad({super.key});

  static const int columns = 16;
  static const int rows = 8;
  static const int gapEveryColumns = 4;
  static const int gapEveryRows = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmerState = ref.watch(programmerProvider);
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutGrid(
        // 16 button columns + 3 gap columns (after every 4 buttons)
        // Pattern: [btn][btn][btn][btn][gap][btn][btn][btn][btn][gap]...
        columnSizes: _buildColumnSizes(),
        // 8 rows with equal fraction sizing to allow shrinking
        rowSizes: List.generate(rows, (index) => 1.fr),

        // Default small gap for adjacent buttons
        columnGap: 4,
        rowGap: 8,

        children: _buildGridCells(programmerState, ref, theme),
      ),
    );
  }

  /// Build column sizes with gaps after every 4 buttons
  /// Pattern: 4 button columns, 1 gap column, 4 button columns, 1 gap column, etc.
  /// Total: 16 button columns + 3 gap columns = 19 columns
  List<TrackSize> _buildColumnSizes() {
    final columnSizes = <TrackSize>[];

    for (int i = 0; i < columns; i++) {
      // Add button column
      columnSizes.add(1.fr);

      // Add gap column after every 4 buttons (except after the last group)
      if ((i + 1) % 4 == 0 && i < columns - 1) {
        columnSizes.add(4.px); // Larger gap between groups
      }
    }

    return columnSizes;
  }

  /// Build all grid cells (bit buttons and bit number labels)
  List<Widget> _buildGridCells(
    ProgrammerState state,
    WidgetRef ref,
    CalculatorTheme theme,
  ) {
    final cells = <Widget>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        // Convert button column to grid column (accounting for gap columns)
        final gridCol = _buttonColToGridCol(col);

        if (row % 2 == 0) {
          // Odd rows (0,2,4,6) - bit toggle buttons
          // Map row/col to bit number (63 down to 0)
          final bitNumber = _getBitNumberForPosition(row, col);
          if (bitNumber >= 0) {
            final arrayIndex = 63 - bitNumber;
            final isSet = state.bitValues[arrayIndex];

            cells.add(
              _BitButton(
                bitNumber: bitNumber,
                isSet: isSet,
                wordSize: state.wordSize,
                onTap: () =>
                    ref.read(programmerProvider.notifier).toggleBit(bitNumber),
              ).withGridPlacement(columnStart: gridCol, rowStart: row),
            );
          }
        } else {
          // Even rows (1,3,5,7) - bit number labels
          // The label should be displayed at the same column as its corresponding bit button above
          final bitRow = (row - 1) ~/ 2;
          final bitNumber = 63 - (bitRow * 16 + col);
          final label = _getBitLabelForBit(bitNumber);

          if (label.isNotEmpty) {
            cells.add(
              _BitLabel(
                label: label,
                theme: theme,
              ).withGridPlacement(columnStart: gridCol, rowStart: row),
            );
          }
        }
      }
    }

    return cells;
  }

  /// Convert button column index to grid column index
  /// Accounts for gap columns inserted after every 4 buttons
  /// Pattern: btn btn btn btn GAP btn btn btn btn GAP...
  int _buttonColToGridCol(int buttonCol) {
    // Each complete group of 4 buttons adds 1 gap column
    return buttonCol + (buttonCol ~/ 4);
  }

  /// Get bit number for a given row/column position (63 down to 0)
  int _getBitNumberForPosition(int row, int col) {
    final bitRow = row ~/ 2;
    return 63 - (bitRow * 16 + col);
  }

  /// Get bit number label for a specific bit
  /// Only show bit numbers that are multiples of 4: 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 8, 4, 0
  String _getBitLabelForBit(int bitNumber) {
    if (bitNumber % 4 == 0 && bitNumber >= 0 && bitNumber <= 63) {
      return bitNumber.toString();
    }
    return '';
  }
}

/// Bit number label widget
class _BitLabel extends StatelessWidget {
  final String label;
  final CalculatorTheme theme;

  const _BitLabel({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter, // Align to top so label stays close to button above
      child: Text(
        label,
        style: TextStyle(
          color: theme.textSecondary,
          fontSize: CalculatorFontSizes.numeric10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Individual bit toggle button
class _BitButton extends StatefulWidget {
  final int bitNumber;
  final bool isSet;
  final WordSize wordSize;
  final VoidCallback onTap;

  const _BitButton({
    required this.bitNumber,
    required this.isSet,
    required this.wordSize,
    required this.onTap,
  });

  @override
  State<_BitButton> createState() => _BitButtonState();
}

class _BitButtonState extends State<_BitButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Check if this bit is disabled based on word size
    final isDisabled = widget.bitNumber >= widget.wordSize.bits;

    // Determine background color based on state
    Color backgroundColor;
    Color foregroundColor;

    if (isDisabled) {
      backgroundColor = Colors.transparent;
      foregroundColor = theme.textSecondary.withValues(alpha: 0.3);
    } else if (_isPressed) {
      backgroundColor = theme.buttonSubtlePressed;
      foregroundColor = theme.textPrimary;
    } else if (_isHovered) {
      backgroundColor = theme.buttonSubtleHover;
      foregroundColor = theme.textPrimary;
    } else if (widget.isSet) {
      backgroundColor = Colors.transparent;
      foregroundColor = theme.accent;
    } else {
      backgroundColor = Colors.transparent;
      foregroundColor = theme.textPrimary;
    }

    return MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isDisabled
            ? null
            : (_) {
                setState(() => _isPressed = false);
                widget.onTap();
              },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              widget.isSet ? '1' : '0',
              style: TextStyle(
                color: foregroundColor,
                fontSize: CalculatorFontSizes.numeric14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
