// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replay_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReplayStateEntityAdapter extends TypeAdapter<ReplayStateEntity> {
  @override
  final typeId = 14;

  @override
  ReplayStateEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReplayStateEntity(
      symbol: fields[0] as String,
      lastIndex: (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReplayStateEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.lastIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplayStateEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
