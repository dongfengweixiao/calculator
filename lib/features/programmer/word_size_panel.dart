import 'package:flutter/material.dart';
import '../../core/theme/app_font_sizes.dart';
import '../../core/theme/app_icons.dart';
import 'programmer_provider.dart';

/// Word size and input mode panel widget
class WordSizeAndModePanel extends StatelessWidget {
  final dynamic theme;
  final ProgrammerState programmerState;
  final VoidCallback onModeToggle;
  final VoidCallback onWordSizeCycle;

  const WordSizeAndModePanel({
    super.key,
    required this.theme,
    required this.programmerState,
    required this.onModeToggle,
    required this.onWordSizeCycle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.divider, width: 1),
          bottom: BorderSide(color: theme.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Full keypad button with icon
          _ControlButton(
            label: null,
            icon: CalculatorIcons.fullKeypad,
            tooltip: '全键盘',
            isSelected: programmerState.inputMode == ProgrammerInputMode.fullKeypad,
            theme: theme,
            onTap: onModeToggle,
          ),

          const SizedBox(width: 8),

          // Bit flip button with icon
          _ControlButton(
            label: null,
            icon: CalculatorIcons.bitFlip,
            tooltip: '位翻转',
            isSelected: programmerState.inputMode == ProgrammerInputMode.bitFlip,
            theme: theme,
            onTap: onModeToggle,
          ),

          const Spacer(),

          // Word size button
          _ControlButton(
            label: programmerState.wordSize.label,
            icon: null,
            isSelected: false,
            theme: theme,
            onTap: onWordSizeCycle,
          ),

          const SizedBox(width: 8),

          // MS button
          _ControlButton(
            label: 'MS',
            icon: null,
            isSelected: false,
            theme: theme,
            onTap: () {
              // TODO: Implement MS functionality
            },
          ),
        ],
      ),
    );
  }
}

/// Control button widget
class _ControlButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final bool isSelected;
  final dynamic theme;
  final VoidCallback onTap;

  const _ControlButton({
    this.label,
    this.icon,
    this.tooltip,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final buttonContent = MouseRegion(
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
            borderRadius: BorderRadius.circular(4),
          ),
          child: widget.icon != null
              ? Text(
                  String.fromCharCode(widget.icon!.codePoint),
                  style: TextStyle(
                    fontFamily: widget.icon!.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.isSelected
                        ? widget.theme.textPrimary
                        : widget.theme.textSecondary,
                  ),
                )
              : Text(
                  widget.label ?? '',
                  style: TextStyle(
                    fontSize: CalculatorFontSizes.numeric16,
                    fontWeight: FontWeight.w500,
                    color: widget.isSelected
                        ? widget.theme.textPrimary
                        : widget.theme.textSecondary,
                  ),
                ),
        ),
      ),
    );

    // Wrap with Tooltip if tooltip is provided
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}
