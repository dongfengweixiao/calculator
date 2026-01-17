import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Pressure converter page body
class PressureConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const PressureConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 9,
        titleKey: 'pressureConverterTitle',
        defaultUnit1: 'Pascals',
        defaultUnit2: 'Bars',
        showSignToggle: false,
      ),
    );
  }
}
