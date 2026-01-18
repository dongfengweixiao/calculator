import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/layout/responsive_layout_service.dart';

/// Navigation state
///
/// Simplified to manage only UI state like drawer and history panel visibility.
/// Page navigation is handled by go_router through route paths.
class NavigationState {
  final bool isDrawerOpen;
  final bool showHistoryPanel;

  const NavigationState({
    this.isDrawerOpen = false,
    this.showHistoryPanel = false,
  });

  NavigationState copyWith({
    bool? isDrawerOpen,
    bool? showHistoryPanel,
  }) {
    return NavigationState(
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      showHistoryPanel: showHistoryPanel ?? this.showHistoryPanel,
    );
  }
}

/// Navigation notifier
///
/// Manages UI-related navigation state (drawer, history panel).
/// Actual page navigation is handled by go_router.
class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    // Initialize with history panel visibility based on screen width
    // Note: This will be updated by the layout builder when context is available
    return const NavigationState();
  }

  /// Toggle drawer open/close
  void toggleDrawer() {
    state = state.copyWith(isDrawerOpen: !state.isDrawerOpen);
  }

  /// Open drawer
  void openDrawer() {
    state = state.copyWith(isDrawerOpen: true);
  }

  /// Close drawer
  void closeDrawer() {
    state = state.copyWith(isDrawerOpen: false);
  }

  /// Toggle history panel visibility
  void toggleHistoryPanel() {
    state = state.copyWith(showHistoryPanel: !state.showHistoryPanel);
  }

  /// Set history panel visibility based on screen width
  /// Uses ResponsiveLayoutService to determine visibility
  void updateHistoryPanelVisibility(double width) {
    final shouldShow = ResponsiveLayoutService.shouldShowHistoryPanel(width);
    if (state.showHistoryPanel != shouldShow) {
      state = state.copyWith(showHistoryPanel: shouldShow);
    }
  }
}

/// Navigation provider
///
/// Provides UI navigation state (drawer, history panel).
/// This is separate from route-based navigation which is handled by go_router.
final navigationProvider =
    NotifierProvider<NavigationNotifier, NavigationState>(
      NavigationNotifier.new,
    );

/// Show history panel provider
///
/// Exposes the history panel visibility state
final showHistoryPanelProvider = Provider<bool>((ref) {
  return ref.watch(navigationProvider).showHistoryPanel;
});
