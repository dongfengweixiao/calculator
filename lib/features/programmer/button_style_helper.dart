import 'package:flutter/material.dart';

/// Button style utility class for programmer calculator mode
class ButtonStyleHelper {
  /// Get container decoration for base panel buttons
  static BoxDecoration getBaseButtonDecoration({
    required bool isSelected,
    required bool isHovered,
    required Color textColor,
  }) {
    return BoxDecoration(
      color: isSelected
          ? textColor.withValues(alpha: 0.12)
          : (isHovered
              ? textColor.withValues(alpha: 0.05)
              : Colors.transparent),
    );
  }

  /// Get container decoration for control buttons
  static BoxDecoration getControlButtonDecoration({
    required bool isSelected,
    required bool isHovered,
    required Color textColor,
  }) {
    return BoxDecoration(
      color: isSelected
          ? textColor.withValues(alpha: 0.12)
          : (isHovered
              ? textColor.withValues(alpha: 0.05)
              : Colors.transparent),
      borderRadius: BorderRadius.circular(4),
    );
  }
}

