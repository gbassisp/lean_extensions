import 'package:collection/collection.dart';
import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

const int _times = 1000000;
final _globalLog = <String>[];
void _log(Object? anything) {
  // print(anything);
  _globalLog.add(anything.toString());
}

final _timeout = Timeout(5.minutes);

Future<void> _logAsync(String prefix) async {
  await Future(() => _log('$prefix-start'));
  for (final i in range(_times)) {
    await Future(() => _log('$prefix-$i'));
  }
  await Future(() => _log('$prefix-end'));
}

void _logSync(String prefix) {
  _log('$prefix-start');
  for (final i in range(_times)) {
    _log('$prefix-$i');
  }
  _log('$prefix-end');
}

void _expectLogMixed() {
  final hasSequence = _hasAtLeastOneSequence();
  expect(hasSequence, isFalse);
}

void _expectLogNotMixed() {
  final hasSequence = _hasAtLeastOneSequence();
  expect(hasSequence, isTrue);
}

bool _hasAtLeastOneSequence() {
  final groups = _globalLog.length ~/ (_times + 2);
  // terrible big-o, but it's a quick and dirty test
  for (final i in range(groups)) {
    final s = '$i-start';
    final e = '$i-end';
    final sPos = _globalLog.indexOf(s);
    expect(sPos, greaterThanOrEqualTo(0));
    final ePos = _globalLog.indexOf(e);
    expect(ePos, greaterThanOrEqualTo(0));

    // print('analysing $i');
    if (ePos - sPos == _times + 1) {
      final slice = _globalLog.slice(sPos + 1, ePos);
      // print('found possible match with $i');
      if (const DeepCollectionEquality().equals(
        slice,
        List.generate(_times, (index) => '$i-$index'),
      )) {
        return true;
      }
    }
  }

  return false;
}

void main() {
  setUp(_globalLog.clear);
  group('sync execution is never paused by the event loop', () {
    test(
      'concurrent async will be mixed up',
      () async {
        final f0 = _logAsync('0');
        final f1 = _logAsync('1');

        await Future.wait([f0, f1]);

        _expectLogMixed();
      },
      timeout: _timeout,
    );

    test(
      'concurrent async+sync will be have a block of sync',
      () async {
        final f0 = _logAsync('0');
        await sleep(0);
        final f1 = _logAsync('1');
        await sleep(0);
        final f2 = _logAsync('2');
        await sleep(0);

        _logSync('3');

        await Future.wait([f0, f1, f2]);

        _expectLogNotMixed();
      },
      timeout: _timeout,
    );
  });
}
