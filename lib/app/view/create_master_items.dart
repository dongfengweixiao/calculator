import 'package:flutter/material.dart';

import '../../common/page_ids.dart';
import '../../common/view/icons.dart';
import '../../core/config/converter_configs.dart';
import '../../core/theme/app_icons.dart';
import '../../l10n/l10n.dart';
import '../../features/calculators/standard_calculator_page.dart';
import '../../features/calculators/scientific_calculator_page.dart';
import '../../features/calculators/programmer_calculator_page.dart';
import '../../features/unit_converter/unit_converter_page.dart';
import '../../settings/view/settings_page.dart';
import 'master_item.dart';

Iterable<MasterItem> getAllMasterItems() => [
  ...permanentMasterItems,
  if (settingsMasterItem != null) settingsMasterItem!,
];
Iterable<MasterItem> permanentMasterItems = () {
  // 基础导航项
  final items = <MasterItem>[
    // 计算器标题
    MasterItem(
      titleBuilder: (context) => const Text(
        '计算器',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      iconBuilder: (selected) => const SizedBox(),
      pageBuilder: (_) => Container(),
      pageId: 'calculator_title',
      isTitle: true,
    ),
    MasterItem(
      titleBuilder: (context) => const Text('标准'),
      iconBuilder: (selected) => Icon(CalculatorIcons.standardCalculator),
      pageBuilder: (_) => StandardCalculatorPage(),
      pageId: PageIDs.standard,
    ),
    MasterItem(
      titleBuilder: (context) => const Text('科学'),
      iconBuilder: (selected) => Icon(CalculatorIcons.scientificCalculator),
      pageBuilder: (_) => const ScientificCalculatorPage(),
      pageId: PageIDs.scientific,
    ),
    MasterItem(
      titleBuilder: (context) => const Text('程序员'),
      iconBuilder: (selected) => Icon(CalculatorIcons.programmerCalculator),
      pageBuilder: (_) => const ProgrammerCalculatorPage(),
      pageId: PageIDs.programmer,
    ),
    // 转换器标题
    MasterItem(
      titleBuilder: (context) => const Text(
        '转换器',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      iconBuilder: (selected) => const SizedBox(),
      pageBuilder: (_) => Container(),
      pageId: 'converter_title',
      isTitle: true,
    ),
  ];

  // 添加单位换算类型
    final converterTypes = ConverterConfigs.allTypes;
    for (final type in converterTypes) {
      final config = ConverterConfigs.get(type);
      // 为每个单位换算类型创建一个MasterItem
      items.add(MasterItem(
        titleBuilder: (context) => Text(_getConverterTitle(type)),
        iconBuilder: (selected) => Icon(config.icon),
        pageBuilder: (_) => UnitConverterPage(config: config, type: type),
        pageId: 'converter_$type',
      ));
    }

  return items;
}();

String _getConverterTitle(String type) {
  switch (type) {
    case 'volume':
      return '体积';
    case 'temperature':
      return '温度';
    case 'length':
      return '长度';
    case 'weight':
      return '重量';
    case 'energy':
      return '能量';
    case 'area':
      return '面积';
    case 'speed':
      return '速度';
    case 'time':
      return '时间';
    case 'power':
      return '功率';
    case 'data':
      return '数据';
    case 'pressure':
      return '压力';
    case 'angle':
      return '角度';
    default:
      return type;
  }
}

MasterItem? settingsMasterItem = MasterItem(
  titleBuilder: (context) => Text(context.l10n.settings),
  iconBuilder: (selected) =>
      Icon(selected ? Iconz.settingsFilled : Iconz.settings),
  pageBuilder: (_) => const SettingsPage(),
  pageId: PageIDs.settings,
);