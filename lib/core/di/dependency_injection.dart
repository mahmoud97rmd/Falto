import '../log/logger_service.dart';

class DependencyInjection {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // تسجيل الخدمات الأساسية (مؤقتاً حتى نربط الحقيقي لاحقاً)
    LoggerService.log('DependencyInjection initialized');
  }
}
