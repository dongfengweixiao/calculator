import 'package:flutter/material.dart';

import '../../../core/services/unit_converter_service.dart';
import '../../../core/theme/app_icons.dart';

/// 单位选择器行组件
///
/// 使用 DropdownButton 显示当前选中的单位，点击展开可选单位列表。
/// 数据来源于 wincalc_engine 提供的 [ConverterUnit] 列表，
/// 单位名称已由 [UnitConverterService] 完成本地化。
class UnitSelectorRow extends StatelessWidget {
  /// 当前选中的单位
  final ConverterUnit? selectedUnit;

  /// 当前类别的所有可选单位列表
  final List<ConverterUnit> units;

  /// 单位变更回调
  final ValueChanged<ConverterUnit> onUnitChanged;

  const UnitSelectorRow({
    super.key,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: DropdownButton<ConverterUnit>(
        value: selectedUnit,
        isExpanded: true,
        isDense: true,
        underline: const SizedBox(),
        icon: Icon(
          CalculatorIcons.downArrow,
          size: 20,
          color: theme.colorScheme.onSurface,
        ),
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface,
        ),
        items: units.map((unit) {
          return DropdownMenuItem<ConverterUnit>(
            value: unit,
            child: Text(unit.localizedName),
          );
        }).toList(),
        onChanged: (unit) {
          if (unit != null && unit != selectedUnit) {
            onUnitChanged(unit);
          }
        },
      ),
    );
  }
}
