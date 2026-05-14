import 'package:flutter/material.dart';

import '../radix_types.dart';

/// 进制按钮
///
/// 由三部分组成：
/// - 竖线：选中时显示，未选中时占位隐藏。颜色为主题主色。
/// - 标签文本：HEX / DEC / OCT / BIN
/// - 值文本：当前进制下的数值
///
/// ```
/// ┌──┬──────────────────┐
/// │  │  HEX   FF        │
/// │  │  DEC   255       │
/// │  │  OCT   377       │
/// │▌ │  BIN   11111111  │  ← 选中时竖线显示
/// └──┴──────────────────┘
/// ```
class RadixButton extends StatelessWidget {
  final RadixType radix;
  final bool isSelected;
  final String value;
  final VoidCallback? onPressed;

  const RadixButton({
    super.key,
    required this.radix,
    this.isSelected = false,
    this.value = '0',
    this.onPressed,
  });

  String get _label => switch (radix) {
    RadixType.hex => 'HEX',
    RadixType.dec => 'DEC',
    RadixType.oct => 'OCT',
    RadixType.bin => 'BIN',
  };

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
        child: Row(
          children: [
            const SizedBox(width: 4),
            // 竖线（始终占位，选中时可见）
            Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            const SizedBox(width: 6),
            // 标签
            SizedBox(
              width: 32,
              child: Text(
                _label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 4),
            // 值
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
