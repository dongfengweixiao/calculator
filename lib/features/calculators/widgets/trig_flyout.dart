import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

import '../trig_types.dart';
import 'shared_buttons.dart';

/// 三角函数弹出面板
///
/// 使用 flutter_layout_grid 实现 2行×4列:
/// ```
///    Col 0      Col 1   Col 2   Col 3
///   ┌──────────┬───────┬───────┬───────┐
///   │  2nd     │  sin  │  cos  │  tan  │
///   ├──────────┼───────┼───────┼───────┤
///   │  Hyp     │  sec  │  csc  │  cot  │
///   └──────────┴───────┴───────┴───────┘
/// ```
class TrigFlyout extends StatefulWidget {
  final void Function(TrigFunction)? onTrigSelected;

  const TrigFlyout({super.key, this.onTrigSelected});

  @override
  State<TrigFlyout> createState() => _TrigFlyoutState();
}

class _TrigFlyoutState extends State<TrigFlyout> {
  bool _isShift = false;
  bool _isHyp = false;

  static const _baseLabels = {
    TrigBase.sin: 'sin',
    TrigBase.cos: 'cos',
    TrigBase.tan: 'tan',
    TrigBase.sec: 'sec',
    TrigBase.csc: 'csc',
    TrigBase.cot: 'cot',
  };

  static const _invLabels = {
    TrigBase.sin: 'sin-1',
    TrigBase.cos: 'cos-1',
    TrigBase.tan: 'tan-1',
    TrigBase.sec: 'sec-1',
    TrigBase.csc: 'csc-1',
    TrigBase.cot: 'cot-1',
  };

  static const _hypLabels = {
    TrigBase.sin: 'sinh',
    TrigBase.cos: 'cosh',
    TrigBase.tan: 'tanh',
    TrigBase.sec: 'sech',
    TrigBase.csc: 'csch',
    TrigBase.cot: 'coth',
  };

  static const _invHypLabels = {
    TrigBase.sin: 'sinh-1',
    TrigBase.cos: 'cosh-1',
    TrigBase.tan: 'tanh-1',
    TrigBase.sec: 'sech-1',
    TrigBase.csc: 'csch-1',
    TrigBase.cot: 'coth-1',
  };

  String _getLabel(TrigBase base) {
    if (_isShift && _isHyp) return _invHypLabels[base]!;
    if (_isShift) return _invLabels[base]!;
    if (_isHyp) return _hypLabels[base]!;
    return _baseLabels[base]!;
  }

