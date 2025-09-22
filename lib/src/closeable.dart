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

  bool _closed = false;

  /// Whether this resource has been closed
  bool get isClosed => _closed;

  /// Inner closeables. If this resource manages other closeables, they should
  /// be returned here, so they can be closed when this resource is closed.
  /// If there are no inner closeables, return empty iterable
  @protected
  Iterable<Closeable> get closeables;
}

Never _wrapAndThrow(Object e) {
  if (e is Exception) {
    throw e;
  } else if (e is Error) {
    throw e;
  } else {
    throw Exception('Unknown exception: $e');
  }
}

/// Extension methods for [Closeable]
extension CloseableExtensions<C extends Closeable> on C {
  void _closeSync() {
    // using a getter resolves unused futures warning withtout disabling it
    close().hashCode;
  }

  Future<void> _closeAsync() async {
    await close();
  }

  /// Runs passed function and closes this resource after it
  /// Closes the resource even if the function throws. The first exception
  /// thrown is propagated, if both the function and the close throw, the
  /// exception from the function is propagated
  R runAndClose<R>(R Function(C p0) fn) {
    Object? exception;
    if (_closed) {
      exception = StateError('Resource is already closed');
    }
    R? result;
    try {
      result = fn(this);
    } on Object catch (e) {
      exception ??= e;
    }

    try {
      _closeSync();
    } on Object catch (e) {
      exception ??= e;
    }

    for (final closeable in closeables) {
      try {
        closeable.runAndClose<void>((_) {});
      } on Object catch (e) {
        exception ??= e;
      }
    }

    _closed = true;
    if (exception != null) {
      _wrapAndThrow(exception);
    }

    return result as R;
  }

  /// Runs passed function and closes this resource after it
  /// Closes the resource even if the function throws. The first exception
  /// thrown is propagated, if both the function and the close throw, the
  /// exception from the function is propagated
  Future<R> runAndCloseAsync<R>(FutureOr<R> Function(C p0) fn) async {
    Object? exception;
    if (_closed) {
      exception = StateError('Resource is already closed');
    }
    R? result;
    try {
      result = await fn(this);
    } on Object catch (e) {
      exception ??= e;
    }

    try {
      await _closeAsync();
    } on Object catch (e) {
      exception ??= e;
    }

    final Iterable<Object?> futures = await Future.wait(
      closeables.map(
        (c) => c
            .runAndCloseAsync((_) => null as Object?)
            .catchError((Object e) => e),
      ),
    );
    exception ??= futures.firstWhere(
      (e) => e != null,
      orElse: () => null,
    );

    _closed = true;
    if (exception != null) {
      _wrapAndThrow(exception);
    } else {
      return result as R;
    }
  }
}

/// Runs passed function and closes this resource after it
/// Closes the resource even if the function throws. The first exception
/// thrown is propagated, if both the function and the close throw, the
/// exception from the function is propagated
R useCloseable<R, C extends Closeable>(
  C resource,
  R Function(C p0) fn,
) {
  return resource.runAndClose<R>(fn);
}

/// Runs passed function and closes this resource after it
/// Closes the resource even if the function throws. The first exception
/// thrown is propagated, if both the function and the close throw, the
/// exception from the function is propagated
Future<R> useCloseableAsync<R, C extends Closeable>(
  C resource,
  FutureOr<R> Function(C p0) fn,
) async {
  return resource.runAndCloseAsync<R>(fn);
}
