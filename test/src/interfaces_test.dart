import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/extensions.dart';
import 'package:lean_extensions/src/interfaces.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

class _IntComparable extends EasyComparable<_IntComparable> {
  _IntComparable(this.v);

  final int v;

  @override
  bool operator ==(Object other) {
    return other is _IntComparable ? v == other.v : v == other.toInt();
  }

  @override
  bool operator >(Object other) {
    return other is _IntComparable ? v > other.v : v > other.toInt();
  }

  @override
  int get hashCode => v.hashCode;
}

class _NullableComparable extends EasyComparable<_NullableComparable?> {
  _NullableComparable(this.v);

  final int v;

  @override
  bool operator ==(Object other) {
    return other is _NullableComparable ? v == other.v : v == other.toInt();
  }

  @override
  bool operator >(Object other) {
    return other is _NullableComparable ? v > other.v : v > other.toInt();
  }

  @override
  int get hashCode => v.hashCode;
}

class _InvalidComparable extends EasyComparable<_InvalidComparable> {
  @override
  bool operator ==(Object other) => false;

  @override
  bool operator >(Object other) => false;

  @override
  bool operator <(Object other) => false;

  @override
  int get hashCode => 0;
}

void main() {
  group('EasyComparable abstract class', () {
    final ints = List.generate(100, (index) => index);
    final valids = ints.map((e) => _IntComparable(e)).toList();
    final nullables = ints
        .map<_NullableComparable?>((e) => _NullableComparable(e))
        .toList()
      ..add(null);
    final invalids = ints.map((e) => _InvalidComparable()).toList();
    test('compareTo', () {
      for (final _ in range(1000)) {
        valids
          ..shuffle()
          ..sort();
        final res = valids.map((e) => e.v);

        expect(res, containsAllInOrder(ints));
      }
    });

    test('invalid comparable', () {
      // all operators < , > and == return false
      for (final _ in range(1000)) {
        invalids.shuffle();
        expect(invalids.sort, throwsSomething);
      }
    });

    test('null comparable', () {
      for (final _ in range(1000)) {
        nullables.shuffle();
        expect(nullables.sort, throwsSomething);
      }
    });
  });
}
