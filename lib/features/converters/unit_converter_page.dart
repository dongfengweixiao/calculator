import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Generic unit converter page
///
/// This page provides a unified interface for all 12 unit converters.
/// It wraps the [UnitConverterBody] component without the header,
/// as the header is now provided by the AppShell.
///
/// Supported converter types (configured via ConverterConfigs):
/// - Volume, Temperature, Length, Weight, Energy, Area
/// - Speed, Time, Power, Data, Pressure, Angle
class UnitConverterPage extends ConsumerWidget {
  /// Configuration for this converter instance
  final UnitConverterConfig config;

  const UnitConverterPage({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wrap UnitConverterBody in a Scaffold without header
    // The header is provided by AppShell
    return Scaffold(
      body: SafeArea(
        child: UnitConverterBody(
          // Menu button not needed in shell layout - provide empty callback
          onMenuPressed: () {},
          config: config,
        ),
      ),
    );
  }
}
