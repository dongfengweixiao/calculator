/// Helper class to add emoji icons to whimsical units based on Unit ID
class UnitIcons {
  /// Mapping of Unit IDs to their emoji icons
  /// Based on: wincalc_engine/src/unit_icons.dart
  /// Unit IDs must match the IDs defined in calc_manager_wrapper.cpp
  static const Map<int, String> _icons = {
    // Length units (category 0)
    129: '🍌', // Banana
    130: '🎂', // Cake
    180: '📎', // Paperclips
    181: '👋', // Hands
    182: '✈️', // Jumbo jets
    // Weight and Mass whimsical units
    280: '❄️', // Snowflakes
    281: '⚽', // Soccer balls
    282: '🐘', // Elephants
    283: '🐳', // Whales
    // Energy whimsical units
    480: '🔋', // Batteries
    481: '🍌', // Bananas
    482: '🍰', // Slice of cake
    // Area whimsical units
    580: '👋', // Hands
    581: '📄', // Papers
    582: '🏟', // Soccer fields
    583: '🏰', // Castles
    584: '🏠', // Pyeong
    // Speed whimsical units
    680: '🐢', // Turtles
    681: '🐴', // Horses
    682: '✈️', // Jets
    // Power whimsical units
    780: '💡', // Light bulbs
    781: '🐴', // Horses
    782: '🚂', // Train engines
    // Data whimsical units
    880: '💾', // Floppy disks
    881: '💿', // CDs
    882: '📀', // DVDs
    // Volume whimsical units
    1220: '☕', // CoffeeCup (Metric cup)
    1221: '🛁', // Bathtub
    1222: '🏊', // SwimmingPool
  };

  /// Get the emoji icon for a unit ID
  /// Returns empty string if no icon is defined for the unit
  static String getIcon(int unitId) {
    return _icons[unitId] ?? '';
  }

  /// Format a suggested value with its icon if available
  /// Example: "☕ 4.23 Metric cups" or just "4.23 Liters" (no icon)
  static String formatWithIcon(String value, String unit, int unitId) {
    final icon = getIcon(unitId);
    if (icon.isEmpty) {
      return '$value $unit';
    }
    return '$icon $value $unit';
  }

  /// Check if a unit is whimsical (has an icon)
  static bool isWhimsical(int unitId) {
    return _icons.containsKey(unitId);
  }
}
