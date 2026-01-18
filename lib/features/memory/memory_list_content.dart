import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calculator/calculator_provider.dart';
import '../../core/services/history/history_formatter.dart';
import '../../core/services/history/history_recall_service.dart';
import '../../core/services/history/history_deleter.dart';
import '../../core/theme/app_icons.dart';
import '../../extensions/extensions.dart';

/// Memory list content (pure content without container)
/// Can be used in: mobile embedded panel / tablet side panel
class MemoryListContent extends ConsumerWidget {
  const MemoryListContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryItems = ref.watch(calculatorProvider).memoryItems;

    if (memoryItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                itemCount: memoryItems.length,
                itemBuilder: (context, index) {
                  return _MemoryItemTile(
                    value: HistoryFormatter.formatMemoryValue(memoryItems[index]),
                    onTap: () => _handleRecall(ref, index),
                    onClear: () => _handleClearItem(ref, index),
                    onMemoryAdd: () => _handleMemoryAdd(ref, index),
                    onMemorySubtract: () => _handleMemorySubtract(ref, index),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: _ClearButton(
                  icon: CalculatorIcons.trashCan,
                  tooltip: 'Clear memory',
                  onPressed: () => _handleClearMemory(context, ref),
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
                Icon(Icons.save_outlined, size: 48, color: context.theme.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(BuildContextX(context).l10n.noMemoryTitle, style: TextStyle(color: context.theme.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Text(BuildContextX(context).l10n.noMemoryHint, style: TextStyle(color: context.theme.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Recall memory item
  void _handleRecall(WidgetRef ref, int index) {
    HistoryRecallService.recallMemory(ref, index);
  }

  /// Clear single memory item
  void _handleClearItem(WidgetRef ref, int index) {
    HistoryDeleter.deleteMemoryItem(ref, index);
  }

  /// Add current value to memory item
  void _handleMemoryAdd(WidgetRef ref, int index) {
    HistoryRecallService.addMemory(ref, index);
  }

  /// Subtract current value from memory item
  void _handleMemorySubtract(WidgetRef ref, int index) {
    HistoryRecallService.subtractMemory(ref, index);
  }

  /// Clear all memory
  void _handleClearMemory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Memory'),
        content: const Text('Are you sure you want to clear all memory?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              HistoryDeleter.clearAllMemory(ref);
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

/// Memory list item tile
class _MemoryItemTile extends StatefulWidget {
  final String value;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final VoidCallback onMemoryAdd;
  final VoidCallback onMemorySubtract;

  const _MemoryItemTile({
    required this.value,
    required this.onTap,
    required this.onClear,
    required this.onMemoryAdd,
    required this.onMemorySubtract,
  });

  @override
  State<_MemoryItemTile> createState() => _MemoryItemTileState();
}

class _MemoryItemTileState extends State<_MemoryItemTile> {
  bool _isHovered = false;

  // Check if running on mobile platform
  bool get _isMobile => Platform.isAndroid || Platform.isIOS;

  // Determine if action buttons should be visible
  bool get _showActions => _isMobile || _isHovered;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: _isHovered ? context.theme.textPrimary.withValues(alpha: 0.05) : context.theme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.theme.divider.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.value, style: TextStyle(color: context.theme.textPrimary, fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
              if (_showActions)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _MemoryActionChip(
                          label: 'MC',
                          icon: CalculatorIcons.memoryClear,
                          onPressed: widget.onClear,
                        ),
                        const SizedBox(width: 8),
                        _MemoryActionChip(
                          label: 'M+',
                          icon: CalculatorIcons.memoryAdd,
                          onPressed: widget.onMemoryAdd,
                        ),
                        const SizedBox(width: 8),
                        _MemoryActionChip(
                          label: 'M-',
                          icon: CalculatorIcons.memorySubtract,
                          onPressed: widget.onMemorySubtract,
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Memory action chip
class _MemoryActionChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const _MemoryActionChip({
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  State<_MemoryActionChip> createState() => _MemoryActionChipState();
}

class _MemoryActionChipState extends State<_MemoryActionChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered ? context.theme.textPrimary.withValues(alpha: 0.15) : context.theme.textPrimary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.icon != null
              ? Text(
                  String.fromCharCode(widget.icon!.codePoint),
                  style: TextStyle(
                    fontFamily: widget.icon!.fontFamily,
                    color: context.theme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  widget.label,
                  style: TextStyle(color: context.theme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
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
