import 'dart:async';

import 'package:meta/meta.dart';

/// Similar to java Closeable, or python context manager, or c# IDisposable
///
/// **NOTE**:
/// Default constructor cannot be const, because we cannot have
/// canonicalized objects
mixin Closeable {
  /// Closes this resource, relinquishing any underlying resources.
  /// Do not close manually. Use [runAndClose], [runAndCloseAsync], or
  /// [useCloseable], [useCloseableAsync] functions instead
  ///
  /// @throws Exception if this resource cannot be closed
  @protected
  FutureOr<void> close();

  /// Inner closeables. If this resource manages other closeables, they should
  /// be returned here, so they can be closed when this resource is closed.
  /// If there are no inner closeables, return empty iterable
  @protected
  Iterable<Closeable> get closeables;
}

Exception _asException(Object e) {
  return e is Exception ? e : Exception(e.toString());
}

/// Extension methods for [Closeable]
extension CloseableExtensions on Closeable {
  /// Runs passed function and closes this resource after it
  /// Closes the resource even if the function throws. The first exception
  /// thrown is propagated, if both the function and the close throw, the
  /// exception from the function is propagated
  R runAndClose<R>(R Function(Closeable) fn) {
    Exception? exception;
    R? result;
    try {
      result = fn(this);
    } on Object catch (e) {
      exception ??= _asException(e);
    }

    try {
      close();
    } on Object catch (e) {
      exception ??= _asException(e);
    }

    for (final closeable in closeables) {
      try {
        closeable.close();
      } on Object catch (e) {
        exception ??= _asException(e);
      }
    }

    if (exception != null) {
      throw exception;
    } else {
      return result as R;
    }
  }

  /// Runs passed function and closes this resource after it
  /// Closes the resource even if the function throws. The first exception
  /// thrown is propagated, if both the function and the close throw, the
  /// exception from the function is propagated
  Future<R> runAndCloseAsync<R>(FutureOr<R> Function(Closeable) fn) async {
    Exception? exception;
    R? result;
    try {
      result = await fn(this);
    } on Object catch (e) {
      exception ??= _asException(e);
    }

    try {
      await close();
    } on Object catch (e) {
      exception ??= _asException(e);
    }

    final futures = await Future.wait(
      closeables.map((c) async {
        try {
          await c.close();
        } on Object catch (e) {
          return _asException(e);
        }
      }),
    );
    exception ??= futures.firstWhere(
      (e) => e != null,
      orElse: () => null,
    );

    if (exception != null) {
      throw exception;
    } else {
      return result as R;
    }
  }
}

/// Runs passed function and closes this resource after it
/// Closes the resource even if the function throws. The first exception
/// thrown is propagated, if both the function and the close throw, the
/// exception from the function is propagated
R useCloseable<R>(
  Closeable resource,
  R Function(Closeable) fn,
) {
  return resource.runAndClose(fn);
}

/// Runs passed function and closes this resource after it
/// Closes the resource even if the function throws. The first exception
/// thrown is propagated, if both the function and the close throw, the
/// exception from the function is propagated
Future<R> useCloseableAsync<R>(
  Closeable resource,
  FutureOr<R> Function(Closeable) fn,
) async {
  return resource.runAndCloseAsync(fn);
}
