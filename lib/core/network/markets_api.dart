import 'rest_client.dart';

class InstrumentInfo {
  final String name;
  final String displayName;
  final String type;

  InstrumentInfo({
    required this.name,
    required this.displayName,
    required this.type,
  });

  factory InstrumentInfo.fromJson(Map<String, dynamic> json) {
    return InstrumentInfo(
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? json['name'] ?? '',
      type: json['type'] ?? 'CURRENCY',
    );
  }
}

class MarketsApi {
  final RestClient client;

  MarketsApi(this.client);

  Future<List<InstrumentInfo>> fetchAll() async {
    final res = await client.get("/instruments");
    if (res is Map && res['instruments'] != null) {
      return (res['instruments'] as List)
          .map((j) => InstrumentInfo.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
