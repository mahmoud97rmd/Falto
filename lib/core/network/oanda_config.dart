class OandaConfig {
  static const String productionUrl = 'https://api-fxtrade.oanda.com';
  static const String sandboxUrl = 'https://api-fxpractice.oanda.com';
  static const String productionStreamUrl = 'wss://stream-fxtrade.oanda.com';
  static const String sandboxStreamUrl = 'wss://stream-fxpractice.oanda.com';

  static const String tokenKey = 'oanda_token';
  static const String accountIdKey = 'oanda_account_id';

  static String getBaseUrl(bool isProduction) {
    return isProduction ? productionUrl : sandboxUrl;
  }

  static String getStreamUrl(bool isProduction) {
    return isProduction ? productionStreamUrl : sandboxStreamUrl;
  }
}
