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
  });
}
