import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Area converter page body
class AreaConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const AreaConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 4,
        titleKey: 'areaConverterTitle',
        defaultUnit1: 'Square meters',
        defaultUnit2: 'Square kilometers',
        showSignToggle: false,
      ),
    );
  }
}
