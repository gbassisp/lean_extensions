/// adds utility methods to [Iterable]
extension IterableExtraExtensions<T> on Iterable<T> {
  /// returns an [Iterable] of [MapEntry] with [int] and [T]
  Iterable<MapEntry<int, T>> enumerate([int start = 0]) sync* {
    var i = start;
    for (final element in this) {
      yield MapEntry(i, element);
      i++;
    }
  }
}

/// syntax sugar to use [MapEntry] in a more meaningful way with
/// [IterableExtraExtensions.enumerate]
extension MapEntryExtraExtensions<T> on MapEntry<int, T> {
  /// get the [key] that represents the index of the
  ///  [IterableExtraExtensions.enumerate] getter
  int get index => key;
}

/// top-level function matching the behaviour of the Python [enumerate] function
///
/// see https://docs.python.org/3/library/functions.html#enumerate
Iterable<MapEntry<int, T>> enumerate<T>(
  Iterable<T> iterable, [
  int start = 0,
]) =>
    iterable.enumerate(start);
