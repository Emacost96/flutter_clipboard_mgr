import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:super_clipboard/super_clipboard.dart';

part 'extended_clipboard_data.g.dart';

@HiveType(typeId: 1)
class ExtendedClipboardData {
  ExtendedClipboardData({
    required this.clipboardData,
    this.date,
    this.image,
    this.url,
    this.copiedCount = 0,
    required this.format,
  });

  /// The clipboard data.
  @HiveField(0)
  ClipboardData clipboardData;

  @HiveField(1)
  int copiedCount = 0;

  /// The date and time when the clipboard data was captured.
  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  String format;

  /// The image data, if available.
  @HiveField(4)
  Uint8List? image;

  @HiveField(5)
  String? url;
}
