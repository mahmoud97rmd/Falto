import 'package:json_annotation/json_annotation.dart';

part 'instrument_dto.g.dart';

@JsonSerializable()
class InstrumentDto {
  final String name;
  final String displayName;
  final String type;
  final int pipLocation;
  final int displayPrecision;
  final int tradeUnitsPrecision;

  InstrumentDto({
    required this.name,
    required this.displayName,
    required this.type,
    required this.pipLocation,
    required this.displayPrecision,
    required this.tradeUnitsPrecision,
  });

  factory InstrumentDto.fromJson(Map<String, dynamic> json) => 
      _$InstrumentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InstrumentDtoToJson(this);
}
