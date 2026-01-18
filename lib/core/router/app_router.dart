import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import '../shell/app_shell.dart';
import '../../features/calculators/standard_calculator_page.dart';
import '../../features/calculators/scientific_calculator_page.dart';
import '../../features/calculators/programmer_calculator_page.dart';
import '../../features/calculators/date_calculation_page.dart';
import '../../features/converters/unit_converter_page.dart';
import '../../features/settings/settings_page.dart';
import '../../core/config/converter_configs.dart';
import '../../core/services/persistence/preferences_service.dart';
import 'route_observer.dart' as router;

part 'app_router.g.dart';

/// Helper function to create a no-transition page
///
/// Disables page transitions to prevent visual overlap artifacts
Page<T> _noTransitionPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

/// Application router configuration
///
/// Uses go_router with a ShellRoute to provide a consistent layout
/// across all pages. The shell includes the sidebar navigation and header.
///
/// Page transitions are disabled to prevent visual overlap artifacts.
///
/// The router persists the last visited route and restores it on app restart.
@riverpod
GoRouter appRouter(Ref ref) {
  // Get the last visited route or use default
  final lastRoute = PreferencesService.getLastRoute() ?? '/standard';

  return GoRouter(
    initialLocation: lastRoute,
    debugLogDiagnostics: true,
    observers: [router.PersistenceRouteObserver()],
    // Listen to route changes and persist the current route
    redirect: (context, state) {
      final path = state.uri.path;
      if (path.isNotEmpty && path != '/' && path != '/404' && path != '/settings') {
        // Persist the current route asynchronously (don't await)
        PreferencesService.setLastRoute(path);
      }
      return null; // No redirection
    },
    routes: [
      /// Shell route provides the unified app layout
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          // ====================================================================
          // Calculator Routes
          // ====================================================================

          /// Standard calculator
          GoRoute(
            path: '/standard',
            name: 'standard',
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const StandardCalculatorPage(),
            ),
          ),

          /// Scientific calculator
          GoRoute(
            path: '/scientific',
            name: 'scientific',
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const ScientificCalculatorPage(),
            ),
          ),

          /// Programmer calculator
          GoRoute(
            path: '/programmer',
            name: 'programmer',
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const ProgrammerCalculatorPage(),
            ),
          ),

          /// Date calculation
          GoRoute(
            path: '/date-calculation',
            name: 'dateCalculation',
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const DateCalculationPage(),
            ),
          ),

          // ====================================================================
          // Converter Routes (dynamic based on type parameter)
          // ====================================================================

          /// Unit converter - generic route for all converter types
          GoRoute(
            path: '/converter/:type',
            name: 'converter',
            pageBuilder: (context, state) {
              final type = state.pathParameters['type']!;
              final config = ConverterConfigs.all[type];

              // If configuration doesn't exist, return to 404
              if (config == null) {
                return _noTransitionPage(
                  key: state.pageKey,
                  child: const _NotFoundPage(),
                );
              }

              // Use the generic UnitConverterPage with unique key based on type
              // This ensures each converter type gets a fresh widget instance
              return _noTransitionPage(
                key: ValueKey('converter_$type'),
                child: UnitConverterPage(
                  config: config,
                  type: type,
                ),
              );
            },
          ),

          // ====================================================================
          // Settings
          // ====================================================================

          /// Settings page
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const SettingsPage(),
            ),
          ),
        ],
      ),

      // ====================================================================
      // Error Handling
      // ====================================================================

      /// 404 Not Found page
      GoRoute(
        path: '/404',
        name: 'notFound',
        pageBuilder: (context, state) => _noTransitionPage(
          key: state.pageKey,
          child: const _NotFoundPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const _NotFoundPage(),
  );
}

/// 404 Not Found page
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            const Text('页面未找到'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/standard'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}
