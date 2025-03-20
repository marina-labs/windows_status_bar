library windows_status_bar;

import 'dart:io';

import 'package:window_manager/window_manager.dart';
export 'windows_status_bar_widget.dart';

class WindowsStatusBar {
  static initialize() async {
    await windowManager.ensureInitialized();
    if (Platform.isWindows) {
      windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    }
  }
}
