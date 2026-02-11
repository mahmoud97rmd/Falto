enum ServerMode {
  production,
  sandbox,
  development,
  live, // Alias for production
}

extension ServerModeExtension on ServerMode {
  String get baseUrl {
    switch (this) {
      case ServerMode.production:
        return 'https://api-fxtrade.oanda.com';
      case ServerMode.sandbox:
        return 'https://api-fxpractice.oanda.com';
      case ServerMode.development:
        return 'https://api-fxpractice.oanda.com';
      case ServerMode.live:
        return 'https://api-fxtrade.oanda.com';
    }
  }

  String get streamUrl {
    switch (this) {
      case ServerMode.production:
        return 'wss://stream-fxtrade.oanda.com';
      case ServerMode.sandbox:
        return 'wss://stream-fxpractice.oanda.com';
      case ServerMode.development:
        return 'wss://stream-fxpractice.oanda.com';
      case ServerMode.live:
        return 'wss://stream-fxtrade.oanda.com';
    }
  }
}
