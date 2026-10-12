import 'package:lean_extensions/lean_extensions.dart';
import 'package:lean_extensions/src/comparable.dart';
import 'package:test/test.dart';

import 'lean_extensions_test.dart';

void main() {
  group('functions', () {
    test('minComparable', () {
      // num
      expect(minComparable(0, 1), 0);
      expect(minComparable(1, 1.0), 1);
      expect(minComparable(2, 1.0), 1);
      // Duration
      expect(minComparable(1.seconds, 1.minutes), 1.seconds);
      expect(minComparable(1.seconds, 1.seconds), 1.seconds);
      expect(minComparable(1.minutes, 1.seconds), 1.seconds);
    });

    test('maxComparable', () {
      // num
      expect(maxComparable(0, 1), 1);
      expect(maxComparable(1, 1.0), 1);
      expect(maxComparable(2, 1.0), 2);
      // Duration
      expect(maxComparable(1.seconds, 1.minutes), 1.minutes);
      expect(maxComparable(1.seconds, 1.seconds), 1.seconds);
      expect(maxComparable(1.minutes, 1.seconds), 1.minutes);
    });
  });

  group('extensions', () {
    test('isBetween exclusive min exclusive max', () {
      expect(1.isBetween(0.9, 1.1), isTrue);
      expect(1.isBetween(1, 1.1), isFalse);
      expect(1.isBetween(0.9, 1), isFalse);
      expect(
        1.isBetween(0.9, 1.1, inclusiveMax: false, inclusiveMin: false),
        isTrue,
      );
    });
    test('isBetween inclusive min inclusive max', () {
      expect(
        1.isBetween(0.9, 1.1, inclusiveMax: true, inclusiveMin: true),
        isTrue,
      );
      expect(
        1.isBetween(1, 1.1, inclusiveMax: true, inclusiveMin: true),
        isTrue,
      );
      expect(
        1.isBetween(0.9, 1, inclusiveMax: true, inclusiveMin: true),
        isTrue,
      );
      expect(
        1.isBetween(0.9, 1.1, inclusiveMax: true, inclusiveMin: true),
        isTrue,
      );
    });

    test('isBetween throws AssertionError if in wrong order', () {
      expect(() => 1.isBetween(1, 0), throwsAssertionError);
      expect(() => 1.isBetween(0, 0), returnsNormally);
      expect(() => 1.isBetween(1, 1), returnsNormally);
    });
  });
}
