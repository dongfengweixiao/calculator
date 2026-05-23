import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:github/github.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../app_config.dart';
import '../extensions/target_platform_x.dart';

class AppModel extends SafeChangeNotifier {
  AppModel({required PackageInfo packageInfo, required GitHub gitHub})
    : _countryCode = WidgetsBinding
          .instance
          .platformDispatcher
          .locale
          .countryCode
          ?.toLowerCase(),
      _packageInfo = packageInfo,
      _gitHub = gitHub;

  final String? _countryCode;
  String? get countryCode => _countryCode;

  bool _showWindowControls = true;
  bool get showWindowControls => _showWindowControls;
  void setShowWindowControls(bool value) {
    _showWindowControls = value;
    notifyListeners();
  }

  bool? _fullWindowMode;
  bool? get fullWindowMode => _fullWindowMode;
  Future<void> setFullWindowMode(bool? value) async {
    if (value == null || value == _fullWindowMode) return;
    _fullWindowMode = value;

    if (isMobile) {
      if (_fullWindowMode == true) {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
        await SystemChrome.setPreferredOrientations([]);
      }
    }

    notifyListeners();
  }

  final PackageInfo _packageInfo;
  String get version => _packageInfo.version;

  final GitHub _gitHub;

  Future<List<Contributor>> getContributors() async {
    final list = await _gitHub.repositories
        .listContributors(RepositorySlug.full(AppConfig.gitHubShortLink))
        .where((c) => c.type == 'User')
        .toList();
    return list;
  }
}
