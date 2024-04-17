import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:super_clipboard/super_clipboard.dart';

class ClipboardService {
  // Clipboard data
  List<ClipboardData> _clipboardData = [];

  List<ClipboardData> get clipboardData => _clipboardData;

  Future<String?> getCurrentClipboardData() async {
    // Get current clipboard data
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      return ''; // Clipboard API is not supported on this platform.
    }
    final reader = await clipboard.read();

    if (reader.canProvide(Formats.plainText)) {
      final text = await reader.readValue(Formats.plainText);
      return text;
    }
    return null;
  }

  List<ClipboardData> getClipboardData() {
    // Get clipboard data
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

  void clearClipboardData() {
    // Clear clipboard data
    _clipboardData.clear();
  }

  void copyToClipboard(ClipboardData data) {
    // Copy text to clipboard
    Clipboard.setData(ClipboardData(text: data.text ?? ''));

    removeFromClipboardData(data);
  }

  List<ClipboardData> getFilteredClipboardData(String query) {
    return _clipboardData
        .where((item) => item.text!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
