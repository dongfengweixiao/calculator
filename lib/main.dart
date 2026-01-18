import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:logging/logging.dart';
import 'l10n/l10n.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/theme_provider.dart';
import 'shared/locale/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/persistence/preferences_service.dart';
import 'core/config/logger_config.dart';
import 'utils/device_utils.dart';

// Conditional import for window_manager (desktop only)
import 'package:window_manager/window_manager.dart' show WindowOptions, windowManager, TitleBarStyle;

// Global logger for main
final log = Logger('main');

// Check if current platform is desktop
bool get isDesktop => !Platform.isAndroid && !Platform.isIOS;

void main() async {
  // Configure logging first
  configureLogging();
  log.info('Application starting on ${Platform.operatingSystem}...');

  // Run app with error handling in a zone
  runZonedGuarded(
    () async {
      // Initialize Flutter bindings inside the zone
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize window manager only on desktop platforms
      if (isDesktop) {
        await windowManager.ensureInitialized();

        // Set window options
        WindowOptions windowOptions = WindowOptions(
          minimumSize: const Size(340, 560),
          titleBarStyle: TitleBarStyle.hidden, // Hide system title bar for custom title bar
        );

        windowManager.waitUntilReadyToShow(windowOptions, () async {
          await windowManager.show();
          await windowManager.focus();
        });
      }

      // Initialize preferences service
      await PreferencesService.init();

      // Set system UI overlay style and screen orientation for Android/iOS
      if (Platform.isAndroid || Platform.isIOS) {
        // Set screen orientation based on device type
        // Phone: portrait only, Tablet: allow all orientations
        if (DeviceUtils.isTabletDevice()) {
          log.info('Tablet detected: allowing all orientations');
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          log.info('Phone detected: locking to portrait');
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        }

        // Set system UI overlay to make status bar transparent and push content down
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Transparent status bar
            statusBarIconBrightness: Brightness.dark, // Dark icons for light status bar
            statusBarBrightness: Brightness.light, // iOS: Light status bar content
            systemNavigationBarColor: Colors.black, // Bottom nav bar color
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );

        // Ensure content is drawn behind the status bar but safe areas are respected
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
        );
      }

      // Run app in the same zone
      runApp(const ProviderScope(child: CalculatorApp()));
    },
    (Object error, StackTrace stack) {
      // Catch all uncaught exceptions
      log.severe('Uncaught app exception', error, stack);
    },
  );
}

class CalculatorApp extends ConsumerWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(flutterThemeModeProvider);
    final locale = ref.watch(resolvedLocaleProvider);

    return MaterialApp.router(
      title: 'WinCalc',
      debugShowCheckedModeBanner: false,
      theme: themeState.theme.toThemeData().useSystemChineseFont(themeState.theme.brightness),
      darkTheme: themeState.theme.toThemeData().useSystemChineseFont(themeState.theme.brightness),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      routerConfig: router,
    );
  }
}
