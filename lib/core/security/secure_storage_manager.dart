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

  // Aliases for backward compatibility
  static Future<String?> readOandaToken() async => getToken();
  static Future<String?> readOandaAccount() async => getAccountId();
  static Future<void> saveOandaToken(String token) async => saveToken(token);
  static Future<void> saveOandaAccount(String accountId) async => saveAccountId(accountId);
}
