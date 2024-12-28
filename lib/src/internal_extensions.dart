import 'package:meta/meta.dart';

@internal
extension InternalLeanExtension on String {
  /// split this string into an [Iterable]<[String]> with each character
  Iterable<String> get chars => split('');
}
