import 'package:flutter/material.dart';
import '../di/dependency_injection.dart';
import '../log/logger_service.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // تهيئة الـ DI
    await DependencyInjection.init();

    // تهيئة اللوجر
    LoggerService.init();

    // هنا لاحقاً يمكن إضافة:
    // - Firebase.init()
    // - Hive.init()
    // - SecureStorage.init()
  }
}
