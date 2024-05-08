import 'package:flutter/services.dart';
import 'package:hive/hive.dart'; // Importa la classe ClipboardData

class ClipboardDataAdapter extends TypeAdapter<ClipboardData> {
  @override
  final typeId = 2;

  @override
  ClipboardData read(BinaryReader reader) {
    final text = reader.read();
    return ClipboardData(text: text);
  }

  @override
  void write(BinaryWriter writer, ClipboardData obj) {
    writer.write(obj.text);
  }
}
