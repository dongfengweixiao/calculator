import 'package:flutter/material.dart';

class MasterItem {
  MasterItem({
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.pageBuilder,
    required this.iconBuilder,
    required this.pageId,
    this.isTitle = false,
  });

  final WidgetBuilder titleBuilder;
  final WidgetBuilder? subtitleBuilder;
  final WidgetBuilder pageBuilder;
  final Widget Function(bool selected) iconBuilder;
  final String pageId;
  final bool isTitle;
}
