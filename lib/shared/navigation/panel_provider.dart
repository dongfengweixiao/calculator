import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/calculator/panel_state.dart';

/// Layout mode state
class LayoutModeState {
  final bool isMobileMode;

  const LayoutModeState({this.isMobileMode = true});

  LayoutModeState copyWith({bool? isMobileMode}) {
    return LayoutModeState(
      isMobileMode: isMobileMode ?? this.isMobileMode,
    );
  }
}

/// Layout mode notifier
class LayoutModeNotifier extends Notifier<LayoutModeState> {
  @override
  LayoutModeState build() {
    return const LayoutModeState();
  }

  void setMobileMode(bool isMobile) {
    state = LayoutModeState(isMobileMode: isMobile);
  }
}

/// Provider for layout mode (mobile vs desktop)
///
/// Tracks whether the app is currently in mobile mode (< 600px)
/// Used to synchronize layout decisions across the app
final layoutModeProvider = NotifierProvider<LayoutModeNotifier, LayoutModeState>(
  LayoutModeNotifier.new,
);

/// Provider for keypad area state
///
/// Manages the content type displayed in the keypad area
/// Used in mobile mode (< 600px) to switch between keypad/history/memory
final keypadAreaProvider =
    NotifierProvider<KeypadAreaNotifier, KeypadAreaState>(
  KeypadAreaNotifier.new,
);

/// Provider for side panel state
///
/// Manages the content type displayed in the side panel
/// Used in tablet/desktop mode (>= 600px), side panel is always visible
final sidePanelProvider =
    NotifierProvider<SidePanelNotifier, SidePanelState>(
  SidePanelNotifier.new,
);

/// Convenience provider to check if currently showing keypad in mobile mode
final isShowingKeypadProvider = Provider<bool>((ref) {
  return ref.watch(keypadAreaProvider).isKeypad;
});

/// Convenience provider to check if currently showing history in mobile mode
final isShowingHistoryInKeypadProvider = Provider<bool>((ref) {
  return ref.watch(keypadAreaProvider).isHistory;
});

/// Convenience provider to check if currently showing memory in mobile mode
final isShowingMemoryInKeypadProvider = Provider<bool>((ref) {
  return ref.watch(keypadAreaProvider).isMemory;
});

/// Convenience provider to check what's showing in side panel
final sidePanelContentTypeProvider = Provider<SidePanelContentType>((ref) {
  return ref.watch(sidePanelProvider).currentType;
});
