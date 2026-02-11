// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instrument_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstrumentDto _$InstrumentDtoFromJson(Map<String, dynamic> json) =>
    InstrumentDto(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      type: json['type'] as String,
      pipLocation: (json['pipLocation'] as num).toInt(),
      displayPrecision: (json['displayPrecision'] as num).toInt(),
      tradeUnitsPrecision: (json['tradeUnitsPrecision'] as num).toInt(),
    );

Map<String, dynamic> _$InstrumentDtoToJson(InstrumentDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'type': instance.type,
      'pipLocation': instance.pipLocation,
      'displayPrecision': instance.displayPrecision,
      'tradeUnitsPrecision': instance.tradeUnitsPrecision,
    };
