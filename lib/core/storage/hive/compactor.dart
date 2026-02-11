import 'package:hive_ce/hive.dart';

Future<void> compactIfNeeded(Box box) async {
  if (box.length > 1000) {
    await box.compact();
  }
}
