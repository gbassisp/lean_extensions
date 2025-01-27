import 'dart:convert';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/extensions.dart';
import 'package:lean_extensions/src/numeral_system.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('utils.dart', () {
    test('sleep()', () async {
      final a = Stopwatch()..start();
      const t = 5;
      await sleep(t);
      a.stop();

      // allow 0.5s for start() and stop()
      expect(a.elapsedMilliseconds, closeTo(t * 1000, 500));
    });

    test('extendedJsonEncode()', () {
      expect(range(10), isNot(isList));
      expect(extendedJsonEncode(range(10)), isList);
    });

    test('eval()', () async {
      const a = 'range(10).toList()';
      final res = await eval<List<dynamic>>(a);

      expect(res, containsAllInOrder(range(10)));
    });

    test('eval() - typed', () async {
      const a = 'range(10).toList()';
      final res = await eval<List<int>>(a);

      expect(res, containsAllInOrder(range(10)));
    });
    test('eval() - iterable', () async {
      const a = 'range(10)';
      final res = await eval<List<int>>(a);

      expect(res, containsAllInOrder(range(10)));
    });

    test('eval() - simple json', () async {
      const a = '''
{
  "something": "abc",
  "else": [],
  "other": 123,
  "another": false,
  "nothing": null
}
''';
      final encoded = jsonEncode(a);
      final res = await eval<Map<String, dynamic>>(encoded);

      expect(res, jsonDecode(a));
    });
    test('eval() - nested json', () async {
      String createJson(String internal) => '''
{
  "something": "abc",
  "else": [$internal, $internal],
  "other": 123,
  "another": false,
  "nothing": null
}
''';

      final a = createJson(createJson(createJson('"some strings"')));

      final encoded = jsonEncode(a);
      final res = await eval<Map<String, dynamic>>(encoded);

      expect(res, jsonDecode(a), reason: 'failed to eval $a');
    });

    test('isDebugMode', () {
      expect(isDebugMode, isTrue);
    });
  });

  group('numeral system', () {
    test('simple case - specific number', () {
      // specific well-known number
      expect(toRadix(45, 16), '2D');
      expect(fromRadixString('2D', 16).toInt(), 45);
    });
    test('matches int.toRadixString', () {
      // several numbers match native int.toRadixString()
      for (final i in range(-10000, 10000)) {
        expect(toRadix(i, 10), '$i');
        for (final b in range(2, 33)) {
          final converted = toRadix(i, b);
          expect(converted, i.toRadixString(b).toUpperCase());

          // convert back
          expect(fromRadixString(converted, b).toInt(), i);
        }
      }
    });
    test('number on its own radix', () {
      // number to its own base is always 10
      for (final i in range(2, 65)) {
        expect(toRadix(0, i), '0');
        expect(toRadix(i, i), '10');

        expect(fromRadixString('0', i).toInt(), 0);
        expect(fromRadixString('10', i).toInt(), i);
      }
    });

    test(
      'fromRadix with base <=32 should be case insesitive',
      () {
        for (final r in range(2, 33)) {
          for (final i in range(-1000, 1000)) {
            final low = i.toRadixString(r).toLowerCase();
            final upp = i.toRadixString(r).toUpperCase();

            expect(fromRadixString(low, r).toInt(), equals(i));
            expect(fromRadixString(upp, r).toInt(), equals(i));
          }
        }
      },
    );

    test('number from invalid radix throws', () {
      // well-know
      expect(() => '3'.toBigInt(2), throwsSomething);

      for (final r in range(2, 64)) {
        // a radix on the next base is the next one; e.g., 2 on radix 3 is 2,
        // but 2 doesn't exist on radix 2 (binary)
        final invalidNumber = r.toRadixExtended(r + 1);

        expect(() => invalidNumber.toBigInt(r), throwsSomething);
        expect(invalidNumber.tryToBigInt(r), isNull);
      }
    });
  });
}
