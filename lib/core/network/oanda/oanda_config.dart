class OandaConfig {
  static const String productionUrl = 'https://api-fxtrade.oanda.com';
  static const String sandboxUrl = 'https://api-fxpractice.oanda.com';
  static const String productionStreamUrl = 'wss://stream-fxtrade.oanda.com';
  static const String sandboxStreamUrl = 'wss://stream-fxpractice.oanda.com';

  static const String apiVersion = 'v3';
  static const int timeout = 30000;
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 30000;

  static const String tokenKey = 'oanda_token';
  static const String accountIdKey = 'oanda_account_id';

  static String getBaseUrl(bool isProduction) {
    return isProduction ? productionUrl : sandboxUrl;
  }

  static String getStreamUrl(bool isProduction) {
    return isProduction ? productionStreamUrl : sandboxStreamUrl;
  }

  // Alias for compatibility
  static String get streamBaseUrl => sandboxStreamUrl;
  static String get baseUrl => sandboxUrl;
}
