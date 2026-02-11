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

  // Alias for getMode
  static Future<ServerMode> load() => getMode();
}
