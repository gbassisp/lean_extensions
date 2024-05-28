import 'package:lean_extensions/dart_essentials.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('truthy / falsy', () {
    test('truthy', () {
      expect('a', isTruthy);
      expect(1, isTruthy);
      expect([1], isTruthy);
      expect({1}, isTruthy);
      expect({1: 1}, isTruthy);
      expect('true', isTruthy);
      expect(range(1), isTruthy);
    });
    test('falsy', () {
      expect(null, isFalsy);
      expect('', isFalsy);
      expect(0, isFalsy);
      expect(<dynamic>[], isFalsy);
      expect(<dynamic>{}, isFalsy);
      expect(<dynamic, dynamic>{}, isFalsy);
      expect(range(0), isFalsy);
    });
    test('opinionated truthiness', () {
      expect('zero', isFalsy);
      expect('0', isFalsy);
      expect('0.', isFalsy);
      expect('0.0', isFalsy);
      expect('false', isFalsy);
      expect('False', isFalsy);
      expect('FALSE', isFalsy);
      expect('null', isFalsy);
      expect(' ', isFalsy);
    });
  });
}
