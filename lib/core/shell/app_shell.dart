import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/theme_provider.dart';
import '../../l10n/l10n.dart';
import '../router/nav_config.dart';
import 'app_header.dart';
import 'app_sidebar.dart';
import '../../features/history/history_panel.dart';

/// Breakpoint for history panel visibility
/// Below this width, history panel is hidden
const double _historyPanelBreakpoint = 560.0;

/// Routes that should show the history panel
const List<String> _calculatorRoutes = [
  '/standard',
  '/scientific',
  '/programmer',
];

/// Application shell widget
///
/// Provides the unified application layout structure including:
/// - Sidebar navigation (AppSidebar) - accessible via drawer
/// - Header with current view title and menu button (AppHeader)
/// - History panel (for calculator modes only)
/// - Main content area (child widget)
///
/// This shell is designed to be used with go_router's ShellRoute to provide
/// a consistent layout across all pages.
///
/// Sidebar is hidden by default and shown via drawer when menu button is pressed.
/// History panel is shown only for calculator modes (standard, scientific, programmer).
class AppShell extends ConsumerStatefulWidget {
  /// The child widget to display in the main content area
  /// This will be the current route's page content
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Global key for controlling the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Whether history panel is visible
  bool _isHistoryPanelVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final routerState = GoRouterState.of(context);
    final l10n = context.l10n;

    // Get title from current route path
    final currentPath = routerState.uri.path;
    final title = currentPath.getTitleForRoute(l10n) ?? 'Calculator';

    // Check if current route should show history panel
    final shouldShowHistoryPanel = _calculatorRoutes.contains(currentPath);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we should show history panel based on screen width
        final isWideScreen = constraints.maxWidth >= _historyPanelBreakpoint;
        final showHistoryPanel = isWideScreen && shouldShowHistoryPanel;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.background,
          drawer: SizedBox(
            width: 240,
            child: Drawer(
              backgroundColor: theme.navPaneBackground,
              child: const AppSidebar(),
            ),
          ),
          body: Row(
            children: [
              // Main content area
              Expanded(
                child: Column(
                  children: [
                    // Unified header with menu and history buttons
                    AppHeader(
                      title: title,
                      showMenuButton: true,
                      showHistoryButton: shouldShowHistoryPanel,
                      isHistoryPanelVisible: _isHistoryPanelVisible,
                      onMenuPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      onHistoryPressed: () {
                        setState(() {
                          _isHistoryPanelVisible = !_isHistoryPanelVisible;
                        });
                      },
                    ),

                    // Content area with optional history panel
                    Expanded(
                      child: Row(
                        children: [
                          // Page content (router switches this)
                          Expanded(child: widget.child),

                          // History panel (conditionally shown on wide screens)
                          if (showHistoryPanel && _isHistoryPanelVisible)
                            const HistoryMemoryPanel(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
