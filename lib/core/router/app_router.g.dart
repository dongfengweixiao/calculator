// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Application router configuration
///
/// Uses go_router with a ShellRoute to provide a consistent layout
/// across all pages. The shell includes the sidebar navigation and header.
///
/// Page transitions are disabled to prevent visual overlap artifacts.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Application router configuration
///
/// Uses go_router with a ShellRoute to provide a consistent layout
/// across all pages. The shell includes the sidebar navigation and header.
///
/// Page transitions are disabled to prevent visual overlap artifacts.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Application router configuration
  ///
  /// Uses go_router with a ShellRoute to provide a consistent layout
  /// across all pages. The shell includes the sidebar navigation and header.
  ///
  /// Page transitions are disabled to prevent visual overlap artifacts.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'28558a50fd7f03d1400cfd3888c518343e38a1da';
