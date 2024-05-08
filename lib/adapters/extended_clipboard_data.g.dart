// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extended_clipboard_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtendedClipboardDataAdapter extends TypeAdapter<ExtendedClipboardData> {
  @override
  final int typeId = 1;

  @override
  ExtendedClipboardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtendedClipboardData(
      clipboardData: fields[0] as ClipboardData,
      date: fields[2] as DateTime?,
      image: fields[4] as Uint8List?,
      url: fields[5] as String?,
      copiedCount: fields[1] as int,
      format: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExtendedClipboardData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.clipboardData)
      ..writeByte(1)
      ..write(obj.copiedCount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.format)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtendedClipboardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
