import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('base model tests', () {
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
