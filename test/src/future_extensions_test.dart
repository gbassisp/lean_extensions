import 'dart:async';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
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

    group(
      'maybeTimeout',
      () {
        test('when null does not add timeout', () async {
          final future = sleep(1).maybeTimeout(null);

          await expectLater(future, completes);
        });

        test('when not null does add timeout and throw on timeout', () async {
          final future = sleep(1).maybeTimeout(0.1.seconds);

          await expectLater(future, throwsA(isA<TimeoutException>()));
        });

        test('when not null does add timeout and does not throw on completion',
            () async {
          final future = sleep(1).maybeTimeout(2.seconds);

          await expectLater(future, completes);
        });

        test('on timeout calls onTimeout param', () async {
          var called = 0;
          final future = sleep(1).maybeTimeout(
            0.1.seconds,
            onTimeout: () => called++,
          );

          await expectLater(future, completes);
          expect(called, 1);
        });
      },
      timeout: Timeout(5.seconds),
    );
  });
}
