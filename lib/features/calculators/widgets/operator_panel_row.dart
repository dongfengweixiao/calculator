import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';
import '../trig_types.dart';
import 'func_flyout.dart';
import 'trig_flyout.dart';

/// 操作面板行组件
///
/// 使用 Row 布局，包含三角学和函数两个按钮，
/// 均使用弹出面板（Flyout）模式。
/// ```
/// ┌──────────────────────────────────────────┐
/// │  [Trig ▾]                     [Func ▾]   │
/// └──────────────────────────────────────────┘
/// ```
class OperatorPanelRow extends StatelessWidget {
  final void Function(TrigFunction)? onTrigFunctionSelected;
  final VoidCallback? onAbs;
  final VoidCallback? onFloor;
  final VoidCallback? onCeil;
  final VoidCallback? onRand;
  final VoidCallback? onDms;
  final VoidCallback? onDegrees;

  const OperatorPanelRow({
    super.key,
    this.onTrigFunctionSelected,
    this.onAbs,
    this.onFloor,
    this.onCeil,
    this.onRand,
    this.onDms,
    this.onDegrees,
  });

  void _showTrigFlyout(BuildContext context) {
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
      builder: (context) => _TrigFlyoutMenu(
        position: position,
        buttonSize: button.size,
        onTrigFunctionSelected: onTrigFunctionSelected,
      ),
    );
  }

  void _showFuncFlyout(BuildContext context) {
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
      builder: (context) => _FuncFlyoutMenu(
        position: position,
        buttonSize: button.size,
        onAbs: onAbs,
        onFloor: onFloor,
        onCeil: onCeil,
        onRand: onRand,
        onDms: onDms,
        onDegrees: onDegrees,
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
            onTap: () => _showTrigFlyout(context),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(CalculatorIcons.trigButton, size: 16),
                  const SizedBox(width: 8),
                  const Text('Trigonometry'),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showFuncFlyout(context),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(CalculatorIcons.funcButton, size: 16),
                  const SizedBox(width: 8),
                  const Text('Function'),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 三角函数弹出面板（内部使用）
class _TrigFlyoutMenu extends StatelessWidget {
  final Offset position;
  final Size buttonSize;
  final void Function(TrigFunction)? onTrigFunctionSelected;

  const _TrigFlyoutMenu({
    required this.position,
    required this.buttonSize,
    this.onTrigFunctionSelected,
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
              child: TrigFlyout(
                onTrigSelected: (func) {
                  Navigator.pop(context);
                  onTrigFunctionSelected?.call(func);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 函数弹出面板（内部使用）
class _FuncFlyoutMenu extends StatelessWidget {
  final Offset position;
  final Size buttonSize;

  // FuncFlyout 回调
  final VoidCallback? onAbs;
  final VoidCallback? onFloor;
  final VoidCallback? onCeil;
  final VoidCallback? onRand;
  final VoidCallback? onDms;
  final VoidCallback? onDegrees;

  const _FuncFlyoutMenu({
    required this.position,
    required this.buttonSize,
    this.onAbs,
    this.onFloor,
    this.onCeil,
    this.onRand,
    this.onDms,
    this.onDegrees,
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
              child: FuncFlyout(
                onAbs: () {
                  Navigator.pop(context);
                  onAbs?.call();
                },
                onFloor: () {
                  Navigator.pop(context);
                  onFloor?.call();
                },
                onCeil: () {
                  Navigator.pop(context);
                  onCeil?.call();
                },
                onRand: () {
                  Navigator.pop(context);
                  onRand?.call();
                },
                onDms: () {
                  Navigator.pop(context);
                  onDms?.call();
                },
                onDegrees: () {
                  Navigator.pop(context);
                  onDegrees?.call();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
