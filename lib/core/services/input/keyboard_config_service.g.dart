// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keyboard configuration provider
///
/// Provides keyboard shortcuts configuration

@ProviderFor(KeyboardConfigService)
final keyboardConfigServiceProvider = KeyboardConfigServiceProvider._();

/// Keyboard configuration provider
///
/// Provides keyboard shortcuts configuration
final class KeyboardConfigServiceProvider
    extends $NotifierProvider<KeyboardConfigService, List<KeyboardShortcut>> {
  /// Keyboard configuration provider
  ///
  /// Provides keyboard shortcuts configuration
  KeyboardConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardConfigServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyboardConfigServiceHash();

  @$internal
  @override
  KeyboardConfigService create() => KeyboardConfigService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<KeyboardShortcut> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<KeyboardShortcut>>(value),
    );
  }
}

String _$keyboardConfigServiceHash() =>
    r'35ff010001a7d8c1d68c30ac9c457b173ea823c1';

/// Keyboard configuration provider
///
/// Provides keyboard shortcuts configuration

abstract class _$KeyboardConfigService
    extends $Notifier<List<KeyboardShortcut>> {
  List<KeyboardShortcut> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<KeyboardShortcut>, List<KeyboardShortcut>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<KeyboardShortcut>, List<KeyboardShortcut>>,
              List<KeyboardShortcut>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
