import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/calculator/panel_state.dart';
import '../../features/history/history_list_content.dart';
import '../../features/memory/memory_list_content.dart';
import '../../shared/navigation/panel_provider.dart';
import '../../extensions/extensions.dart';

/// Responsive side panel for tablet/desktop mode (>= 600px)
///
/// This panel is always visible on the right side in tablet/desktop mode.
/// It displays either history or memory content based on sidePanelProvider.
///
/// Width: 320px (fixed)
class ResponsiveSidePanel extends ConsumerWidget {
  const ResponsiveSidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidePanelState = ref.watch(sidePanelProvider);

    return Container(
      width: 320,
      color: context.theme.background,
      child: Column(
        children: [
          // Tab bar
          _buildTabBar(context, ref, sidePanelState),

          // Tab content
          Expanded(
            child: sidePanelState.isHistory
                ? const HistoryListContent()
                : const MemoryListContent(),
          ),
        ],
      ),
    );
  }

  /// Build tab bar for switching between history and memory
  Widget _buildTabBar(
    BuildContext context,
    WidgetRef ref,
    SidePanelState sidePanelState,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.theme.divider.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          _TabButton(
            icon: Icons.history,
            label: BuildContextX(context).l10n.history,
            isSelected: sidePanelState.isHistory,
            onPressed: () => ref.read(sidePanelProvider.notifier).showHistory(),
          ),
          const SizedBox(width: 8),
          _TabButton(
            icon: Icons.save_outlined,
            label: BuildContextX(context).l10n.memory,
            isSelected: sidePanelState.isMemory,
            onPressed: () => ref.read(sidePanelProvider.notifier).showMemory(),
          ),
        ],
      ),
    );
  }
}

/// Tab button for history/memory selection
class _TabButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered && !widget.isSelected
                ? context.theme.textPrimary.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border(
                    bottom: BorderSide(
                      color: context.theme.accentColor,
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.isSelected
                    ? context.theme.accentColor
                    : context.theme.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isSelected
                      ? context.theme.accentColor
                      : context.theme.textSecondary,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
