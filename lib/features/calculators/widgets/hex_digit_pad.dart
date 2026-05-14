import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

/// 十六进制数字键盘 (A-F)
///
/// 使用 flutter_layout_grid 实现 6行×1列:
/// ```
///   ┌─────────┐
///   │    A     │
///   ├─────────┤
///   │    B     │
///   ├─────────┤
///   │    C     │
///   ├─────────┤
///   │    D     │
///   ├─────────┤
///   │    E     │
///   ├─────────┤
///   │    F     │
///   └─────────┘
/// ```
class HexDigitPad extends StatelessWidget {
  final void Function(String hex)? onHex;
  final bool isEnabled;

  const HexDigitPad({super.key, this.onHex, this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowGap: 4,
      children: [
        HexButton(
          label: 'A',
          onPressed: isEnabled ? () => onHex?.call('A') : null,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        HexButton(
          label: 'B',
          onPressed: isEnabled ? () => onHex?.call('B') : null,
        ).withGridPlacement(columnStart: 0, rowStart: 1),
        HexButton(
          label: 'C',
          onPressed: isEnabled ? () => onHex?.call('C') : null,
        ).withGridPlacement(columnStart: 0, rowStart: 2),
        HexButton(
          label: 'D',
          onPressed: isEnabled ? () => onHex?.call('D') : null,
        ).withGridPlacement(columnStart: 0, rowStart: 3),
        HexButton(
          label: 'E',
          onPressed: isEnabled ? () => onHex?.call('E') : null,
        ).withGridPlacement(columnStart: 0, rowStart: 4),
        HexButton(
          label: 'F',
          onPressed: isEnabled ? () => onHex?.call('F') : null,
        ).withGridPlacement(columnStart: 0, rowStart: 5),
      ],
    );
  }
}

/// 十六进制数字按钮
class HexButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const HexButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
