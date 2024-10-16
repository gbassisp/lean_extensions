/// represents an [Exception] thrown in the library that should
/// always be handled internally
class InternalException implements Exception {
  /// const constructor for [InternalException]
  const InternalException(this._message);
  final String _message;

  @override
  String toString() => 'InternalException($_message)';
}
