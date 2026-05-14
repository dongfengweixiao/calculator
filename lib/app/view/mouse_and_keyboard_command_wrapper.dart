import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/page_ids.dart';
import '../../core/services/input/keyboard_handler.dart';
import '../app_model.dart';
import 'back_gesture.dart';
import 'routing_manager.dart';

class MouseAndKeyboardCommandWrapper extends StatefulWidget {
  const MouseAndKeyboardCommandWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<MouseAndKeyboardCommandWrapper> createState() =>
      _MouseAndKeyboardCommandWrapperState();
}

class _MouseAndKeyboardCommandWrapperState
    extends State<MouseAndKeyboardCommandWrapper> {
  KeyboardHandler? _keyboardHandler;

  @override
  void initState() {
    super.initState();
    // 在第一帧渲染后初始化热键
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      _keyboardHandler = KeyboardHandler();
      await _keyboardHandler!.registerAll();
    });
  }

  @override
  void dispose() {
    _keyboardHandler?.unregisterAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.comma, LogicalKeyboardKey.meta):
          const _SettingsIntent(),
      LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.backspace):
          const _BackIntent(),
      LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.backspace):
          const _BackIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        _SettingsIntent: CallbackAction<_SettingsIntent>(
          onInvoke: (intent) {
            if (di<AppModel>().fullWindowMode ?? false) {
              di<AppModel>().setFullWindowMode(false);
            }
            di<RoutingManager>().push(pageId: PageIDs.settings);
            return null;
          },
        ),
        _BackIntent: CallbackAction<_BackIntent>(
          onInvoke: (intent) {
            if (di<AppModel>().fullWindowMode ?? false) {
              di<AppModel>().setFullWindowMode(false);
            }
            di<RoutingManager>().pop();
            return null;
          },
        ),
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          _MouseBackButtonRecognizer:
              GestureRecognizerFactoryWithHandlers<_MouseBackButtonRecognizer>(
                () => _MouseBackButtonRecognizer(),
                (instance) =>
                    instance.onTapDown = (details) =>
                        di<RoutingManager>().pop(),
              ),
        },
        child: BackGesture(child: widget.child),
      ),
    ),
  );
}

class _SettingsIntent extends Intent {
  const _SettingsIntent();
}

class _BackIntent extends Intent {
  const _BackIntent();
}

class _MouseBackButtonRecognizer extends BaseTapGestureRecognizer {
  GestureTapDownCallback? onTapDown;

  @override
  void handleTapCancel({
    required PointerDownEvent down,
    PointerCancelEvent? cancel,
    required String reason,
  }) {}

  @override
  void handleTapDown({required PointerDownEvent down}) {
    final TapDownDetails details = TapDownDetails(
      globalPosition: down.position,
      localPosition: down.localPosition,
      kind: getKindForPointer(down.pointer),
    );

    if (down.buttons == kBackMouseButton && onTapDown != null) {
      invokeCallback<void>('onTapDown', () => onTapDown!(details));
    }
  }

  @override
  void handleTapUp({
    required PointerDownEvent down,
    required PointerUpEvent up,
  }) {}
}
