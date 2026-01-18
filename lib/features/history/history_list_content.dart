import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calculator/calculator_provider.dart';
import '../../core/services/history/history_formatter.dart';
import '../../core/services/history/history_recall_service.dart';
import '../../core/services/history/history_deleter.dart';
import '../../core/theme/app_icons.dart';
import '../../extensions/extensions.dart';

/// History list content (pure content without container)
/// Can be used in: mobile embedded panel / tablet side panel
class HistoryListContent extends ConsumerWidget {
  const HistoryListContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(calculatorProvider).historyItems;

    if (historyItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[historyItems.length - 1 - index];
                  final actualIndex = historyItems.length - 1 - index;
                  return _HistoryItemTile(
                    expression: HistoryFormatter.formatExpression(item.expression),
                    result: HistoryFormatter.formatResult(item.result),
                    onTap: () => _handleRecall(ref, historyItems.length, actualIndex),
                    onDelete: () => _handleDeleteItem(ref, actualIndex),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: _ClearButton(
                  icon: CalculatorIcons.trashCan,
                  tooltip: 'Clear history',
                  onPressed: () => _handleClearHistory(context, ref),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Empty state
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CalculatorIcons.history, size: 48, color: context.theme.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(BuildContextX(context).l10n.noHistoryTitle, style: TextStyle(color: context.theme.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Recall history item
  void _handleRecall(WidgetRef ref, int totalCount, int actualIndex) {
    HistoryRecallService.recallToCalculator(ref, totalCount, actualIndex);
  }

  /// Delete single history item
  void _handleDeleteItem(WidgetRef ref, int actualIndex) {
    HistoryDeleter.deleteHistoryItem(ref, actualIndex);
  }

  /// Clear all history
  void _handleClearHistory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              HistoryDeleter.clearAllHistory(ref);
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

/// History list item tile
class _HistoryItemTile extends StatelessWidget {
  final String expression;
  final String result;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryItemTile({
    required this.expression,
    required this.result,
    required this.onTap,
    required this.onDelete,
  });

  void _showContextMenu(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final selectedOption = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height + 100,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 18, color: context.theme.textSecondary),
              const SizedBox(width: 12),
              Text('Copy', style: TextStyle(color: context.theme.textPrimary)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: context.theme.textSecondary),
              const SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: context.theme.textPrimary)),
            ],
          ),
        ),
      ],
      elevation: 8,
    );

    if (selectedOption == null) return;

    if (selectedOption == 'copy') {
      await Clipboard.setData(ClipboardData(text: result));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied to clipboard'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else if (selectedOption == 'delete') {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        onSecondaryTapDown: (details) => _showContextMenu(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: context.theme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.theme.divider.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(expression, style: TextStyle(color: context.theme.textSecondary, fontSize: 13), textAlign: TextAlign.right),
              const SizedBox(height: 4),
              Text(result, style: TextStyle(color: context.theme.textPrimary, fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic clear button (floating at bottom right)
class _ClearButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ClearButton({required this.icon, required this.tooltip, required this.onPressed});

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isHovered ? context.theme.accentColor.withValues(alpha: 0.2) : context.theme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.theme.accentColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Icon(widget.icon, color: context.theme.accentColor, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
