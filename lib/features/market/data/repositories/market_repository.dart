import '../../domain/repositories/market_repository.dart';

class MarketRepositoryImpl extends MarketRepository {
  @override
  Future<List<String>> getMarkets() async {
    return ['EUR/USD', 'BTC/USD'];
  }
}
