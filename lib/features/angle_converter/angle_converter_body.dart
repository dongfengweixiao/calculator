import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Angle converter page body
class AngleConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const AngleConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 10,
        titleKey: 'angleConverterTitle',
        defaultUnit1: 'Degrees',
        defaultUnit2: 'Radians',
        showSignToggle: true,
      ),
    );
  }
}
