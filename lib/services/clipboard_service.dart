import 'package:super_clipboard/super_clipboard.dart';

class ClipboardService {
  Future<String?> getClipboardData() async {
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

  void ListenToCopyEvents() {
    registerCopEventListner((String text) {
      print('Copied text: $text');
    });
  }
}
