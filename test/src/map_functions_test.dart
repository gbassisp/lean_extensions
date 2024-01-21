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
        'e': [],
        'f': ['string'],
      };
      const expected = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'e': [],
        'f': ['string'],
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
      };
      const b = {
        'a': 1,
        'b': 'string',
        'c': 1.5,
        'e': [],
        'f': ['string'],
      };
      const expected = {'d': null};

      expectSameCollection(a.difference(b), expected);
    });
  });
}