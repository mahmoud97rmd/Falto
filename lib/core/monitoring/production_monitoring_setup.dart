import 'dart:ui';
import 'package:flutter/widgets.dart';

/// Production monitoring stub - replace with actual Sentry integration when needed
class ProductionMonitoring {
  static Future<void> init({
    required String dsn,
    bool enablePerformance = true,
  }) async {
    // TODO: Add Sentry integration when needed
    // await SentryFlutter.init(...)
  }
}

void setupGlobalErrorHandler() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // TODO: Send to monitoring service
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // TODO: Send to monitoring service
    return true;
  };
}
