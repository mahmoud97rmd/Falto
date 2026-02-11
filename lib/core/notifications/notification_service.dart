import 'package:flutter/foundation.dart';

/// Local Notification Service stub - add flutter_local_notifications package when needed
class NotificationService {
  Future<void> init() async {
    // TODO: Add local notifications when needed
  }

  Future<void> show(String title, String body) async {
    // TODO: Show actual notification when flutter_local_notifications is added
    debugPrint('Notification: $title - $body');
  }
}
