import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_theme.dart';

/// Programmer calculator text button with calculator styling
class ProgrammerTextButton extends StatefulWidget {
  final String label;
  final CalculatorTheme theme;
  final bool isDisabled;
  final VoidCallback onPressed;

  const ProgrammerTextButton({
    super.key,
    required this.label,
    required this.theme,
    required this.isDisabled,
    required this.onPressed,
  });

  @override
  State<ProgrammerTextButton> createState() => _ProgrammerTextButtonState();
}

class _ProgrammerTextButtonState extends State<ProgrammerTextButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonType get _buttonType {
    if (widget.label == '=') {
      return CalcButtonType.emphasized;
    } else if (['+', '-', '×', '÷', '%', '<<', '>>'].contains(widget.label)) {
      return CalcButtonType.operator;
    } else if (widget.label == 'C/CE' ||
        widget.label == 'DEL' ||
        widget.label == '±') {
      return CalcButtonType.operator;
    } else {
      return CalcButtonType.number;
    }
  }

  CalcButtonState get _buttonState {
    if (widget.isDisabled) return CalcButtonState.disabled;
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      _buttonType,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      _buttonType,
      _buttonState,
    );

    return MouseRegion(
      cursor: widget.isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: widget.isDisabled
          ? null
          : (_) => setState(() => _isHovered = true),
      onExit: widget.isDisabled
          ? null
          : (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: widget.isDisabled
            ? null
            : (_) => setState(() => _isPressed = true),
        onTapUp: widget.isDisabled
            ? null
            : (_) {
                setState(() => _isPressed = false);
                widget.onPressed();
              },
        onTapCancel: widget.isDisabled
            ? null
            : () => setState(() => _isPressed = false),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Programmer calculator icon button
class ProgrammerIconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const ProgrammerIconButton({
    super.key,
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<ProgrammerIconButton> createState() => _ProgrammerIconButtonState();
}

class _ProgrammerIconButtonState extends State<ProgrammerIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      CalcButtonType.operator,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      CalcButtonType.operator,
      _buttonState,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              String.fromCharCode(widget.icon.codePoint),
              style: TextStyle(
                fontFamily: widget.icon.fontFamily,
                fontSize: 16,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Programmer calculator button with dynamic label or icon
class ProgrammerButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final CalculatorTheme theme;
  final bool isDisabled;
  final VoidCallback onPressed;

  const ProgrammerButton({
    super.key,
    this.label,
    this.icon,
    required this.theme,
    required this.isDisabled,
    required this.onPressed,
  });

  @override
  State<ProgrammerButton> createState() => _ProgrammerButtonState();
}

class _ProgrammerButtonState extends State<ProgrammerButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonType get _buttonType {
    if (widget.icon != null) {
      if (widget.icon == CalculatorIcons.equals) {
        return CalcButtonType.emphasized;
      }
      return CalcButtonType.operator;
    }

    if (widget.label == '=') {
      return CalcButtonType.emphasized;
    } else if (widget.label != null &&
        ['+', '-', '×', '÷', '%', '<<', '>>', '(', ')', 'C', 'CE'].contains(widget.label)) {
      return CalcButtonType.operator;
    } else if (widget.icon == CalculatorIcons.backspace ||
        widget.icon == CalculatorIcons.plus ||
        widget.icon == CalculatorIcons.minus ||
        widget.icon == CalculatorIcons.multiply ||
        widget.icon == CalculatorIcons.divide ||
        widget.icon == CalculatorIcons.negate) {
      return CalcButtonType.operator;
    } else {
      return CalcButtonType.number;
    }
  }

  CalcButtonState get _buttonState {
    if (widget.isDisabled) return CalcButtonState.disabled;
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      _buttonType,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      _buttonType,
      _buttonState,
    );

    return MouseRegion(
      cursor: widget.isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: widget.isDisabled
          ? null
          : (_) => setState(() => _isHovered = true),
      onExit: widget.isDisabled
          ? null
          : (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: widget.isDisabled
            ? null
            : (_) => setState(() => _isPressed = true),
        onTapUp: widget.isDisabled
            ? null
            : (_) {
                setState(() => _isPressed = false);
                widget.onPressed();
              },
        onTapCancel: widget.isDisabled
            ? null
            : () => setState(() => _isPressed = false),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: widget.icon != null
                ? Text(
                    String.fromCharCode(widget.icon!.codePoint),
                    style: TextStyle(
                      fontFamily: widget.icon!.fontFamily,
                      fontSize: 16,
                      color: foregroundColor,
                    ),
                  )
                : Text(
                    widget.label ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: foregroundColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
