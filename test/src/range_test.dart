import 'package:lean_extensions/src/range.dart';
import 'package:test/test.dart';

void main() {
  group('functions', () {
    test('range(end)', () {
      for (final _ in range(0)) {
        throw Exception('should not be reached');
      }

      // valid
      var count = 0;
      for (final i in range(10)) {
        expect(i, greaterThanOrEqualTo(0));
        expect(i, lessThan(10));
        count++;
      }
      expect(count, 10);

      // invalid
      expect(() => range(-1), throwsA(isA<AssertionError>()));
    });

    test('range(start, stop)', () {
      for (final _ in range(0, 0)) {
        throw Exception('should not be reached');
      }

      // valid
      var count = 0;
      for (final i in range(0, 10)) {
        expect(i, greaterThanOrEqualTo(0));
        expect(i, lessThan(10));
        count++;
      }
      expect(count, 10);

      // invalid
      expect(() => range(0, -1), throwsA(isA<AssertionError>()));
    });

    test('range(start, stop, step)', () {
      // valid
      var count = 0;
      for (final i in range(0, 10, 2)) {
        expect(i, greaterThanOrEqualTo(0));
        expect(i, lessThan(10));
        expect(i.isEven, isTrue, reason: 'step is $i');
        count++;
      }
      expect(count, 5);

      // invalid
      expect(() => range(0, 0, 0), throwsA(isA<AssertionError>()));
      expect(() => range(0, 10, 0), throwsA(isA<AssertionError>()));
      expect(() => range(0, 10, -1), throwsA(isA<AssertionError>()));
      expect(() => range(0, -10, 1), throwsA(isA<AssertionError>()));
    });
  });

  group('classes', () {});
}
