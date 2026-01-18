import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Custom title bar widget for desktop platforms (Windows, Linux, macOS)
///
/// Provides:
/// - Draggable area to move the window
/// - Window control buttons (minimize, maximize, close)
/// - Menu button (hamburger icon) for opening sidebar
/// - History button for toggling side panel content (history/memory)
/// - Platform-specific layout and behavior
class CustomTitleBar extends StatefulWidget {
  /// The title to display in the title bar
  final String title;

  /// Height of the title bar
  final double height;

  /// Background color of the title bar
  final Color? backgroundColor;

  /// Callback for menu button press (hamburger icon)
  final VoidCallback? onMenuPressed;

  /// Callback for history button press (toggles side panel content)
  final VoidCallback? onHistoryPressed;

  const CustomTitleBar({
    super.key,
    this.title = 'Calculator',
    this.height = 40.0,
    this.backgroundColor,
    this.onMenuPressed,
    this.onHistoryPressed,
  });

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> with WindowListener {
  bool _isMaximized = false;
  // ignore: unused_field
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initWindowState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    setState(() {
      _isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      _isMaximized = false;
    });
  }

  Future<void> _initWindowState() async {
    final isMaximized = await windowManager.isMaximized();
    if (mounted) {
      setState(() {
        _isMaximized = isMaximized;
      });
    }
  }

  Future<void> _handleMinimize() async {
    await windowManager.minimize();
  }

  Future<void> _handleMaximize() async {
    if (_isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  Future<void> _handleClose() async {
    await windowManager.close();
  }

  @override
  Widget build(BuildContext context) {
    // Only show on desktop platforms
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      return _buildWindowsLinuxTitleBar(context);
    } else if (!kIsWeb && Platform.isMacOS) {
      return _buildMacOSTitleBar(context);
    }

    // Web and mobile platforms: return empty container
    return const SizedBox.shrink();
  }

  /// Build title bar for Windows and Linux
  Widget _buildWindowsLinuxTitleBar(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ??
        (theme.brightness == Brightness.dark
            ? const Color(0xFF2B2B2B)
            : const Color(0xFFFFFFFF));

    final iconColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.85)
        : Colors.black87;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Menu button (hamburger icon)
            if (widget.onMenuPressed != null)
              _TitleBarButton(
                icon: Icons.menu,
                iconSize: 24,
                onPressed: widget.onMenuPressed!,
                iconColor: iconColor,
                tooltip: 'Menu',
              ),

            // Draggable area with title
            Expanded(
              child: DragToMoveArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // History button (toggles side panel content)
            if (widget.onHistoryPressed != null)
              _TitleBarButton(
                icon: Icons.history,
                iconSize: 24,
                onPressed: widget.onHistoryPressed!,
                iconColor: iconColor,
                tooltip: 'History/Memory',
              ),

            // Window control buttons
            _WindowControlButtons(
              iconColor: iconColor,
              onMinimize: _handleMinimize,
              onMaximize: _handleMaximize,
              onClose: _handleClose,
              isMaximized: _isMaximized,
            ),
          ],
        ),
      ),
    );
  }

  /// Build title bar for macOS
  /// macOS has its own traffic light buttons, so we only provide a draggable area
  Widget _buildMacOSTitleBar(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
      ),
      child: DragToMoveArea(
        child: Container(
          padding: const EdgeInsets.only(left: 80), // Space for macOS traffic lights
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Window control buttons for Windows/Linux
class _WindowControlButtons extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final VoidCallback onClose;
  final bool isMaximized;

  const _WindowControlButtons({
    required this.iconColor,
    required this.onMinimize,
    required this.onMaximize,
    required this.onClose,
    required this.isMaximized,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WindowControlButton(
          icon: Icons.remove,
          iconSize: 24,
          onPressed: onMinimize,
          iconColor: iconColor,
          tooltip: 'Minimize',
        ),
        _WindowControlButton(
          icon: isMaximized ? Icons.fullscreen_exit : Icons.check_box_outline_blank,
          iconSize: 24,
          onPressed: onMaximize,
          iconColor: iconColor,
          tooltip: isMaximized ? 'Restore' : 'Maximize',
        ),
        _WindowControlButton(
          icon: Icons.close,
          iconSize: 24,
          onPressed: onClose,
          iconColor: iconColor,
          isCloseButton: true,
          tooltip: 'Close',
        ),
      ],
    );
  }
}

/// Individual window control button
class _WindowControlButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final Color iconColor;
  final bool isCloseButton;
  final String tooltip;

  const _WindowControlButton({
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    required this.iconColor,
    this.isCloseButton = false,
    required this.tooltip,
  });

  @override
  State<_WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<_WindowControlButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovering
        ? (widget.isCloseButton
            ? const Color(0xFFE81123) // Windows close red
            : Colors.black.withValues(alpha: 0.1))
        : Colors.transparent;

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 46,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.isCloseButton && _isHovering
                  ? Colors.white
                  : widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Title bar button for menu and history actions
class _TitleBarButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final Color iconColor;
  final String tooltip;

  const _TitleBarButton({
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    required this.iconColor,
    required this.tooltip,
  });

  @override
  State<_TitleBarButton> createState() => _TitleBarButtonState();
}

class _TitleBarButtonState extends State<_TitleBarButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovering
        ? Colors.black.withValues(alpha: 0.1)
        : Colors.transparent;

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 40,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
