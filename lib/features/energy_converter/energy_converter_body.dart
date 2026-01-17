import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Energy converter page body
class EnergyConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const EnergyConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 3,
        titleKey: 'energyConverterTitle',
        defaultUnit1: 'Joules',
        defaultUnit2: 'Calories',
        showSignToggle: false,
      ),
    );
  }
}
