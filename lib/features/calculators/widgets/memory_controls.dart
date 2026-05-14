import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';

/// 内存控件按钮行
///
/// 使用 flutter_layout_grid 实现 1行×6列:
/// ```
///    Col 0     Col 1     Col 2     Col 3     Col 4     Col 5
///   ┌────────┬────────┬────────┬────────┬────────┬────────┐
///   │   MC   │   MR   │   M+   │   M-   │   MS   │   M▾   │
///   └────────┴────────┴────────┴────────┴────────┴────────┘
/// ```
class MemoryControls extends StatelessWidget {
  final VoidCallback? onMemoryClear;
  final VoidCallback? onMemoryRecall;
  final VoidCallback? onMemoryAdd;
  final VoidCallback? onMemorySubtract;
  final VoidCallback? onMemoryStore;
  final VoidCallback? onMemory;

  const MemoryControls({
    super.key,
    this.onMemoryClear,
    this.onMemoryRecall,
    this.onMemoryAdd,
    this.onMemorySubtract,
    this.onMemoryStore,
    this.onMemory,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr],
      columnGap: 4,
      rowGap: 0,
      children: [
        ClearMemoryButton(
          onPressed: onMemoryClear,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        MemRecallButton(
          onPressed: onMemoryRecall,
        ).withGridPlacement(columnStart: 1, rowStart: 0),
        MemPlusButton(
          onPressed: onMemoryAdd,
        ).withGridPlacement(columnStart: 2, rowStart: 0),
        MemMinusButton(
          onPressed: onMemorySubtract,
        ).withGridPlacement(columnStart: 3, rowStart: 0),
        MemButton(
          onPressed: onMemoryStore,
        ).withGridPlacement(columnStart: 4, rowStart: 0),
        MemoryButton(
          onPressed: onMemory,
        ).withGridPlacement(columnStart: 5, rowStart: 0),
      ],
    );
  }
}

/// MC 清除内存按钮
class ClearMemoryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ClearMemoryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(
          CalculatorIcons.memoryClear,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// MR 内存召回按钮
class MemRecallButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemRecallButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(
          CalculatorIcons.memoryRecall,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// M+ 内存加按钮
class MemPlusButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemPlusButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(
          CalculatorIcons.memoryAdd,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// M- 内存减按钮
class MemMinusButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemMinusButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(
          CalculatorIcons.memorySubtract,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// MS 内存存储按钮
class MemButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(
          CalculatorIcons.memoryStore,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// M▾ 内存面板按钮
class MemoryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemoryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(
          CalculatorIcons.showMemoryPanel,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
