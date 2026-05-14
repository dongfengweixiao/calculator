import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

import '../../common/view/header_bar.dart';
import '../../core/config/converter_configs.dart';
import '../../core/services/unit_converter_service.dart';
import '../calculators/widgets/calculator_converter_operators.dart';
import 'widgets/converter_display.dart';
import 'widgets/suggested_units.dart';
import 'widgets/unit_selector_row.dart';

/// 单位换算页面
class UnitConverterPage extends StatefulWidget {
  /// 单位换算配置
  final UnitConverterConfig config;

  /// 转换器类型
  final String type;

  const UnitConverterPage({
    super.key,
    required this.config,
    required this.type,
  });

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  final _service = UnitConverterService();

  /// 当前选中的是 RowDisplay1（true）还是 RowDisplay2（false）
  bool _isFromSelected = true;

  /// 引擎方向是否已反转（from/to 是否已交换）
  bool _engineIsReversed = false;

  @override
  void initState() {
    super.initState();
    _service.initialize(categoryId: widget.config.categoryId);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  /// 将引擎的 from/to 方向同步为当前选中状态
  void _syncEngine() {
    final shouldReverse = !_isFromSelected;
    if (shouldReverse != _engineIsReversed) {
      _service.switchActive(_service.getFromValue());
      _engineIsReversed = shouldReverse;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WincalcLocalizations.of(context);
    _service.setLocale(l10n);

    final category = _service.currentCategory;
    final units = category?.units ?? [];

    return Scaffold(
      appBar: HeaderBar(adaptive: true, title: const Text('单位换算')),
      body: LayoutGrid(
        columnSizes: [1.fr],
        rowSizes: [
          56.fr, // RowDisplay1
          32.fr, // RowUnit1
          56.fr, // RowDisplay2
          32.fr, // RowUnit2
          48.fr, // RowDltrUnits
          272.fr, // RowNumPad
        ],
        columnGap: 0,
        rowGap: 0,
        children: [
          // RowDisplay1 — 选中时为输入，未选中时为输出
          ConverterDisplay(
            value: _engineIsReversed
                ? _service.getToValue()
                : _service.getFromValue(),
            isSelected: _isFromSelected,
            onTap: () => setState(() => _isFromSelected = true),
          ).withGridPlacement(columnStart: 0, rowStart: 0),
          // RowUnit1
          UnitSelectorRow(
            selectedUnit: _engineIsReversed
                ? _service.toUnit
                : _service.fromUnit,
            units: units,
            onUnitChanged: (unit) {
              setState(() {
                if (!_engineIsReversed) {
                  _service.setUnits(
                    fromUnitId: unit.id,
                    toUnitId: _service.toUnit?.id ?? unit.id,
                  );
                } else {
                  _service.setUnits(
                    fromUnitId: _service.fromUnit?.id ?? unit.id,
                    toUnitId: unit.id,
                  );
                }
              });
            },
          ).withGridPlacement(columnStart: 0, rowStart: 1),
          // RowDisplay2 — 选中时为输入，未选中时为输出
          ConverterDisplay(
            value: _engineIsReversed
                ? _service.getFromValue()
                : _service.getToValue(),
            isSelected: !_isFromSelected,
            onTap: () => setState(() => _isFromSelected = false),
          ).withGridPlacement(columnStart: 0, rowStart: 2),
          // RowUnit2
          UnitSelectorRow(
            selectedUnit: _engineIsReversed
                ? _service.fromUnit
                : _service.toUnit,
            units: units,
            onUnitChanged: (unit) {
              setState(() {
                if (!_engineIsReversed) {
                  _service.setUnits(
                    fromUnitId: _service.fromUnit?.id ?? unit.id,
                    toUnitId: unit.id,
                  );
                } else {
                  _service.setUnits(
                    fromUnitId: unit.id,
                    toUnitId: _service.toUnit?.id ?? unit.id,
                  );
                }
              });
            },
          ).withGridPlacement(columnStart: 0, rowStart: 3),
          // RowDltrUnits — 趣味换算建议
          SuggestedUnits(
            suggestions: _service.getSuggestedValues(),
          ).withGridPlacement(columnStart: 0, rowStart: 4),
          // RowNumPad - 替换为 CalculatorConverterOperators
          CalculatorConverterOperators(
            onDigit: (digit) {
              setState(() {
                _syncEngine();
                _service.sendDigit(digit);
              });
            },
            onDecimal: () {
              setState(() {
                _syncEngine();
                _service.sendDecimal();
              });
            },
            onNegate: () {
              setState(() {
                _syncEngine();
                _service.sendNegate();
              });
            },
            showNegate: widget.config.showSignToggle,
          ).withGridPlacement(columnStart: 0, rowStart: 5),
        ],
      ),
    );
  }
}
