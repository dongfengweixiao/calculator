import 'package:flutter/widgets.dart';

/// Device utility functions
class DeviceUtils {
  /// Check if device is a tablet based on screen size
  /// Returns true if the shortest side is >= 600dp (Android tablet threshold)
  ///
  /// This function uses platformDispatcher and can be called before
  /// a BuildContext is available (e.g., in main()).
  static bool isTabletDevice() {
    // Get the physical screen size
    final window = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalSize = window.physicalSize;
    final devicePixelRatio = window.devicePixelRatio;

    // Calculate logical size
    final logicalWidth = physicalSize.width / devicePixelRatio;
    final logicalHeight = physicalSize.height / devicePixelRatio;
    final shortestSide = logicalWidth < logicalHeight ? logicalWidth : logicalHeight;

    // Android defines a tablet as having at least 600dp on the shortest side
    return shortestSide >= 600;
  }

  /// Check if device is a phone based on screen size
  /// Returns true if the shortest side is < 600dp
  static bool isPhoneDevice() {
    return !isTabletDevice();
  }
}
