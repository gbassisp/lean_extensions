import 'package:lean_extensions/dart_essentials.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

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
        final k = item.$1;
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
        final k = item.$1;
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
          final k = item.$1;
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
          final k = item.$1;
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

  group('Iterable.startsWith', () {
    test('smaller than sublist is false', () {
      final a = [1];
      final b = [1, 2];

      expect(a.startsWith(b), isFalse);
    });
    test('same size as sublist is true', () {
      final a = [1, 2];
      final b = [1, 2];

      expect(a.startsWith(b), isTrue);
    });
    test('greater than sublist is true', () {
      final a = [1, 2, 3];
      final b = [1, 2];

      expect(a.startsWith(b), isTrue);
    });
    test('same size as and does not start with returns false', () {
      final a = [1, 1];
      final b = [1, 2];

      expect(a.startsWith(b), isFalse);
    });
    test('greather than and does not start with returns false', () {
      final a = [0, 1, 2];
      final b = [1, 2];

      expect(a.startsWith(b), isFalse);
    });
  });

  group('Iterable.containsSub', () {
    test('smaller than sublist is false', () {
      final a = [1];
      final b = [1, 2];

      expect(a.containsSub(b), isFalse);
    });
    test('same size as sublist is true', () {
      final a = [1, 2];
      final b = [1, 2];

      expect(a.containsSub(b), isTrue);
    });
    test('greater than sublist is true', () {
      final a = [1, 2, 3];
      final b = [1, 2];

      expect(a.containsSub(b), isTrue);
    });
    test('same size as and does not contain sub with returns false', () {
      final a = [1, 1];
      final b = [1, 2];

      expect(a.containsSub(b), isFalse);
    });
    test('greather than and does not contain sub with returns false', () {
      final a = [0, 1, 2];
      final b = [1, 2];

      expect(a.containsSub(b), isTrue);
    });
  });

  group('Iterable.endsWith', () {
    test('smaller than sublist is false', () {
      final a = [2];
      final b = [1, 2];

      expect(a.endsWith(b), isFalse);
    });
    test('same size as sublist is true', () {
      final a = [1, 2];
      final b = [1, 2];

      expect(a.endsWith(b), isTrue);
    });
    test('greater than sublist is true', () {
      final a = [0, 1, 2];
      final b = [1, 2];

      expect(a.endsWith(b), isTrue);
    });
    test('same size as and does not end with returns false', () {
      final a = [1, 1];
      final b = [1, 2];

      expect(a.endsWith(b), isFalse);
    });
    test('greather than and does not end with returns false', () {
      final a = [1, 2, 3];
      final b = [1, 2];

      expect(a.endsWith(b), isFalse);
    });
  });

  group(
    'zip',
    () {
      const smaller = ['b', 3];
      const bigger = ['c', 4, false, empty, 0];
      const zipped = [Pair('b', 'c'), Pair(3, 4)];
      final flipped = zipped.map((e) => e.flipped);

      test('smaller on the left', () {
        final result = zip(smaller, bigger);

        expect(result, containsAllInOrder(zipped));
      });

      test('smaller on the right', () {
        final result = zip(bigger, smaller);

        expect(result, containsAllInOrder(flipped));
      });

      test('infinite will throw', () {
        expect(
          () {
            late Pair<int, int> current;
            for (final pair in zip(infiniteRange, infiniteRange)) {
              current = pair;
              // 10mi times:
              if (pair.$1 > 10000000) {
                return;
              }
            }
            // else:
            throw StateError('range terminated before expected: $current');
          },
          throwsNothing,
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
