import 'package:equatable/equatable.dart';

class StrategyGraph extends Equatable {
  final String id;
  final String name;
  final Map<String, dynamic> config;
  final List<String> indicators;
  final List<String> conditions;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const StrategyGraph({
    required this.id,
    required this.name,
    required this.config,
    this.indicators = const [],
    this.conditions = const [],
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, config, indicators, conditions, createdAt, updatedAt];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'config': config,
    'indicators': indicators,
    'conditions': conditions,
    'createdAt': createdAt.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };

  factory StrategyGraph.fromJson(Map<String, dynamic> json) => StrategyGraph(
    id: json['id'] as String,
    name: json['name'] as String,
    config: json['config'] as Map<String, dynamic>,
    indicators: (json['indicators'] as List?)?.cast<String>() ?? [],
    conditions: (json['conditions'] as List?)?.cast<String>() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
  );
}
