import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';
import 'bitwise_flyout.dart';
import 'bit_shift_flyout.dart';

/// 程序员操作面板行组件
///
/// 使用 Row 布局，包含位运算和位移两个按钮，
/// Bitwise 按钮使用弹出面板（Flyout）模式。
/// ```
/// ┌──────────────────────────────────────────┐
/// │  [Bitwise ▾]                  [BitShift]  │
/// └──────────────────────────────────────────┘
/// ```
class ProgrammerOperatorPanelRow extends StatelessWidget {
  final VoidCallback? onAnd;
  final VoidCallback? onOr;
  final VoidCallback? onNot;
  final VoidCallback? onNand;
  final VoidCallback? onNor;
  final VoidCallback? onXor;
  final VoidCallback? onArithmeticShift;
  final VoidCallback? onLogicalShift;
  final VoidCallback? onRotateCircular;
  final VoidCallback? onRotateCarryShift;
  final ShiftType selectedShiftType;

  const ProgrammerOperatorPanelRow({
    super.key,
    this.onAnd,
    this.onOr,
    this.onNot,
    this.onNand,
    this.onNor,
    this.onXor,
    this.onArithmeticShift,
    this.onLogicalShift,
    this.onRotateCircular,
    this.onRotateCarryShift,
    this.selectedShiftType = ShiftType.rotate,
  });

  void _showBitwiseFlyout(BuildContext context) {
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
      builder: (context) => _BitwiseFlyoutMenu(
        position: position,
        buttonSize: button.size,
        onAnd: onAnd,
        onOr: onOr,
        onNot: onNot,
        onNand: onNand,
        onNor: onNor,
        onXor: onXor,
      ),
    );
  }

  void _showBitShiftFlyout(BuildContext context) {
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
      builder: (context) => _BitShiftFlyoutMenu(
        position: position,
        buttonSize: button.size,
        onArithmeticShift: onArithmeticShift,
        onLogicalShift: onLogicalShift,
        onRotateCircular: onRotateCircular,
        onRotateCarryShift: onRotateCarryShift,
        selectedShiftType: selectedShiftType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _showBitwiseFlyout(context),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Row(
                children: [
                  Icon(CalculatorIcons.bitwiseButton, size: 16),
                  SizedBox(width: 8),
                  Text('Bitwise'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showBitShiftFlyout(context),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Row(
                children: [
                  Icon(CalculatorIcons.shiftButton, size: 16),
                  SizedBox(width: 8),
                  Text('Bit Shift'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 位运算弹出面板（内部使用）
class _BitwiseFlyoutMenu extends StatelessWidget {
  final Offset position;
  final Size buttonSize;

  final VoidCallback? onAnd;
  final VoidCallback? onOr;
  final VoidCallback? onNot;
  final VoidCallback? onNand;
  final VoidCallback? onNor;
  final VoidCallback? onXor;

  const _BitwiseFlyoutMenu({
    required this.position,
    required this.buttonSize,
    this.onAnd,
    this.onOr,
    this.onNot,
    this.onNand,
    this.onNor,
    this.onXor,
  });

  @override
  Widget build(BuildContext context) {
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
            borderRadius: BorderRadius.circular(8),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: BitwiseFlyout(
                onAnd: () {
                  Navigator.pop(context);
                  onAnd?.call();
                },
                onOr: () {
                  Navigator.pop(context);
                  onOr?.call();
                },
                onNot: () {
                  Navigator.pop(context);
                  onNot?.call();
                },
                onNand: () {
                  Navigator.pop(context);
                  onNand?.call();
                },
                onNor: () {
                  Navigator.pop(context);
                  onNor?.call();
                },
                onXor: () {
                  Navigator.pop(context);
                  onXor?.call();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 位移弹出面板（内部使用）
class _BitShiftFlyoutMenu extends StatelessWidget {
  final Offset position;
  final Size buttonSize;
  final VoidCallback? onArithmeticShift;
  final VoidCallback? onLogicalShift;
  final VoidCallback? onRotateCircular;
  final VoidCallback? onRotateCarryShift;
  final ShiftType selectedShiftType;

  const _BitShiftFlyoutMenu({
    required this.position,
    required this.buttonSize,
    this.onArithmeticShift,
    this.onLogicalShift,
    this.onRotateCircular,
    this.onRotateCarryShift,
    this.selectedShiftType = ShiftType.rotate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          right: position.dx,
          top: position.dy + buttonSize.height + 4,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 256, // 设置固定宽度
              child: BitShiftFlyout(
                onArithmeticShift: () {
                  Navigator.pop(context);
                  onArithmeticShift?.call();
                },
                onLogicalShift: () {
                  Navigator.pop(context);
                  onLogicalShift?.call();
                },
                onRotateCircular: () {
                  Navigator.pop(context);
                  onRotateCircular?.call();
                },
                onRotateCarryShift: () {
                  Navigator.pop(context);
                  onRotateCarryShift?.call();
                },
                initialSelectedType: selectedShiftType,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
