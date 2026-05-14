import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../extensions/target_platform_x.dart';
import 'app.dart';
import 'splash_screen.dart';

final ValueNotifier<UniqueKey> appRestartNotifier = ValueNotifier(UniqueKey());

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  late final Future<void> _allReady;

  @override
  void initState() {
    super.initState();
    _allReady = di.allReady();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: appRestartNotifier,
    builder: (context, value, child) {
      return FutureBuilder(
        future: _allReady,
        builder: (context, snapshot) => snapshot.hasError
            ? SplashScreen(body: Center(child: Text(snapshot.error.toString())))
            : snapshot.hasData
            ? isLinux
                  ? const YaruCalculatorApp()
                  : const MaterialCalculatorApp()
            : const SplashScreen(),
      );
    },
  );
}
