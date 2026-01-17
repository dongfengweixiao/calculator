import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Speed converter page body
class SpeedConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const SpeedConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 5,
        titleKey: 'speedConverterTitle',
        defaultUnit1: 'Meters per second',
        defaultUnit2: 'Kilometers per hour',
        showSignToggle: false,
      ),
    );
  }
}
