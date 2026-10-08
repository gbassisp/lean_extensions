import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';

/// adds utility methods to [Iterable]
extension IterableExtraExtensions<T> on Iterable<T> {
  /// returns an [Iterable] of [MapEntry] with [int] and [T]
  Iterable<Pair<int, T>> enumerate([int start = 0]) sync* {
    for (final pair in _zipCore(infiniteRange, this)) {
      final index = pair.$1 + start;
      yield Pair(index, pair.$2);
    }
  }

  /// apply [zip](this, [other])
  Iterable<Pair<T, U>> zip<U>(Iterable<U> other) => _zipCore(this, other);

  /// check if this starts with [sub] list
  bool startsWith(Iterable<T> sub) {
    final a = toList();
    final b = sub.toList();
    if (b.length > a.length) {
      return false;
    }

    for (final element in zip(sub)) {
      if (element.$1 != element.$2) {
        return false;
      }
    }
    return true;
  }

  /// check if this contains [sub] list
  bool containsSub(Iterable<T> sub) {
    final a = toList();
    final l1 = a.length;
    final b = sub.toList();
    final l2 = b.length;

    for (final i in range(l1)) {
      final r1 = l1 - i;
      if (r1 < l2) {
        break;
      }

      final aSub = a.sublist(i);
      if (aSub.startsWith(b)) {
        return true;
      }
    }

    return false;
  }

  /// check if this ends with [sub] list
  bool endsWith(Iterable<T> sub) {
    final a = reversed;
    final b = sub.reversed;

    return a.startsWith(b);
  }
}

/// syntax sugar to use [Pair] in a more meaningful way with
/// [IterableExtraExtensions.enumerate]
extension PairExtraExtensions<T> on Pair<int, T> {
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
/// zip is as long as the shortest [Iterable]
///
/// see https://docs.python.org/3/library/functions.html#zip
Iterable<Pair<A, B>> zip<A, B>(
  Iterable<A> iterable1,
  Iterable<B> iterable2,
) =>
    _zipCore(iterable1, iterable2);

Iterable<Pair<A, B>> _zipCore<A, B>(
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
