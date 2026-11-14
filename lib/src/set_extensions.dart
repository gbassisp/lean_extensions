/// extension methods on [Set]
extension SetLeanExtensions<T> on Set<T> {
  /// [add] value to this, but throws if it already exists
  void addUnique(T value) {
    final isNew = add(value);

    if (!isNew) {
      throw StateError(
        'Attempted to add unique value $value, '
        'but it was already present',
      );
    }
  }
}
