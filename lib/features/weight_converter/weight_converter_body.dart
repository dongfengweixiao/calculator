import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Weight converter page body
class WeightConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const WeightConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 1,
        titleKey: 'weightConverterTitle',
        defaultUnit1: 'Kilograms',
        defaultUnit2: 'Grams',
        showSignToggle: false,
      ),
    );
  }
}
