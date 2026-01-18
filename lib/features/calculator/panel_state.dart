import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 键盘区域的内容类型
///
/// 用于手机模式（< 600px）时，键盘区域可以显示：
/// - keypad: 标准键盘
/// - history: 历史记录列表
/// - memory: 记忆列表
enum KeypadAreaType {
  keypad,
  history,
  memory,
}

/// 面板布局模式
///
/// 根据窗口宽度自动切换：
/// - embedded: 嵌入式模式（< 600px），在键盘区域显示
/// - sideBar: 侧边栏模式（>= 600px），在右侧永久显示
enum PanelMode {
  embedded,
  sideBar,
}

/// 侧边栏显示的内容类型
///
/// 用于平板模式（>= 600px）时，右侧侧边栏显示的内容：
/// - history: 历史记录列表
/// - memory: 记忆列表
enum SidePanelContentType {
  history,
  memory,
}

/// 键盘区域状态
///
/// 管理手机模式下键盘区域显示的内容类型
class KeypadAreaState {
  final KeypadAreaType currentType;

  const KeypadAreaState({this.currentType = KeypadAreaType.keypad});

  /// 是否显示键盘
  bool get isKeypad => currentType == KeypadAreaType.keypad;

  /// 是否显示历史记录
  bool get isHistory => currentType == KeypadAreaType.history;

  /// 是否显示记忆
  bool get isMemory => currentType == KeypadAreaType.memory;

  KeypadAreaState copyWith({KeypadAreaType? currentType}) {
    return KeypadAreaState(
      currentType: currentType ?? this.currentType,
    );
  }
}

/// 键盘区域状态管理器
class KeypadAreaNotifier extends Notifier<KeypadAreaState> {
  @override
  KeypadAreaState build() {
    return const KeypadAreaState();
  }

  /// 显示键盘
  void showKeypad() {
    state = const KeypadAreaState(currentType: KeypadAreaType.keypad);
  }

  /// 显示历史记录
  void showHistory() {
    state = const KeypadAreaState(currentType: KeypadAreaType.history);
  }

  /// 显示记忆
  void showMemory() {
    state = const KeypadAreaState(currentType: KeypadAreaType.memory);
  }

  /// 切换面板
  ///
  /// 如果当前已经显示指定类型，则返回键盘；否则显示指定类型
  void toggle(KeypadAreaType type) {
    if (state.currentType == type) {
      showKeypad();
    } else {
      state = KeypadAreaState(currentType: type);
    }
  }
}

/// 侧边栏状态
///
/// 管理平板模式下侧边栏显示的内容类型
/// 侧边栏在平板模式下永久显示，只需切换内容
class SidePanelState {
  final SidePanelContentType currentType;

  const SidePanelState({this.currentType = SidePanelContentType.history});

  /// 是否显示历史记录
  bool get isHistory => currentType == SidePanelContentType.history;

  /// 是否显示记忆
  bool get isMemory => currentType == SidePanelContentType.memory;

  SidePanelState copyWith({SidePanelContentType? currentType}) {
    return SidePanelState(
      currentType: currentType ?? this.currentType,
    );
  }
}

/// 侧边栏状态管理器
class SidePanelNotifier extends Notifier<SidePanelState> {
  @override
  SidePanelState build() {
    return const SidePanelState();
  }

  /// 显示历史记录
  void showHistory() {
    state = const SidePanelState(currentType: SidePanelContentType.history);
  }

  /// 显示记忆
  void showMemory() {
    state = const SidePanelState(currentType: SidePanelContentType.memory);
  }

  /// 切换内容
  ///
  /// 如果当前已经显示指定类型，则切换到另一个类型
  void toggle(SidePanelContentType type) {
    if (state.currentType == type) {
      // 如果当前已经是该类型，不做任何操作（保持显示）
      return;
    } else {
      state = SidePanelState(currentType: type);
    }
  }
}
