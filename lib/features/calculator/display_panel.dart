import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_font_sizes.dart';
import '../../core/theme/app_colors.dart';

/// Calculator display panel
class DisplayPanel extends ConsumerWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorProvider);
    final theme = ref.watch(calculatorThemeProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      color: theme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Expression display - use Flexible to adapt to available space
          Flexible(
            child: Text(
              calculatorState.expression,
              style: TextStyle(
                fontSize: CalculatorFontSizes.numeric16,
                color: theme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),

          // Main result display - also use Flexible
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                calculatorState.display,
                style: TextStyle(
                  fontSize: CalculatorFontSizes.operatorCaptionExtraLarge,
                  fontWeight: FontWeight.w300,
                  color: calculatorState.hasError
                      ? CalculatorDarkColors.textError
                      : theme.textPrimary,
                ),
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
