import 'package:flutter/material.dart';
import '../../core/theme/app_font_sizes.dart';
import 'programmer_provider.dart';
import 'binary_formatter.dart';

/// Base conversion panel widget showing HEX/DEC/OCT/BIN values
class BaseConversionPanel extends StatelessWidget {
  final dynamic theme;
  final ProgrammerState programmerState;
  final Function(ProgrammerBase) onBaseSelected;

  const BaseConversionPanel({
    super.key,
    required this.theme,
    required this.programmerState,
    required this.onBaseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: theme.background,
      child: Column(
        children: [
          _BaseButton(
            label: 'HEX',
            value: programmerState.hexValue,
            isSelected: programmerState.currentBase == ProgrammerBase.hex,
            theme: theme,
            onTap: () => onBaseSelected(ProgrammerBase.hex),
          ),
          _BaseButton(
            label: 'DEC',
            value: programmerState.decValue,
            isSelected: programmerState.currentBase == ProgrammerBase.dec,
            theme: theme,
            onTap: () => onBaseSelected(ProgrammerBase.dec),
          ),
          _BaseButton(
            label: 'OCT',
            value: programmerState.octValue,
            isSelected: programmerState.currentBase == ProgrammerBase.oct,
            theme: theme,
            onTap: () => onBaseSelected(ProgrammerBase.oct),
          ),
          _BaseButton(
            label: 'BIN',
            value: BinaryFormatter.format(programmerState.binValue),
            isSelected: programmerState.currentBase == ProgrammerBase.bin,
            theme: theme,
            onTap: () => onBaseSelected(ProgrammerBase.bin),
          ),
        ],
      ),
    );
  }
}

/// Base button widget
class _BaseButton extends StatefulWidget {
  final String label;
  final String value;
  final bool isSelected;
  final dynamic theme;
  final VoidCallback onTap;

  const _BaseButton({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<_BaseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.theme.textPrimary.withValues(alpha: 0.12)
                : (_isHovered
                    ? widget.theme.textPrimary.withValues(alpha: 0.05)
                    : Colors.transparent),
          ),
          child: Row(
            children: [
              // Base label
              SizedBox(
                width: 48,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: CalculatorFontSizes.numeric16,
                    fontWeight: FontWeight.w600,
                    color: widget.isSelected
                        ? widget.theme.textPrimary
                        : widget.theme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Value display
              Expanded(
                child: Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: CalculatorFontSizes.numeric16,
                    color: widget.theme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
