import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/theme.dart';
import '../../extensions/target_platform_x.dart';
import '../../settings/settings_model.dart';
import 'desktop_calculator_app.dart';
import 'mobile_calculator_app.dart';

class YaruCalculatorApp extends StatelessWidget with WatchItMixin {
  const YaruCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final useCustomThemeColor = watchPropertyValue(
      (SettingsModel m) => m.useCustomThemeColor,
    );
    final customThemeColor = watchPropertyValue(
      (SettingsModel m) => m.customThemeColor,
    );

    final useYaruTheme = watchPropertyValue(
      (SettingsModel m) => m.useYaruTheme,
    );

    return YaruTheme(
      builder: (context, yaru, child) {
        final color = customThemeColor != null && useCustomThemeColor
            ? Color(customThemeColor)
            : yaru.theme.colorScheme.primary;

        final yaruLightFlavor = createYaruLightTheme(primaryColor: color);
        final yaruDarkFlavor = createYaruDarkTheme(primaryColor: color);

        return DesktopCalculatorApp(
          highContrastTheme: yaruHighContrastLight,
          highContrastDarkTheme: yaruHighContrastDark,
          accent: color,
          lightTheme: useYaruTheme
              ? yaruLightWithTweaks(yaruLightFlavor)
              : null,
          darkTheme: useYaruTheme ? yaruDarkWithTweaks(yaruDarkFlavor) : null,
        );
      },
    );
  }
}

class MaterialCalculatorApp extends StatelessWidget with WatchItMixin {
  const MaterialCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final useCustomThemeColor = watchPropertyValue(
      (SettingsModel m) => m.useCustomThemeColor,
    );
    final customThemeColor = watchPropertyValue(
      (SettingsModel m) => m.customThemeColor,
    );

    return SystemThemeBuilder(
      builder: (context, accent) {
        final color = customThemeColor != null && useCustomThemeColor
            ? Color(customThemeColor)
            : accent.accent;

        return isMobile
            ? MobileCalculatorApp(accent: color)
            : DesktopCalculatorApp(accent: color);
      },
    );
  }
}
