import 'package:lean_extensions/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('utils.dart', () {
    test('sleep()', () async {
      final a = Stopwatch()..start();
      await sleep(10);
      a.stop();

      // allow 0.5s for start() and stop()
      expect(a.elapsedMilliseconds, closeTo(10000, 500));
    });
  });
}
