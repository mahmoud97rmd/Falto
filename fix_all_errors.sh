#!/bin/bash

set -e
PROJECT_PATH="/root/falto"
cd "$PROJECT_PATH"

echo "======================================"
echo "بدء إصلاح أخطاء المشروع"
echo "======================================"

# إنشاء المجلدات
mkdir -p lib/core/settings
mkdir -p lib/core/security
mkdir -p lib/core/models
mkdir -p lib/core/network/models/dto
mkdir -p lib/core/network/security

# ملف server_mode.dart
cat > lib/core/settings/server_mode.dart << 'EOF'
enum ServerMode {
  production,
  sandbox,
  development,
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
    }
  }
}
EOF

# ملف mode_storage.dart
cat > lib/core/settings/mode_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'server_mode.dart';

class ModeStorage {
  static const String _key = 'server_mode';

  static Future<void> saveMode(ServerMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  static Future<ServerMode> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeName = prefs.getString(_key);
    if (modeName == null) return ServerMode.sandbox;
    return ServerMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => ServerMode.sandbox,
    );
  }
}
EOF

# ملف secure_storage_manager.dart
cat > lib/core/security/secure_storage_manager.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static const _storage = FlutterSecureStorage();
  
  static const String keyToken = 'oanda_token';
  static const String keyAccountId = 'oanda_account_id';
  static const String keyRefreshToken = 'oanda_refresh_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: keyToken, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: keyToken);
  }

  static Future<void> saveAccountId(String accountId) async {
    await _storage.write(key: keyAccountId, value: accountId);
  }

  static Future<String?> getAccountId() async {
    return await _storage.read(key: keyAccountId);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: keyRefreshToken);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
EOF

# ملف candle_entity.dart  
cat > lib/core/models/candle_entity.dart << 'EOF'
import 'package:equatable/equatable.dart';

class CandleEntity extends Equatable {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const CandleEntity({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume = 0,
  });

  @override
  List<Object?> get props => [time, open, high, low, close, volume];

  CandleEntity copyWith({
    DateTime? time,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
  }) {
    return CandleEntity(
      time: time ?? this.time,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
    );
  }
}
EOF

# تحديث pubspec.yaml
cp pubspec.yaml pubspec.yaml.backup

cat > pubspec.yaml << 'EOF'
name: flutter_trading_app
description: Flutter Trading Application
publish_to: none
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  equatable: ^2.0.5
  dio: ^5.4.3+1
  web_socket_channel: ^2.4.5
  connectivity_plus: ^6.0.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.3
  flutter_secure_storage: ^9.2.2
  path_provider: ^2.1.3
  json_annotation: ^4.9.0
  fl_chart: ^0.68.0
  get_it: ^7.7.0
  go_router: ^14.2.0
  shimmer: ^3.0.0
  fluttertoast: ^8.2.6
  webview_flutter: ^4.8.0
  permission_handler: ^11.3.1
  http: ^1.2.2
  logger: ^2.4.0
  collection: ^1.18.0
  intl: ^0.19.0
  crypto: ^3.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  json_serializable: ^6.8.0
  hive_generator: ^2.0.1
  bloc_test: ^9.1.7
  mocktail: ^1.0.4

flutter:
  uses-material-design: true
  assets:
    - assets/
    - assets/js/
    - assets/lightweightcharts/
EOF

echo "تثبيت الحزم..."
flutter pub get

echo "إصلاح أخطاء Dio..."
find lib -name "*.dart" -type f -exec sed -i 's/DioError/DioException/g' {} ;
find lib -name "*.dart" -type f -exec sed -i 's/DioErrorType/DioExceptionType/g' {} ;

echo "تشغيل Build Runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "✅ تم الإصلاح!"
