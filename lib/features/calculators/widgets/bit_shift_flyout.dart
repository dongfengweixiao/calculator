import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

/// 位移类型
enum ShiftType {
  arithmetic, // 算术移位
  logical, // 逻辑移位
  rotate, // 旋转循环移位
  rotateCarry, // 带进位旋转循环移位
}

/// 位移弹出面板
class BitShiftFlyout extends StatefulWidget {
  final VoidCallback? onArithmeticShift;
  final VoidCallback? onLogicalShift;
  final VoidCallback? onRotateCircular;
  final VoidCallback? onRotateCarryShift;
  final ShiftType initialSelectedType;

  const BitShiftFlyout({
    super.key,
    this.onArithmeticShift,
    this.onLogicalShift,
    this.onRotateCircular,
    this.onRotateCarryShift,
    this.initialSelectedType = ShiftType.arithmetic,
  });

  @override
  State<BitShiftFlyout> createState() => _BitShiftFlyoutState();
}

class _BitShiftFlyoutState extends State<BitShiftFlyout> {
  late ShiftType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialSelectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<ShiftType>(
          title: const Text('算术移位'),
          value: ShiftType.arithmetic,
          groupValue: _selectedType,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedType = value);
              widget.onArithmeticShift?.call();
            }
          },
        ),
        RadioListTile<ShiftType>(
          title: const Text('逻辑移位'),
          value: ShiftType.logical,
          groupValue: _selectedType,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedType = value);
              widget.onLogicalShift?.call();
            }
          },
        ),
        RadioListTile<ShiftType>(
          title: const Text('旋转循环移位'),
          value: ShiftType.rotate,
          groupValue: _selectedType,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedType = value);
              widget.onRotateCircular?.call();
            }
          },
        ),
        RadioListTile<ShiftType>(
          title: const Text('带进位旋转循环移位'),
          value: ShiftType.rotateCarry,
          groupValue: _selectedType,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedType = value);
              widget.onRotateCarryShift?.call();
            }
          },
        ),
      ],
    );
  }
}

/// Lsh 左移按钮
class LshButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LshButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: Icon(CalculatorIcons.rol, size: 20),
      ),
    );
  }
}

/// Rsh 右移按钮
class RshButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RshButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: Icon(CalculatorIcons.ror, size: 20),
      ),
    );
  }
}

/// LshLogical 逻辑左移按钮
class LshLogicalButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LshLogicalButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(CalculatorIcons.rol, size: 20),
      ),
    );
  }
}

/// RshLogical 逻辑右移按钮
class RshLogicalButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RshLogicalButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(CalculatorIcons.ror, size: 20),
      ),
    );
  }
}

/// RolCarry 带进位旋转左移按钮
class RolCarryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RolCarryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(CalculatorIcons.rol, size: 20),
      ),
    );
  }
}

/// RorCarry 带进位旋转右移按钮
class RorCarryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RorCarryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(CalculatorIcons.ror, size: 20),
      ),
    );
  }
}
