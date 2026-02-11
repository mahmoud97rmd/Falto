import 'dart:async';
import 'package:flutter/foundation.dart';

class Dispatcher {
  static Future<T> computeAsync<T>(T Function() fn) {
    return compute(_wrap<T>, fn);
  }

  static T _wrap<T>(T Function() fn) => fn();
}
