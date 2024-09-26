// ignore_for_file: inference_failure_on_collection_literal

import 'package:collection/collection.dart';
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
    'e': [],
    'f': ['string'],
    'g': {
      'a1': 1,
      'b1': 'string',
      'c1': 1.5,
      'd1': null,
      'e1': [],
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
    test('deepCopyMap', () {
      final map2 = deepCopyMap(map1);

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

    test('removeNulls from json', () {
      const a = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'd': null,
        'e': [],
        'f': ['string'],
        'g': {
          'a1': 1,
          'b1': 'string',
          'c1': 1.5,
          'd1': null,
          'e1': [],
          'f1': ['string'],
        },
      };
      const expected = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'e': [],
        'f': ['string'],
        'g': {
          'a1': 1,
          'b1': 'string',
          'c1': 1.5,
          'e1': [],
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
        'e': [],
        'f': ['string'],
        'g': {
          'a1': 1,
          'b1': 'string',
          'e1': [],
          'f1': ['string'],
        },
      };
      const b = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'e': [],
        'f': ['string'],
        'g': {
          'a1': 1,
          'c1': 1.5,
          'e1': [],
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
