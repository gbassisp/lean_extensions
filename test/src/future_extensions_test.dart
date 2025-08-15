import 'package:lean_extensions/src/future_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('FutureLeanExtensions', () {
    group('tap', () {
      test('should execute action on success', () async {
        var tappedValue = 0;
        await Future.value(1).tap((v) => tappedValue = v);
        expect(tappedValue, 1);
      });

      test('should not execute action on error', () async {
        var tapped = false;
        await Future<void>.error(Exception())
            .tap((_) => tapped = true)
            .catchError((_) {});
        expect(tapped, isFalse);
      });
    });
  });
}
