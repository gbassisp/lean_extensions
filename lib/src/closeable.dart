import 'dart:async';

/// Similar to java Closeable, or python context manager, or c# IDisposable
///
/// **NOTE**:
/// Default constructor cannot be const, because we cannot have
/// canonicalized objects
mixin Closeable {
  /// Closes this resource, relinquishing any underlying resources.
  /// This method is invoked automatically on objects managed by
  /// the `try`-with-resources statement.
  ///
  /// @throws Exception if this resource cannot be closed
  FutureOr<void> close();
}

/// Extension methods for [Closeable]
extension CloseableExtensions on Closeable {
  /// Runs passed function and closes this resource after it
  /// If the function throws, the exception is propagated and the resource is
  /// still closed
  R runAndClose<R>(R Function(Closeable) fn) {
    try {
      return fn(this);
    } finally {
      close();
    }
  }

  /// Runs passed function and closes this resource after it
  /// If the function throws, the exception is propagated and the resource is
  /// still closed
  Future<R> runAndCloseAsync<R>(FutureOr<R> Function(Closeable) fn) async {
    try {
      return await fn(this);
    } finally {
      await close();
    }
  }
}

/// Runs passed function and closes this resource after it
/// If the function throws, the exception is propagated and the resource is
/// still closed
R useCloseable<R>(
  Closeable resource,
  R Function(Closeable) fn,
) {
  return resource.runAndClose(fn);
}

/// Runs passed function and closes this resource after it
/// If the function throws, the exception is propagated and the resource is
/// still closed
Future<R> useCloseableAsync<R>(
  Closeable resource,
  FutureOr<R> Function(Closeable) fn,
) async {
  return resource.runAndCloseAsync(fn);
}
