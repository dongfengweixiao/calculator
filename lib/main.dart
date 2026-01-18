import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:logging/logging.dart';
import 'l10n/l10n.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/persistence/preferences_service.dart';
import 'core/config/logger_config.dart';

// Global logger for main
final log = Logger('main');

void main() async {
  // Configure logging first
  configureLogging();
  log.info('Application starting...');

  // Run app with error handling in a zone
  runZonedGuarded(
    () async {
      // Initialize Flutter bindings inside the zone
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize window manager
      await windowManager.ensureInitialized();

      // Initialize preferences service
      await PreferencesService.init();

      // Set window options
      WindowOptions windowOptions = WindowOptions(
        minimumSize: const Size(340, 560),
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });

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

    return MaterialApp.router(
      title: 'WinCalc',
      debugShowCheckedModeBanner: false,
      theme: themeState.theme.toThemeData().useSystemChineseFont(themeState.theme.brightness),
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
