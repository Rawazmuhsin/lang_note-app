// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveWordAdapter extends TypeAdapter<HiveWord> {
  @override
  final int typeId = 0;

  @override
  HiveWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveWord(
      id: fields[0] as int,
      langA: fields[1] as String,
      langB: fields[2] as String,
      category: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveWord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.langA)
      ..writeByte(2)
      ..write(obj.langB)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
