import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Time converter page body
class TimeConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const TimeConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 6,
        titleKey: 'timeConverterTitle',
        defaultUnit1: 'Seconds',
        defaultUnit2: 'Minutes',
        showSignToggle: false,
      ),
    );
  }
}
