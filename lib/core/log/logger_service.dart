class LoggerService {
  static bool _enabled = true;

  static void init() {
    log('LoggerService initialized');
  }

  static void log(String message) {
    if (_enabled) {
      print('[LOG] $message');
    }
  }

  static void error(String message, [Object? e]) {
    print('[ERROR] $message ${e ?? ""}');
  }
}
