import 'dart:io';
import 'dart:async';

enum NetworkErrorType {
  noConnection,
  timeout,
  serverError,
  unknown
}

class NetworkErrorHandler {
  static NetworkErrorType classify(dynamic error) {
    if (error is SocketException) {
      return NetworkErrorType.noConnection;
    } else if (error is TimeoutException) {
      return NetworkErrorType.timeout;
    } else if (error.toString().contains('500')) {
      return NetworkErrorType.serverError;
    }
    return NetworkErrorType.unknown;
  }

  static String message(NetworkErrorType type) {
    switch (type) {
      case NetworkErrorType.noConnection:
        return "No internet connection.";
      case NetworkErrorType.timeout:
        return "Connection timed out.";
      case NetworkErrorType.serverError:
        return "Server error occurred.";
      case NetworkErrorType.unknown:
        return "An unexpected network error occurred.";
    }
  }
}
