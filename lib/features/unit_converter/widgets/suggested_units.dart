import 'package:flutter/material.dart';

/// 趣味换算建议展示组件
///
/// 分两行显示：第一行"约等于"，第二行水平滚动展示趣味换算结果。
/// value 加粗加黑，unit 与"约等于"使用较浅颜色。
class SuggestedUnits extends StatelessWidget {
  /// 建议列表，每项包含 value、unit、isWhimsical 等字段
  final List<Map<String, dynamic>> suggestions;

  const SuggestedUnits({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '约等于',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final item = suggestions[index];
                final value = item['value'] as String;
                final unit = item['unit'] as String;
                return Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: ' $unit',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
