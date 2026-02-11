import 'package:hive_ce/hive.dart';

class BlocStateCache {
  final Box box;

  BlocStateCache(this.box);

  void save(String key, dynamic data) => box.put(key, data);
  dynamic load(String key) => box.get(key);
}
