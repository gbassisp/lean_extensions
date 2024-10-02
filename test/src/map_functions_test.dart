import 'package:collection/collection.dart';
import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:lean_extensions/src/internal_extensions.dart';
import 'package:lean_extensions/src/map_functions.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  final map1 = {
    'a': 1,
    'b': 'string',
    'c': 1.5,
    'd': null,
    'e': <Object?>[],
    'f': ['string'],
    'g': {
      'a1': 1,
      'b1': 'string',
      'c1': 1.5,
      'd1': null,
      'e1': <Object?>[],
      'f1': ['string'],
    },
  };
  // map1['graph'] = map1;

  const deepEquality = DeepCollectionEquality();

  group(
    'circular reference',
    () {
      test(
        'deepCopyMap',
        () => expect(() => deepCopyMap(map1), doesNotThrow),
      );
    },
    skip: 'only a rough idea for the future',
  );

  group('internal Map functions to be used on extensions', () {
    final cloners = <Map<K, V> Function<K, V>(Map<K, V>)>[
      deepCopyMap,
      <K, V>(map) => map.clone(),
    ];
    for (final cloner in cloners) {
      test('deepCopyMap - $cloner', () {
        final map2 = cloner(map1);

        final reason = 'map1 $map1 is different than map2 $map2';
        expect(deepEquality.equals(map1, map2), isTrue, reason: reason);

        for (final maps in [
          [map1, map2],
          [map1['g'], map2['g']],
        ]) {
          final m1 = maps.first.asJsonMap();
          final m2 = maps.last.asJsonMap();
          for (final k in m1.keys) {
            expect(m2[k], equals(m1[k]));
            if (m1[k].isPrimitive) {
              expect(m2[k], same(m1[k]));
            } else {
              expect(m2[k], isNot(same(m1[k])));
            }
          }
        }
      });
    }

    const list = [
      null,
      true,
      1,
      'a',
      ['b'],
    ];
    test('deepCopyIterable - list', () {
      final list1 = list.toList();
      final list2 = deepCopyIterable(list1);
      expect(list2 is List, isTrue);

      final reason = 'list1 $list1 is different than list2 $list2';
      expect(deepEquality.equals(list1, list2), isTrue, reason: reason);

      for (final i in range(list1.length)) {
        expect(list2.elementAt(i), equals(list1.elementAt(i)));
        if (list1.elementAt(i).isPrimitive) {
          expect(list2.elementAt(i), same(list1.elementAt(i)));
        } else {
          expect(list2.elementAt(i), isNot(same(list1.elementAt(i))));
        }
      }
    });

    test('deepCopyIterable - set', () {
      final list1 = list.toSet();
      final list2 = deepCopyIterable(list1);
      expect(list2 is Set, isTrue);

      final reason = 'set1 $list1 is different than set2 $list2';
      expect(deepEquality.equals(list1, list2), isTrue, reason: reason);

      for (final i in range(list1.length)) {
        expect(list2.elementAt(i), equals(list1.elementAt(i)));
        if (list1.elementAt(i).isPrimitive) {
          expect(list2.elementAt(i), same(list1.elementAt(i)));
        } else {
          expect(list2.elementAt(i), isNot(same(list1.elementAt(i))));
        }
      }
    });

    test('removeNulls from json', () {
      const a = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'd': null,
        'e': <Object?>[],
        'f': ['string'],
        'g': {
          'a1': 1,
          'b1': 'string',
          'c1': 1.5,
          'd1': null,
          'e1': <Object?>[],
          'f1': ['string'],
        },
      };
      const expected = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'e': <Object?>[],
        'f': ['string'],
        'g': {
          'a1': 1,
          'b1': 'string',
          'c1': 1.5,
          'e1': <Object?>[],
          'f1': ['string'],
        },
      };

      expectSameCollection(a.withoutNulls, expected);
    });

    test('json difference', () {
      const a = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'd': null,
        'e': <Object?>[],
        'f': ['string'],
        'g': {
          'a1': 1,
          'b1': 'string',
          'e1': <Object?>[],
          'f1': ['string'],
        },
      };
      const b = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'e': <Object?>[],
        'f': ['string'],
        'g': {
          'a1': 1,
          'c1': 1.5,
          'e1': <Object?>[],
          'f1': ['string'],
        },
      };
      const expected = {
        'd': null,
        'g': {
          'b1': 'string',
        },
      };

      expectSameCollection(a.difference(b), expected);
    });
  });
}
