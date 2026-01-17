import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Length converter page body
class LengthConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const LengthConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 0,
        titleKey: 'lengthConverterTitle',
        defaultUnit1: 'Meters',
        defaultUnit2: 'Kilometers',
        showSignToggle: false,
      ),
    );
  }
}
