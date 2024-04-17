import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:super_clipboard/super_clipboard.dart';

class ClipboardService {
  List<ClipboardData> _clipboardData = [];

  Future<String?> getCurrentClipboardData() async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      return ''; // Clipboard API is not supported on this platform.
    }
    final reader = await clipboard.read();

    if (reader.canProvide(Formats.plainText)) {
      final text = await reader.readValue(Formats.plainText);
      return text;
    }
  }

  List<ClipboardData> getClipboardData() {
    return _clipboardData;
  }

  void addToClipboardData(ClipboardData data) {
    // Add to clipboard data
    _clipboardData.add(data);
  }

  void removeFromClipboardData(ClipboardData data) {
    // Remove from clipboard data
    _clipboardData.remove(data);
  }
}
