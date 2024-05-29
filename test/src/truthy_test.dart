import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/range.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

final falsy = [
  null,
  0,
  '',
  <dynamic>[],
  <dynamic>{},
  <dynamic, dynamic>{},
  range(0),
];
final truthy = [
  'a',
  1,
  [1],
  {1},
  {1: 1},
  'true',
  range(1),
];
const opinionatedFalsy = [
  'zero',
  '0',
  '0.',
  '0.0',
  'false',
  'False',
  'FALSE',
  'null',
  ' ',
];

void main() {
  group('truthy / falsy', () {
    for (final t in truthy) {
      test('$t has truthy value', () => expect(t, isTruthy));
    }
    for (final f in falsy) {
      test('$f has falsy value', () => expect(f, isFalsy));
    }
    for (final f in opinionatedFalsy) {
      test('$f has falsy value', () => expect(f, isFalsy));
    }
  });
}
