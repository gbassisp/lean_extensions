import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/extensions.dart';
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

class _StrictInt extends StrictComparable<_StrictInt> {
  _StrictInt(this.v);

  final int v;

  @override
  bool operator ==(Object other) => other is _StrictInt && other.v == v;

  @override
  int get hashCode => v.hashCode;

  @override
  bool operator >(_StrictInt other) => v > other.v;
  @override
  bool operator <(_StrictInt other) => v < other.v;
}

void main() {
  final ints = List.generate(100, (index) => index);
  final stricts = ints.map((e) => _StrictInt(e)).toList();
  final valids = ints.map((e) => _IntComparable(e)).toList();
  group('EasyComparable abstract class', () {
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
  group('StrictComparable abstract class', () {
    test('compareTo', () {
      for (final _ in range(1000)) {
        stricts
          ..shuffle()
          ..sort();
        final res = valids.map((e) => e.v);

        expect(res, containsAllInOrder(ints));
      }
    });

    test('compiler warning', () {
      // uncomment the following to get a compiler error. they throw
      // argument_type_not_assignable compilation error, as part of
      // StrictComparable which doesn't happen on EasyComparable
      // expect(() => _StrictInt(1) > 0, throwsSomething);
      // expect(() => _StrictInt(1) < 10, throwsSomething);
      expect(() => _IntComparable(1) > 0, isNot(throwsSomething));
      expect(() => _IntComparable(1) < 10, isNot(throwsSomething));
    });
  });
}
