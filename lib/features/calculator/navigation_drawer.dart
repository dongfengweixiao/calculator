import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../l10n/app_localizations.dart';
import '../../core/router/nav_config.dart';

/// Navigation drawer for calculator mode selection
///
/// This version uses route-based navigation configuration instead of ViewMode enum,
/// making it fully compatible with go_router.
class CalculatorNavigationDrawer extends ConsumerWidget {
  const CalculatorNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final currentLocation = GoRouterState.of(context).uri;
    final l10n = context.l10n;

    return Drawer(
      backgroundColor: theme.navPaneBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation categories
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
          ],
        ),
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
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            group.nameKey(l10n),
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 14,
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

    return _NavigationItem(
      icon: item.icon,
      label: localizedLabel,
      isSelected: isSelected,
      theme: theme,
      onPressed: () {
        context.go(item.route);
        Navigator.of(context).pop();
      },
    );
  }
}

/// Navigation item (mode selector)
class _NavigationItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback? onPressed;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.theme,
    this.onPressed,
  });

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
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

    return InkWell(
      onHover: (value) {
        setState(() {
          _isHovered = value;
        });
      },
      onTap: widget.onPressed,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: widget.isSelected
              ? Border(
                  left: BorderSide(color: widget.theme.accentColor, width: 3),
                )
              : null,
        ),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 48,
              child: Center(
                child: Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.textPrimary,
                  size: 20,
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
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
