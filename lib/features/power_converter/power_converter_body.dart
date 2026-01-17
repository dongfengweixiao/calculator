import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Power converter page body
class PowerConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const PowerConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 7,
        titleKey: 'powerConverterTitle',
        defaultUnit1: 'Watts',
        defaultUnit2: 'Kilowatts',
        showSignToggle: true,
      ),
    );
  }
}
