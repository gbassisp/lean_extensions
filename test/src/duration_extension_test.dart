import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('num to Duration', () {
    test('weeks', () {
      expect(
        2.weeks,
        const Duration(days: 14),
      );
    });

    test('days', () {
      expect(
        1.5.days,
        const Duration(days: 1, hours: 12),
      );
    });

    test('hours', () {
      expect(
        1.5.hours,
        const Duration(hours: 1, minutes: 30),
      );
    });

    test('minutes', () {
      expect(
        1.5.minutes,
        const Duration(minutes: 1, seconds: 30),
      );
    });

    test('seconds', () {
      expect(
        1.5.seconds,
        const Duration(seconds: 1, milliseconds: 500),
      );
    });

    test('milliseconds', () {
      expect(
        1.5.milliseconds,
        const Duration(milliseconds: 1, microseconds: 500),
      );
    });

    test('microseconds (gets approximated)', () {
      expect(
        1.5.microseconds,
        const Duration(microseconds: 1),
      );
    });
  });
}
