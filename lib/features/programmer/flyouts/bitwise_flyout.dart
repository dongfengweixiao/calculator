import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../programmer_provider.dart';
import '../../calculator/calculator_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../scientific/flyouts/menu_buttons.dart';

/// Bitwise operations flyout button
/// Displays a button that opens a menu with bitwise operations when clicked
class BitwiseFlyoutButton extends StatefulWidget {
  final ProgrammerNotifier programmer;
  final CalculatorTheme theme;

  const BitwiseFlyoutButton({
    super.key,
    required this.programmer,
    required this.theme,
  });

  @override
  State<BitwiseFlyoutButton> createState() => _BitwiseFlyoutButtonState();
}

class _BitwiseFlyoutButtonState extends State<BitwiseFlyoutButton> {
  bool _isHovered = false;

  void _showBitwiseMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => BitwiseFlyoutMenu(
        programmer: widget.programmer,
        theme: widget.theme,
        position: position,
        buttonSize: button.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered
        ? widget.theme.buttonSubtleHover
        : widget.theme.buttonSubtleDefault;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showBitwiseMenu(context),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                String.fromCharCode(CalculatorIcons.bitwiseButton.codePoint),
                style: TextStyle(
                  fontFamily: CalculatorIcons.bitwiseButton.fontFamily,
                  fontSize: 14,
                  color: widget.theme.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '按位',
                style: TextStyle(
                  color: widget.theme.textPrimary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_drop_down,
                color: widget.theme.textPrimary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bitwise operations flyout menu
/// Displays a grid of bitwise operation buttons
class BitwiseFlyoutMenu extends ConsumerWidget {
  final ProgrammerNotifier programmer;
  final CalculatorTheme theme;
  final Offset position;
  final Size buttonSize;

  const BitwiseFlyoutMenu({
    super.key,
    required this.programmer,
    required this.theme,
    required this.position,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy + buttonSize.height + 4,
          child: Material(
            color: theme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 240,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row 1: AND, OR, NOT
                  Row(
                    children: [
                      FlyoutTextButton(
                        text: 'AND',
                        theme: theme,
                        onPressed: () {
                          calculator.bitwiseAnd();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutTextButton(
                        text: 'OR',
                        theme: theme,
                        onPressed: () {
                          calculator.bitwiseOr();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutTextButton(
                        text: 'NOT',
                        theme: theme,
                        onPressed: () {
                          calculator.bitwiseNot();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Row 2: NAND, NOR, XOR
                  Row(
                    children: [
                      FlyoutTextButton(
                        text: 'NAND',
                        theme: theme,
                        onPressed: () {
                          calculator.bitwiseNand();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutTextButton(
                        text: 'NOR',
                        theme: theme,
                        onPressed: () {
                          calculator.bitwiseNor();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutTextButton(
                        text: 'XOR',
                        theme: theme,
                        onPressed: () {
                          calculator.bitwiseXor();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
