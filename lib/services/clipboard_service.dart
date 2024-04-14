import 'package:flutter/services.dart';

class ClipboardService {
  Future<String> getClipboardData() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    return clipboardData?.text ?? '';
  }
}
