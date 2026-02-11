// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candle_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCandleAdapter extends TypeAdapter<HiveCandle> {
  @override
  final typeId = 1;

  @override
  HiveCandle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCandle(
      time: (fields[0] as num).toInt(),
      open: (fields[1] as num).toDouble(),
      high: (fields[2] as num).toDouble(),
      low: (fields[3] as num).toDouble(),
      close: (fields[4] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveCandle obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.open)
      ..writeByte(2)
      ..write(obj.high)
      ..writeByte(3)
      ..write(obj.low)
      ..writeByte(4)
      ..write(obj.close);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCandleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
