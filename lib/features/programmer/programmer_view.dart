import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import '../../shared/theme/theme_provider.dart';
import '../../l10n/l10n.dart';
import '../calculator/navigation_drawer.dart';
import '../calculator/calculator_provider.dart';
import '../../core/theme/app_font_sizes.dart';
import '../../core/theme/app_colors.dart';
import 'programmer_provider.dart';
import 'button_panel.dart';
import 'base_conversion_panel.dart';
import 'word_size_panel.dart';

/// Programmer Calculator View
class ProgrammerView extends ConsumerStatefulWidget {
  const ProgrammerView({super.key});

  @override
  ConsumerState<ProgrammerView> createState() => _ProgrammerViewState();
}

class _ProgrammerViewState extends ConsumerState<ProgrammerView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final calculatorState = ref.watch(calculatorProvider);
    final programmerState = ref.watch(programmerProvider);

    // Update programmer base values when calculator display changes
    ref.listen<CalculatorState>(calculatorProvider, (previous, next) {
      // Only update when display actually changes
      if (previous != null &&
          previous.display != next.display &&
          !next.hasError &&
          next.display.isNotEmpty) {
        ref.read(programmerProvider.notifier).updateValuesFromCalculator();
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: const CalculatorNavigationDrawer(),
      body: Column(
        children: [
          // Header with hamburger button and mode name
          _buildHeader(theme),

          // Display area
          _DisplayArea(
            calculatorState: calculatorState,
            theme: theme,
          ),

          // Base conversion panel
          BaseConversionPanel(
            theme: theme,
            programmerState: programmerState,
            onBaseSelected: (base) => _handleBaseSelected(base),
          ),

          // Word size and input mode panel
          WordSizeAndModePanel(
            theme: theme,
            programmerState: programmerState,
            onModeToggle: () {
              ref.read(programmerProvider.notifier).toggleInputMode();
            },
            onWordSizeCycle: () {
              ref.read(programmerProvider.notifier).cycleWordSize();
            },
          ),

          // Operation panel
          Expanded(
            child: const ProgrammerButtonPanel(),
          ),
        ],
      ),
    );
  }

  /// Handle base selection (HEX/DEC/OCT/BIN)
  void _handleBaseSelected(ProgrammerBase base) {
    // Update programmer provider state
    ref.read(programmerProvider.notifier).setCurrentBase(base);

    // Set the calculator engine radix to enable proper digit input
    final calculator = ref.read(calculatorProvider.notifier);
    switch (base) {
      case ProgrammerBase.hex:
        calculator.setRadix(CalcRadixType.CALC_RADIX_HEX);
        break;
      case ProgrammerBase.dec:
        calculator.setRadix(CalcRadixType.CALC_RADIX_DECIMAL);
        break;
      case ProgrammerBase.oct:
        calculator.setRadix(CalcRadixType.CALC_RADIX_OCTAL);
        break;
      case ProgrammerBase.bin:
        calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY);
        break;
    }
  }

  /// Build header widget
  Widget _buildHeader(dynamic calculatorTheme) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Hamburger button and mode name
          _buildHamburgerButton(calculatorTheme),
          const Spacer(),
          // Theme toggle button
          _HeaderButton(
            icon: calculatorTheme.brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            theme: calculatorTheme,
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  /// Build hamburger button
  Widget _buildHamburgerButton(dynamic calculatorTheme) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 8, right: 16),
          color: calculatorTheme.background,
          child: Row(
            children: [
              // Hamburger button
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu,
                  color: calculatorTheme.textPrimary,
                  size: 20,
                ),
              ),
              // Mode name
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  context.l10n.programmerMode,
                  style: TextStyle(
                    color: calculatorTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Display area widget
class _DisplayArea extends StatelessWidget {
  final CalculatorState calculatorState;
  final dynamic theme;

  const _DisplayArea({
    required this.calculatorState,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expression display
          if (calculatorState.expression.isNotEmpty)
            Text(
              calculatorState.expression,
              style: TextStyle(
                fontSize: CalculatorFontSizes.numeric16,
                color: theme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          const SizedBox(height: 4),
          // Main result display
          FittedBox(
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
        ],
      ),
    );
  }
}

/// Header button widget
class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final dynamic theme;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.textPrimary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(widget.icon, color: widget.theme.textSecondary, size: 18),
        ),
      ),
    );
  }
}
