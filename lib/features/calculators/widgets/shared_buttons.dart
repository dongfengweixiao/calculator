import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

/// 共享按钮组件
///
/// 包含在多个计算器页面中重复使用的按钮组件

/// 百分比按钮
class PercentButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PercentButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.percent, size: 20),
      ),
    );
  }
}

/// 左括号按钮
class OpenParenthesisButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final int count;

  const OpenParenthesisButton({super.key, this.onPressed, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: count == 0
            ? const Text('(', style: TextStyle(fontSize: 18))
            : EasyRichText(
                '($count',
                defaultStyle: const TextStyle(fontSize: 18),
                patternList: [
                  EasyRichTextPattern(targetString: '$count', subScript: true),
                ],
              ),
      ),
    );
  }
}

/// 右括号按钮
class CloseParenthesisButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CloseParenthesisButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text(')', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

/// 位翻转按钮
class BitFlipButton extends StatelessWidget {
  final int bitNumber;
  final bool isChecked;
  final bool isEnabled;
  final bool isSelected;
  final VoidCallback? onPressed;

  const BitFlipButton({
    super.key,
    required this.bitNumber,
    this.isChecked = false,
    this.isEnabled = true,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          minimumSize: Size.zero,
          alignment: Alignment.center,
        ),
        child: Text(
          isChecked ? '1' : '0',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isChecked
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withAlpha(isEnabled ? 255 : 96),
          ),
        ),
      ),
    );
  }
}

/// 倒数按钮 (1/x)
class InvertButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const InvertButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.reciprocal, size: 20),
      ),
    );
  }
}

/// 平方按钮 (x²)
class XPower2Button extends StatelessWidget {
  final VoidCallback? onPressed;

  const XPower2Button({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.square, size: 20),
      ),
    );
  }
}

/// 平方根按钮 (√x)
class SquareRootButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SquareRootButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.squareRoot, size: 20),
      ),
    );
  }
}

/// 全键盘按钮
class FullKeypadButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;

  const FullKeypadButton({super.key, required this.isSelected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          minimumSize: Size.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CalculatorIcons.fullKeypad,
              size: 20,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            Container(
              height: 3,
              width: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 内存存储按钮
class MemStoreButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemStoreButton({super.key, this.onPressed});

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

/// 内存面板按钮
class MemoryPanelButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MemoryPanelButton({super.key, this.onPressed});

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

/// 位翻转模式按钮
///
/// 用于切换到位翻转模式的按钮
class BitFlipModeButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;

  const BitFlipModeButton({
    super.key,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          minimumSize: Size.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CalculatorIcons.bitFlip,
              size: 20,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            Container(
              height: 3,
              width: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
