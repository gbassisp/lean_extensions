import 'package:meta/meta.dart';

@internal
extension InternalExtensionsOnObject on Object? {
  bool get isPrimitive =>
      this == null || this is num || this is bool || this is String;

  bool get isNotPrimitive => !isPrimitive;

  Map<String, Object?> asJsonMap() {
    final thiz = this;
    if (thiz is Map) {
      if (thiz is Map<String, Object?>) {
        return thiz;
      }

      final m = <String, Object?>{};
      for (final e in thiz.entries) {
        m[e.key.toString()] = e.value;
      }

      return m;
    }

    throw TypeError();
  }
}
