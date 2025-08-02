import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/src/pair.dart';

/// adds utility methods to [Iterable]
extension IterableExtraExtensions<T> on Iterable<T> {
  /// returns an [Iterable] of [MapEntry] with [int] and [T]
  Iterable<Pair<int, T>> enumerate([int start = 0]) sync* {
    for (final pair in zip(infiniteRange, this)) {
      final index = pair.$1 + start;
      yield Pair(index, pair.$2);
    }
  }
}

/// syntax sugar to use [Pair] in a more meaningful way with
/// [IterableExtraExtensions.enumerate]
extension MapEntryExtraExtensions<T> on Pair<int, T> {
  /// get the [$1] that represents the index of the
  ///  [IterableExtraExtensions.enumerate] getter
  int get index => $1;

  /// get the [$2] that represents the value of the
  ///  [IterableExtraExtensions.enumerate] getter
  T get value => $2;
}

/// top-level function matching the behaviour of the Python [enumerate] function
///
/// see https://docs.python.org/3/library/functions.html#enumerate
Iterable<Pair<int, T>> enumerate<T>(
  Iterable<T> iterable, [
  int start = 0,
]) =>
    iterable.enumerate(start);

/// top-level function matching the behaviour of the Python [zip] function
///
/// see https://docs.python.org/3/library/functions.html#zip
Iterable<Pair<A, B>> zip<A, B>(
  Iterable<A> iterable1,
  Iterable<B> iterable2,
) sync* {
  final i1 = iterable1.iterator;
  final i2 = iterable2.iterator;

  while (true) {
    final hasA = i1.moveNext();
    final hasB = i2.moveNext();
    if (hasA && hasB) {
      final a = i1.current;
      final b = i2.current;

      yield Pair(a, b);
    } else {
      break;
    }
  }
}
