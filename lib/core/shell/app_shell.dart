import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/theme_provider.dart';
import '../../l10n/l10n.dart';
import '../router/nav_config.dart';
import '../services/input/hotkey_registry.dart';
import '../services/calculator_service.dart';
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
/// - Hotkey management using hotkey_manager
///
/// This shell is designed to be used with go_router's ShellRoute to provide
/// a consistent layout across all pages.
///
/// Sidebar is hidden by default and shown via drawer when menu button is pressed.
/// History panel is shown only for calculator modes (standard, scientific, programmer).
/// Hotkeys are registered dynamically based on the current calculator mode.
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

class _AppShellState extends ConsumerState<AppShell> with RouteAware {
  /// Global key for controlling the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Hotkey registry for managing calculator shortcuts
  HotkeyRegistry? _hotkeyRegistry;

  /// Current calculator mode
  CalculatorMode? _currentMode;

  /// Whether history panel is visible
  bool _isHistoryPanelVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize HotkeyRegistry after first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _hotkeyRegistry = HotkeyRegistry(ref, context);
        });
        _updateHotkeysForCurrentRoute();
      }
    });
  }

  @override
  void dispose() {
    // Unregister all hotkeys when disposing
    _hotkeyRegistry?.unregisterAll();
    super.dispose();
  }

  /// Get current calculator mode from route
  CalculatorMode? _getCurrentCalculatorMode() {
    final routerState = GoRouterState.of(context);
    final path = routerState.uri.path;

    switch (path) {
      case '/standard':
        return CalculatorMode.standard;
      case '/scientific':
        return CalculatorMode.scientific;
      case '/programmer':
        return CalculatorMode.programmer;
      default:
        return null;
    }
  }

  /// Routes that should disable all hotkeys (like test pages)
  static const List<String> _hotkeyDisabledRoutes = [
    '/settings/minimal-hotkey-test',
    '/settings/fn-key-test',
    '/settings/keyboard-shortcuts',
  ];

  /// Update hotkeys when route changes
  void _updateHotkeysForCurrentRoute() async {
    final routerState = GoRouterState.of(context);
    final currentPath = routerState.uri.path;

    // Check if we're on a route that should disable hotkeys
    final shouldDisableHotkeys = _hotkeyDisabledRoutes.any((route) =>
      currentPath.startsWith(route) || route == currentPath
    );

    if (shouldDisableHotkeys) {
      // Disable all hotkeys for test/settings pages
      if (_currentMode != null && _hotkeyRegistry != null) {
        await _hotkeyRegistry!.unregisterAll();
        setState(() {
          _currentMode = null;
        });
      }
      return;
    }

    // For all other routes (including date-calculation), keep hotkeys enabled
    final mode = _getCurrentCalculatorMode();

    // Only update if mode changed
    if (mode != _currentMode && _hotkeyRegistry != null) {
      setState(() {
        _currentMode = mode;
      });

      if (mode != null) {
        // Re-initialize hotkeys for the new calculator mode
        await _hotkeyRegistry!.initializeForMode(mode);
      } else {
        // We're on a non-calculator page (like date-calculation)
        // Keep navigation shortcuts (Alt+1/2/3/4) active
        // but don't register mode-specific hotkeys
        await _hotkeyRegistry!.initializeForMode(CalculatorMode.standard);
      }
    }
  }

  /// Check if current route should show history panel
  bool _shouldShowHistoryPanel() {
    final routerState = GoRouterState.of(context);
    return _calculatorRoutes.contains(routerState.uri.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final routerState = GoRouterState.of(context);
    final l10n = context.l10n;

    // Get title from current route path
    final currentPath = routerState.uri.path;
    final title = currentPath.getTitleForRoute(l10n) ?? 'Calculator';

    // Check if current route should show history panel
    final shouldShowHistoryPanel = _shouldShowHistoryPanel();

    // Update hotkeys when route changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHotkeysForCurrentRoute();
    });

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
