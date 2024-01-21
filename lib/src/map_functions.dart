// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

@internal
Map<K, V> removeNulls<K, V>(Map<K, V> map) {
  final res = <K, V>{};
  for (final e in map.entries) {
    if (e.value == null) {
      continue;
    }

    if (e.value is Map) {
      final v = e.value as Map;
      res[e.key] = removeNulls(v) as V;
      continue;
    }

    res.addEntries([e]);
  }

  return res;
}

@internal
Map<K, V> mapDifference<K, V>(Map<K, V> m1, Map<K, V> m2) {
  final res = <K, V>{};
  for (final e in m1.entries) {
    if (m2.containsKey(e.key) && m2[e.key] == e.value) {
      continue;
    }

    if (e.value is Map && m2[e.key] is Map) {
      final v = e.value as Map;
      res[e.key] = mapDifference(v, m2[e.key] as Map) as V;
      continue;
    }

    res.addEntries([e]);
  }

  return res;
}
