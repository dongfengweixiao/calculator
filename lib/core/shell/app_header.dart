import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/theme_provider.dart';

/// Unified application header component
///
/// Displays the title of the current view and optional global actions.
/// The title is provided by the parent widget based on the current route.
class AppHeader extends ConsumerWidget {
  /// Title to display in the header
  final String title;

  /// Optional widget to display on the right side of the header
  final Widget? trailing;

  /// Callback for menu button press (hamburger icon)
  /// When null, menu button is not shown
  final VoidCallback? onMenuPressed;

  /// Whether to show the menu button
  final bool showMenuButton;

  /// Callback for history button press
  /// When null, history button is not shown
  final VoidCallback? onHistoryPressed;

  /// Whether to show the history button
  final bool showHistoryButton;

  /// Whether the history panel is currently visible
  /// Used to display different icon states (active/inactive)
  final bool isHistoryPanelVisible;

  const AppHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onMenuPressed,
    this.showMenuButton = false,
    this.onHistoryPressed,
    this.showHistoryButton = false,
    this.isHistoryPanelVisible = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menu button (hamburger icon)
          if (showMenuButton && onMenuPressed != null)
            IconButton(
              icon: Icon(
                Icons.menu,
                color: theme.textPrimary,
              ),
              onPressed: onMenuPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // History button
          if (showHistoryButton && onHistoryPressed != null)
            IconButton(
              icon: Icon(
                Icons.history,
                color: isHistoryPanelVisible
                    ? theme.accentColor
                    : theme.textPrimary,
              ),
              onPressed: onHistoryPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              tooltip: 'History',
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
