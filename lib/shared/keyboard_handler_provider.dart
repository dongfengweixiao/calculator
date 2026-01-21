import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../core/services/input/keyboard_handler.dart';

/// Notifier for global keyboard handler state
class KeyboardHandlerNotifier extends Notifier<KeyboardHandler?> {
  static final _log = Logger('KeyboardHandlerProvider');

  @override
  KeyboardHandler? build() => null;

  void setHandler(KeyboardHandler handler) {
    _log.info('Setting global KeyboardHandler');
    state = handler;
  }

  void clearHandler() {
    _log.info('Clearing global KeyboardHandler');
    state = null;
  }
}

/// Global KeyboardHandler Provider
///
/// Allows any page to access and register keyboard callbacks
final keyboardHandlerProvider =
    NotifierProvider<KeyboardHandlerNotifier, KeyboardHandler?>(
  KeyboardHandlerNotifier.new,
);

/// Set the global KeyboardHandler
void setGlobalKeyboardHandler(WidgetRef ref, KeyboardHandler handler) {
  ref.read(keyboardHandlerProvider.notifier).setHandler(handler);
}

/// Register unit converter keyboard callback
void registerConverterKeyboardCallback(
  WidgetRef ref,
  ConverterKeyboardCallback? callback,
) {
  final handler = ref.read(keyboardHandlerProvider);
  handler?.registerConverterCallback(callback);
}
