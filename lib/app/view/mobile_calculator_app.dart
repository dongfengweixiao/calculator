import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_theme/phoenix_theme.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../app_config.dart';
import '../../common/page_ids.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/target_platform_x.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import '../../settings/settings_model.dart';
import 'create_master_items.dart';
import 'mobile_page.dart';
import 'routing_manager.dart';

class MobileCalculatorApp extends StatelessWidget with WatchItMixin {
  const MobileCalculatorApp({super.key, this.accent});

  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final themeIndex = watchPropertyValue((SettingsModel m) => m.themeIndex);
    final useYaruTheme = watchPropertyValue(
      (SettingsModel m) => m.useYaruTheme,
    );

    final phoenix = phoenixTheme(color: accent ?? kCalculatorAppDefaultColor);
    final routingManager = di<RoutingManager>();

    final phoenixLightWithFont = isLinux
        ? phoenix.lightTheme
        : applyChineseFontToPhoenixTheme(
            lightTheme: phoenix.lightTheme,
            darkTheme: phoenix.darkTheme,
          );
    final phoenixDarkWithFont = isLinux
        ? phoenix.darkTheme
        : applyChineseFontToPhoenixDarkTheme(darkTheme: phoenix.darkTheme);

    return MaterialApp(
      navigatorKey: routingManager.masterNavigatorKey,
      navigatorObservers: [routingManager],
      initialRoute: routingManager.selectedPageId ?? PageIDs.standard,
      onGenerateRoute: (settings) {
        final masterItems = getAllMasterItems();
        final page =
            (masterItems.firstWhereOrNull((e) => e.pageId == settings.name) ??
                    masterItems.elementAt(0))
                .pageBuilder(context);

        return PageRouteBuilder(
          settings: settings,
          maintainState: false,
          pageBuilder: (_, _, _) => MobilePage(page: page),
        );
      },
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.values[themeIndex],
      theme: (useYaruTheme && accent != null
          ? yaruLightWithTweaks(createYaruLightTheme(primaryColor: accent!))
          : phoenixLightWithFont),
      darkTheme:
          (useYaruTheme && accent != null
                  ? yaruDarkWithTweaks(
                      createYaruDarkTheme(primaryColor: accent!),
                    )
                  : phoenixDarkWithFont)
              ?.copyWith(
                appBarTheme: phoenix.darkTheme.appBarTheme.copyWith(
                  backgroundColor: Colors.black,
                ),
                colorScheme: phoenix.darkTheme.colorScheme.copyWith(
                  surface: Colors.black,
                ),
                scaffoldBackgroundColor: Colors.black,
              ),
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        WincalcLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      onGenerateTitle: (context) => AppConfig.appTitle,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}
