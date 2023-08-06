import 'package:flutter/foundation.dart';

class Log {
  // ignore: constant_identifier_names
  static const String _TAG_DEFAULT = "###Default###";

  static void i(Object object, {String tag = _TAG_DEFAULT}) {
    if (kDebugMode) {
      print("$_TAG_DEFAULT $tag: $object");
    }
  }
}