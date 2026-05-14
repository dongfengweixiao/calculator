import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

/// 位运算弹出面板
///
/// 使用 flutter_layout_grid 实现 2行×3列:
/// ```
///    Col 0      Col 1      Col 2
///   ┌─────────┬─────────┬─────────┐
///   │   And   │   Or    │   Not   │
///   ├─────────┼─────────┼─────────┤
///   │  Nand   │  Nor    │   Xor   │
///   └─────────┴─────────┴─────────┘
/// ```
class BitwiseFlyout extends StatelessWidget {
  final VoidCallback? onAnd;
  final VoidCallback? onOr;
  final VoidCallback? onNot;
  final VoidCallback? onNand;
  final VoidCallback? onNor;
  final VoidCallback? onXor;

  const BitwiseFlyout({
    super.key,
    this.onAnd,
    this.onOr,
    this.onNot,
    this.onNand,
    this.onNor,
    this.onXor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 196,
      height: 96,
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr, 1.fr],
        rowSizes: [1.fr, 1.fr],
        columnGap: 4,
        rowGap: 4,
        children: [
          AndButton(
            onPressed: onAnd,
          ).withGridPlacement(columnStart: 0, rowStart: 0),
          OrButton(
            onPressed: onOr,
          ).withGridPlacement(columnStart: 1, rowStart: 0),
          NotButton(
            onPressed: onNot,
          ).withGridPlacement(columnStart: 2, rowStart: 0),
          NandButton(
            onPressed: onNand,
          ).withGridPlacement(columnStart: 0, rowStart: 1),
          NorButton(
            onPressed: onNor,
          ).withGridPlacement(columnStart: 1, rowStart: 1),
          XorButton(
            onPressed: onXor,
          ).withGridPlacement(columnStart: 2, rowStart: 1),
        ],
      ),
    );
  }
}

/// And 按钮族
class AndButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AndButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('AND', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Or 按钮族
class OrButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const OrButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('OR', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Not 按钮族
class NotButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NotButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('NOT', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Nand 按钮族
class NandButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NandButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('NAND', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Nor 按钮族
class NorButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NorButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('NOR', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Xor 按钮族
class XorButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const XorButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('XOR', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
