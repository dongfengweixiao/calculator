import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../l10n/app_localizations.dart';
import '../router/nav_config.dart';

/// Application sidebar navigation component
///
/// Displays a persistent sidebar with navigation items organized by groups.
/// This is designed for desktop/tablet layouts where sidebar is always visible.
/// For mobile layouts, consider using a drawer instead.
///
/// This version uses route-based navigation configuration instead of ViewMode enum,
/// making it fully compatible with go_router.
class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final currentLocation = GoRouterState.of(context).uri;
    final l10n = context.l10n;

    return Container(
      width: 240,
      color: theme.navPaneBackground,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final group in navCategoriesConfig)
                    _buildCategoryGroup(
                      context,
                      theme,
                      group,
                      currentLocation,
                      l10n,
                    ),
                ],
              ),
            ),
          ),
          // Fixed settings entry at the bottom
          _buildSettingsEntry(context, theme, currentLocation),
        ],
      ),
    );
  }

  /// Build the fixed settings entry at the bottom of sidebar
  Widget _buildSettingsEntry(
    BuildContext context,
    CalculatorTheme theme,
    Uri currentLocation,
  ) {
    final isSettingsSelected = currentLocation.path == '/settings/keyboard-shortcuts';

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.textSecondary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: _SidebarNavItem(
        icon: Icons.settings_outlined,
        label: 'Keyboard Shortcuts',
        isSelected: isSettingsSelected,
        theme: theme,
        onTap: () => context.go('/settings/keyboard-shortcuts'),
      ),
    );
  }

  Widget _buildCategoryGroup(
    BuildContext context,
    CalculatorTheme theme,
    NavCategoryConfig group,
    Uri currentLocation,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            group.nameKey(l10n),
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Category items
        for (final item in group.items)
          _buildCategoryItem(
            context,
            theme,
            item,
            currentLocation,
            l10n,
          ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    CalculatorTheme theme,
    NavItemConfig item,
    Uri currentLocation,
    AppLocalizations l10n,
  ) {
    final isSelected = currentLocation.path == item.route;
    final localizedLabel = item.titleKey(l10n);

    return _SidebarNavItem(
      icon: item.icon,
      label: localizedLabel,
      isSelected: isSelected,
      theme: theme,
      onTap: () => context.go(item.route),
    );
  }
}

/// Sidebar navigation item widget
class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback? onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.theme,
    this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.accentColor.withValues(alpha: 0.15);
    } else if (_isHovered) {
      backgroundColor = widget.theme.textPrimary.withValues(alpha: 0.08);
    } else {
      backgroundColor = Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border(
                    left: BorderSide(
                      color: widget.theme.accentColor,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icon
              SizedBox(
                width: 40,
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.isSelected
                        ? widget.theme.accentColor
                        : widget.theme.textPrimary,
                    size: 18,
                  ),
                ),
              ),
              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isSelected
                        ? widget.theme.accentColor
                        : widget.theme.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
