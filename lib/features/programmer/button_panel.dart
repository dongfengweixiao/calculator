import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'programmer_provider.dart';
import '../../shared/theme/theme_provider.dart';
import 'button_layout.dart';

/// Programmer calculator button panel container
/// Switches between full keypad and bit flip modes
class ProgrammerButtonPanel extends ConsumerWidget {
  const ProgrammerButtonPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final programmerState = ref.watch(programmerProvider);

    return Container(
      color: theme.background,
      child: programmerState.inputMode == ProgrammerInputMode.fullKeypad
          ? const ProgrammerButtonLayout()
          : const _BitFlipModePanel(),
    );
  }
}

/// Bit flip mode panel (64-bit interactive display)
class _BitFlipModePanel extends ConsumerWidget {
  const _BitFlipModePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final programmerState = ref.watch(programmerProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(4, (groupIndex) {
          // Each group has a button row and a label row
          return Column(
            children: [
              // Button row (16 bits)
              _BitButtonRow(
                groupIndex: groupIndex,
                programmerState: programmerState,
                theme: theme,
                ref: ref,
              ),
              // Label row (bit numbers at positions 4, 8, 12, 16)
              _BitLabelRow(
                groupIndex: groupIndex,
                programmerState: programmerState,
                theme: theme,
              ),
              // Add spacing between groups
              if (groupIndex < 3) const SizedBox(height: 4),
            ],
          );
        }),
      ),
    );
  }
}

/// Bit button row (16 bits per row)
class _BitButtonRow extends StatelessWidget {
  final int groupIndex;
  final ProgrammerState programmerState;
  final dynamic theme;
  final WidgetRef ref;

  const _BitButtonRow({
    required this.groupIndex,
    required this.programmerState,
    required this.theme,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(16, (colIndex) {
        // arrayIndex: position in bitValues array (0-63)
        // bitNumber: actual bit position (63-0, where 0 is LSB)
        final arrayIndex = groupIndex * 16 + colIndex;
        final bitNumber = 63 - arrayIndex;
        final isEnabled = bitNumber < programmerState.wordSize.bits;
        final bitValue = programmerState.bitValues[arrayIndex];

        // Add spacing after every 4 bits
        final showSpacing = (colIndex + 1) % 4 == 0 && colIndex != 15;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 2.0,
              right: showSpacing ? 8.0 : 2.0,
            ),
            child: SizedBox(
              height: 40,
              child: MouseRegion(
                cursor: isEnabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.forbidden,
                child: GestureDetector(
                  onTap: isEnabled
                      ? () => ref.read(programmerProvider.notifier).toggleBit(bitNumber)
                      : null,
                  child: Center(
                    child: Text(
                      bitValue ? '1' : '0',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: bitValue
                            ? theme.accent
                            : (isEnabled
                                ? theme.textPrimary
                                : theme.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Bit label row (showing bit numbers at positions 4, 8, 12, 16)
class _BitLabelRow extends StatelessWidget {
  final int groupIndex;
  final ProgrammerState programmerState;
  final dynamic theme;

  const _BitLabelRow({
    required this.groupIndex,
    required this.programmerState,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(16, (colIndex) {
        // Show label at positions 4, 8, 12, 16 (indices 3, 7, 11, 15)
        final showLabel = (colIndex + 1) % 4 == 0;
        final arrayIndex = groupIndex * 16 + colIndex;
        final bitNumber = 63 - arrayIndex;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              height: 16,
              child: showLabel
                  ? Center(
                      child: Text(
                        '$bitNumber',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.textSecondary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
      }),
    );
  }
}
