import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/iterable_extra_extensions.dart';
import 'package:test/test.dart';

void main() {
  const empty = <Object?>[];
  const single = ['a'];
  const many = ['a', 2, true, null];

  group('Iterable.enumerate()', () {
    test('empty', () {
      final enumerated = empty.enumerate();

      expect(enumerated, isEmpty);
    });

    test('single', () {
      final enumerated = single.enumerate();

      expect(enumerated, isNotEmpty);
      for (final item in enumerated) {
        final i = item.index;
        final k = item.key;
        final v = item.value;

        expect(i, equals(k));
        expect(i, equals(0));
        expect(v, equals('a'));
      }
    });

    test('many', () {
      final enumerated = many.enumerate();
      final indexes = List.generate(many.length, (index) => index);

      expect(enumerated, isNotEmpty);
      for (final item in enumerated) {
        final i = item.index;
        final k = item.key;
        final expectedIndex = indexes.elementAt(i);
        final v = item.value;
        final expectedValue = many.elementAt(i);

        expect(i, equals(k));
        expect(i, equals(expectedIndex));
        expect(v, equals(expectedValue));
      }
    });
  });

  for (final start in range(-10, 10)) {
    group('Iterable.enumerate(start = $start)', () {
      test('empty', () {
        final enumerated = empty.enumerate(start);

        expect(enumerated, isEmpty);
      });

      test('single', () {
        final enumerated = single.enumerate(start);

        expect(enumerated, isNotEmpty);
        for (final item in enumerated) {
          final i = item.index;
          final k = item.key;
          final v = item.value;

          expect(i, equals(k));
          expect(i, equals(start));
          expect(v, equals('a'));
        }
      });

      test('many', () {
        final enumerated = many.enumerate(start);
        final indexes = List.generate(many.length, (index) => index + start);

        expect(enumerated, isNotEmpty);
        for (final item in enumerated) {
          final i = item.index;
          final k = item.key;
          final expectedIndex = indexes.elementAt(i - start);
          final v = item.value;
          final expectedValue = many.elementAt(i - start);

          expect(i, equals(k));
          expect(i, equals(expectedIndex));
          expect(v, equals(expectedValue));
        }
      });
    });
  }
}
