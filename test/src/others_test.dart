import 'dart:convert';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:test/test.dart';

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
  });
}
