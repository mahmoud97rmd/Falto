// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_cache_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartCacheEntityAdapter extends TypeAdapter<ChartCacheEntity> {
  @override
  final typeId = 50;

  @override
  ChartCacheEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartCacheEntity(
      symbol: fields[0] as String,
      timeframe: fields[1] as String,
      candles: (fields[2] as List).cast<CandleEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChartCacheEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.timeframe)
      ..writeByte(2)
      ..write(obj.candles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartCacheEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
