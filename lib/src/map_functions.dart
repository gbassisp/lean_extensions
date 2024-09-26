// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

@internal
Map<K, V> deepCopyMap<K, V>(Map<K, V> map) {
  final res = <K, V>{};
  for (final e in map.entries) {
    final k = e.key;
    final v = e.value;
    if (v is Map) {
      final c = deepCopyMap(v);
      assert(
        c is V,
        'attempted to deep copy a Map of type '
        '${c.runtimeType}, but expected $V from the context',
      );
      res[k] = c as V;
    } else if (v is Iterable) {
      final c = deepCopyIterable(v);
      assert(
        c is V,
        'attempted to deep copy an Iterable of type '
        '${c.runtimeType}, but expected $V from the context',
      );
      res[k] = c as V;
    } else {
      res[k] = v;
    }
  }

  return res;
}

@internal
Iterable<V> deepCopyIterable<V>(Iterable<V> collection) {
  final res = <V>[];
  for (final e in collection) {
    if (e is Map) {
      final c = deepCopyMap(e);
      assert(
        c is V,
        'attempted to deep copy a Map of type '
        '${c.runtimeType}, but expected $V from the context',
      );
      res.add(c as V);
    } else if (e is Iterable) {
      final c = deepCopyIterable(e);
      assert(
        c is V,
        'attempted to deep copy an Iterable of type '
        '${c.runtimeType}, but expected $V from the context',
      );
      res.add(c as V);
    } else {
      res.add(e);
    }
  }

  if (collection is List) {
    return res.toList();
  } else if (collection is Set) {
    return res.toSet();
  }

  return res;
}

// @internal
// Iterable<MapEntry<K, V>> visitMap<K, V>(Map<K, V> map) sync* {
//   for (final e in map.entries) {}
// }

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
      res[e.key] = mapDifference(v, m2[e.key]! as Map) as V;
      continue;
    }

    res.addEntries([e]);
  }

  return res;
}