  TrigFunction _getFunction(TrigBase base) {
    if (_isShift && _isHyp) {
      return switch (base) {
        TrigBase.sin => TrigFunction.invSinh,
        TrigBase.cos => TrigFunction.invCosh,
        TrigBase.tan => TrigFunction.invTanh,
        TrigBase.sec => TrigFunction.invSech,
        TrigBase.csc => TrigFunction.invCsch,
        TrigBase.cot => TrigFunction.invCoth,
      };
    } else if (_isShift) {
      return switch (base) {
        TrigBase.sin => TrigFunction.invSin,
        TrigBase.cos => TrigFunction.invCos,
        TrigBase.tan => TrigFunction.invTan,
        TrigBase.sec => TrigFunction.invSec,
        TrigBase.csc => TrigFunction.invCsc,
        TrigBase.cot => TrigFunction.invCot,
      };
    } else if (_isHyp) {
      return switch (base) {
        TrigBase.sin => TrigFunction.sinh,
        TrigBase.cos => TrigFunction.cosh,
        TrigBase.tan => TrigFunction.tanh,
        TrigBase.sec => TrigFunction.sech,
        TrigBase.csc => TrigFunction.csch,
        TrigBase.cot => TrigFunction.coth,
      };
    } else {
      return switch (base) {
        TrigBase.sin => TrigFunction.sin,
        TrigBase.cos => TrigFunction.cos,
        TrigBase.tan => TrigFunction.tan,
        TrigBase.sec => TrigFunction.sec,
        TrigBase.csc => TrigFunction.csc,
        TrigBase.cot => TrigFunction.cot,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 258,
      height: 96,
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
        rowSizes: [1.fr, 1.fr],
        columnGap: 4,
        rowGap: 4,
        children: [
          // Row 0
          TrigShiftButton(
            isSelected: _isShift,
            onPressed: () => setState(() => _isShift = !_isShift),
          ).withGridPlacement(columnStart: 0, rowStart: 0),
          SinButton(
            label: _getLabel(TrigBase.sin),
            onPressed: () =>
                widget.onTrigSelected?.call(_getFunction(TrigBase.sin)),
          ).withGridPlacement(columnStart: 1, rowStart: 0),
          CosButton(
            label: _getLabel(TrigBase.cos),
            onPressed: () =>
                widget.onTrigSelected?.call(_getFunction(TrigBase.cos)),
          ).withGridPlacement(columnStart: 2, rowStart: 0),
          TanButton(
            label: _getLabel(TrigBase.tan),
            onPressed: () =>
                widget.onTrigSelected?.call(_getFunction(TrigBase.tan)),
          ).withGridPlacement(columnStart: 3, rowStart: 0),
          // Row 1
          HypButton(
            isSelected: _isHyp,
            onPressed: () => setState(() => _isHyp = !_isHyp),
          ).withGridPlacement(columnStart: 0, rowStart: 1),
          SecButton(
            label: _getLabel(TrigBase.sec),
            onPressed: () =>
                widget.onTrigSelected?.call(_getFunction(TrigBase.sec)),
          ).withGridPlacement(columnStart: 1, rowStart: 1),
          CscButton(
            label: _getLabel(TrigBase.csc),
            onPressed: () =>
                widget.onTrigSelected?.call(_getFunction(TrigBase.csc)),
          ).withGridPlacement(columnStart: 2, rowStart: 1),
          CotButton(
            label: _getLabel(TrigBase.cot),
            onPressed: () =>
                widget.onTrigSelected?.call(_getFunction(TrigBase.cot)),
          ).withGridPlacement(columnStart: 3, rowStart: 1),
        ],
      ),
    );
  }
}

/// TrigShift (2nd) 可切换按钮
class TrigShiftButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;

  const TrigShiftButton({super.key, this.isSelected = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceVariant,
          foregroundColor: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
        child: Text('2nd', style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Hyp 可切换按钮
class HypButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;

  const HypButton({super.key, this.isSelected = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceVariant,
          foregroundColor: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
        child: Text('Hyp', style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Sin 按钮族
class SinButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SinButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: EasyRichText(
        label,
        patternList: [
          EasyRichTextPattern(
            targetString: '-1',
            superScript: true,
            matchWordBoundaries: false,
          ),
        ],
        defaultStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

/// Cos 按钮族
class CosButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CosButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: EasyRichText(
        label,
        patternList: [
          EasyRichTextPattern(
            targetString: '-1',
            superScript: true,
            matchWordBoundaries: false,
          ),
        ],
        defaultStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

/// Tan 按钮族
class TanButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const TanButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: EasyRichText(
        label,
        patternList: [
          EasyRichTextPattern(
            targetString: '-1',
            superScript: true,
            matchWordBoundaries: false,
          ),
        ],
        defaultStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

/// Sec 按钮族
class SecButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SecButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: EasyRichText(
        label,
        patternList: [
          EasyRichTextPattern(
            targetString: '-1',
            superScript: true,
            matchWordBoundaries: false,
          ),
        ],
        defaultStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

/// Csc 按钮族
class CscButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CscButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: EasyRichText(
        label,
        patternList: [
          EasyRichTextPattern(
            targetString: '-1',
            superScript: true,
            matchWordBoundaries: false,
          ),
        ],
        defaultStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

/// Cot 按钮族
class CotButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CotButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: EasyRichText(
        label,
        patternList: [
          EasyRichTextPattern(
            targetString: '-1',
            superScript: true,
            matchWordBoundaries: false,
          ),
        ],
        defaultStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}
