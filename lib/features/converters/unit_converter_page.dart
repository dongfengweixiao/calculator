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

  /// Route type identifier (e.g., 'volume', 'temperature')
  final String type;

  const UnitConverterPage({
    super.key,
    required this.config,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wrap UnitConverterBody in a Scaffold without header
    // The header is provided by AppShell
    return Scaffold(
      body: SafeArea(
        child: UnitConverterBody(
          // Use a unique key based on converter type to ensure proper widget recreation
          key: ValueKey('converter_$type'),
          // Menu button not needed in shell layout - provide empty callback
          onMenuPressed: () {},
          config: config,
          converterType: type,
        ),
      ),
    );
  }
}
