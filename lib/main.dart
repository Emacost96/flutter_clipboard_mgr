import 'package:flutter/material.dart';
import 'package:flutter_clipboard_mgr/classes/clipboard_data_adapter.dart';
import 'package:flutter_clipboard_mgr/classes/extended_clipboard_data.dart';

import 'package:flutter_clipboard_mgr/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ExtendedClipboardDataAdapter());
  Hive.registerAdapter(ClipboardDataAdapter());
  await Hive.openBox('clipboardBox');

  //open the box

  WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 500),
      maximumSize: Size(800, 500),
      minimumSize: Size(800, 500),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Colors.transparent,
      windowButtonVisibility: false);

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
