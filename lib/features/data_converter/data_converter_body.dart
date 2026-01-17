import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Data converter page body
class DataConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const DataConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 8,
        titleKey: 'dataConverterTitle',
        defaultUnit1: 'Megabytes',
        defaultUnit2: 'Gigabytes',
        showSignToggle: false,
      ),
    );
  }
}
