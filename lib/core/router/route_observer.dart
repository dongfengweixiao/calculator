import 'package:flutter/material.dart';
import '../services/persistence/preferences_service.dart';

/// Route observer that persists the last visited route
///
/// This observer saves the current route whenever it changes,
/// allowing the app to restore the user's last location on restart.
class PersistenceRouteObserver extends NavigatorObserver {
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _saveRoute(newRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _saveRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _saveRoute(previousRoute);
  }

  /// Save the route if it's a valid route to persist
  void _saveRoute(Route? route) {
    if (route == null) return;

    // Get the route name from settings
    final routeName = route.settings.name;
    if (routeName != null && _isValidRoute(routeName)) {
      PreferencesService.setLastRoute(routeName);
    }
  }

  /// Check if the route is valid to persist
  ///
  /// We don't want to persist error pages or temporary routes
  bool _isValidRoute(String path) {
    // Don't persist 404 or error pages
    if (path == '/404') return false;

    // Don't persist root path
    if (path == '/') return false;

    // All other routes are valid
    return true;
  }
}
