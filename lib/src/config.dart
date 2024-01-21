import 'package:lean_extensions/src/numeral_system.dart';

/// utility class to configure the default behavior of extensions
class LeanExtensions {
  LeanExtensions._();

  /// characters to be used on Random().nextChar() and Random().nextString();
  ///
  /// Defaults to [base62chars]
  static String charactersForRandomChar = base62chars;
}
