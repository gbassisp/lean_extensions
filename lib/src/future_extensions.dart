import 'dart:async';

/// Extension methods for [Future].
extension FutureLeanExtensions<T> on Future<T> {
  /// Executes a function when the future completes successfully.
  ///
  /// The function [action] is called with the value of the future.
  ///
  /// Returns a new [Future] that completes with the same value as this future.
  Future<T> tap(void Function(T value) action) {
    return then((v) {
      action(v);
      return v;
    });
  }

  /// a wrapper around the [timeout] method that allows passing nullable a
  /// [Duration]. If null, no timeout rule is applied
  Future<T> maybeTimeout(
    Duration? timeLimit, {
    FutureOr<T> Function()? onTimeout,
  }) {
    if (timeLimit == null) {
      return this;
    } else {
      return timeout(timeLimit, onTimeout: onTimeout);
    }
  }
}
