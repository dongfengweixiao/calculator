import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/nav_config.dart';
import '../widgets/custom_title_bar.dart';
import '../theme/app_theme.dart';
import '../services/calculator_service.dart';
import 'app_header.dart';
import 'app_sidebar.dart';
import 'responsive_side_panel.dart';
import '../../features/calculator/calculator_provider.dart';
import '../../features/calculator/panel_state.dart';
import '../../shared/navigation/panel_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../extensions/extensions.dart';

/// Breakpoint for side panel visibility
/// Below this width, side panel is hidden (mobile mode)
/// At or above this width, side panel is always visible (tablet/desktop mode)
const double _sidePanelBreakpoint = 600.0;

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
/// - Responsive side panel (for calculator modes only, >= 600px)
/// - Main content area (child widget)
///
/// This shell is designed to be used with go_router's ShellRoute to provide
/// a consistent layout across all pages.
///
/// Sidebar is hidden by default and shown via drawer when menu button is pressed.
/// Side panel is always visible on wide screens (>= 600px) for calculator modes.
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

  /// Track previous width state to detect transitions
  bool _wasWideScreen = true;

  /// Track previous history count to detect when history is cleared
  int _previousHistoryCount = 0;

  /// Track previous memory count to detect when memory is cleared
  int _previousMemoryCount = 0;

  /// Track previous route to detect route changes
  String? _previousRoute;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final theme = themeState.theme;
    final routerState = GoRouterState.of(context);
    final l10n = context.l10n;

    // Get title from current route path
    final currentPath = routerState.uri.path;
    final title = currentPath.getTitleForRoute(l10n) ?? 'Calculator';

    // Update calculator mode based on route (delayed to avoid modifying state during build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_previousRoute != currentPath) {
        _updateCalculatorModeForRoute(currentPath);
        _previousRoute = currentPath;
      }
    });

    // Check if current route should show side panel
    final shouldShowSidePanel = _calculatorRoutes.contains(currentPath);

    // Check if we should show custom title bar (desktop only)
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we should show side panel based on screen width
        final isWideScreen = constraints.maxWidth >= _sidePanelBreakpoint;
        final showSidePanel = isWideScreen && shouldShowSidePanel;
        // Show AppHeader on mobile platforms (phone and tablet), but not desktop apps
        final shouldShowAppHeader = !isDesktop;

        // Check if history has items
        final historyCount = ref.watch(calculatorProvider).historyCount;
        final hasHistory = historyCount > 0;

        // Check memory count
        final memoryCount = ref.watch(calculatorProvider).memoryCount;

        // Update layout mode provider for child widgets to use
        // Delay to avoid modifying provider during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(layoutModeProvider.notifier).setMobileMode(!isWideScreen);

          // If transitioning from narrow to wide screen, close keypad area panels
          if (!_wasWideScreen && isWideScreen) {
            final currentKeypadState = ref.read(keypadAreaProvider).currentType;
            if (currentKeypadState != KeypadAreaType.keypad) {
              ref.read(keypadAreaProvider.notifier).showKeypad();
            }
          }

          // If in narrow layout (< 600px) and history was cleared, close history panel
          if (!isWideScreen && _previousHistoryCount > 0 && historyCount == 0) {
            final currentKeypadState = ref.read(keypadAreaProvider).currentType;
            if (currentKeypadState == KeypadAreaType.history) {
              ref.read(keypadAreaProvider.notifier).showKeypad();
            }
          }

          // If in narrow layout (< 600px) and memory was cleared, close memory panel
          if (!isWideScreen && _previousMemoryCount > 0 && memoryCount == 0) {
            final currentKeypadState = ref.read(keypadAreaProvider).currentType;
            if (currentKeypadState == KeypadAreaType.memory) {
              ref.read(keypadAreaProvider.notifier).showKeypad();
            }
          }

          // Update previous states
          _wasWideScreen = isWideScreen;
          _previousHistoryCount = historyCount;
          _previousMemoryCount = memoryCount;
        });

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
          body: SafeArea(
            child: Column(
              children: [
                // Custom title bar for desktop platforms
                if (isDesktop)
                  CustomTitleBar(
                    title: title,
                    backgroundColor: theme.navPaneBackground,
                    onMenuPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    // Only show history button when side panel is not visible and history has items
                    onHistoryPressed: !showSidePanel && shouldShowSidePanel && hasHistory
                        ? () {
                            // Show history panel in keypad area (mobile layout)
                            ref.read(keypadAreaProvider.notifier).toggle(KeypadAreaType.history);
                          }
                        : null,
                  ),

                // Main content area
                Expanded(
                  child: Row(
                    children: [
                      // Main content
                      Expanded(
                        child: CalculatorThemeProvider(
                          theme: theme,
                          child: Column(
                            children: [
                              // Unified header for mobile platforms (not desktop apps)
                              if (shouldShowAppHeader)
                                AppHeader(
                                  title: title,
                                  showMenuButton: true,
                                  showHistoryButton: shouldShowSidePanel && hasHistory,
                                  onMenuPressed: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  onHistoryPressed: shouldShowSidePanel && hasHistory
                                      ? () {
                                            ref.read(keypadAreaProvider.notifier).toggle(
                                              KeypadAreaType.history,
                                            );
                                          }
                                      : null,
                                ),

                              // Content area with optional side panel
                              Expanded(
                                child: Row(
                                  children: [
                                    // Page content (router switches this)
                                    Expanded(
                                      child: widget.child,
                                    ),

                                    // Side panel (always shown on wide screens)
                                    if (showSidePanel) const ResponsiveSidePanel(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Update calculator mode based on current route
  void _updateCalculatorModeForRoute(String route) {
    final calculator = ref.read(calculatorProvider.notifier);

    // Map routes to calculator modes
    switch (route) {
      case '/standard':
        calculator.setMode(CalculatorMode.standard);
        break;
      case '/scientific':
        calculator.setMode(CalculatorMode.scientific);
        break;
      case '/programmer':
        calculator.setMode(CalculatorMode.programmer);
        break;
      default:
        // For non-calculator routes, keep current mode
        break;
    }
  }
}
