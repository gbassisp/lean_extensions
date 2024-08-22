import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/extensions.dart';
import 'package:lean_extensions/src/interfaces.dart';
import 'package:test/test.dart';

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

void main() {
  group('EasyComparable abstract class', () {
    test('compareTo', () {
      final ints = List.generate(100, (index) => index);
      final objs = ints.map((e) => _IntComparable(e)).toList();
      for (final _ in range(1000)) {
        objs
          ..shuffle()
          ..sort();
        final res = objs.map((e) => e.v);

        expect(res, containsAllInOrder(ints));
      }
    });
  });
}
