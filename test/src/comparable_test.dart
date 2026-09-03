import 'package:lean_extensions/lean_extensions.dart';
import 'package:lean_extensions/src/comparable.dart';
import 'package:test/test.dart';

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
}
