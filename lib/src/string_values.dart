/// Empty string: ''
const String emptyString = string.empty;

/// chars used by base64 encoding
const String base62chars = string.base62digits;

/// chars used by base64 encoding
const String base64chars = string.base64digits;

// python inspired

/// The lowercase letters 'abcdefghijklmnopqrstuvwxyz'.
/// This value is not locale-dependent and will not change.
const String asciiLowercase = string.asciiLowercase;

/// The uppercase letters 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
/// This value is not locale-dependent and will not change.
const String asciiUppercase = string.asciiUppercase;

/// The concatenation of the [asciiLowercase] and [asciiUppercase] constants.
/// This value is not locale-dependent.
const String asciiLetters = string.asciiLetters;

/// The string '0123456789'.
const String digits = string.digits;

/// The string '0123456789abcdefABCDEF'.
const String hexdigits = string.hexdigits;

/// The string '01234567'.
const String octdigits = string.octdigits;

/// String of ASCII characters which are considered punctuation characters in
/// the C locale: !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~.
const String punctuation = string.punctuation;

/// A string containing all ASCII characters that are considered whitespace.
/// This includes the characters space, tab, linefeed, return, formfeed,
/// and vertical tab.
const String whitespace = string.whitespace;

/// a string containing all Unicode characters that are considered whitespace.
///
/// taken from https://en.wikipedia.org/wiki/Whitespace_character
const String allWhitespace = string.allWhitespace;

/// all Unicode space characters with White_Space=yes
///
/// taken from https://en.wikipedia.org/wiki/Whitespace_character
const String visibleWhitespace = string.visibleWhitespace;

/// all Unicode space characters with White_Space=no
///
/// taken from https://en.wikipedia.org/wiki/Whitespace_character
const String invisibleWhitespace = string.invisibleWhitespace;

/// String of ASCII characters which are considered printable.
/// This is a combination of digits, ascii_letters, punctuation, and whitespace.
const String printable = string.printable;

/// String of ASCII characters which are considered printable except spaces.
/// This is a combination of digits, ascii_letters, and punctuation.
const String printableNoSpaces = string.printableNoSpaces;

/// static class to be used like in python
/// The constants defined as in python https://docs.python.org/3/library/string.html
// ignore: camel_case_types
class string {
  const string._();

  /// Empty string: ''
  static const String empty = '';

  /// chars used by base64 encoding
  static const String base62digits = digits + asciiUppercase + asciiLowercase;

  /// chars used by base64 encoding
  static const String base64digits = '$base62digits+/';

  // python inspired

  /// The lowercase letters 'abcdefghijklmnopqrstuvwxyz'.
  /// This value is not locale-dependent and will not change.
  static const String asciiLowercase = 'abcdefghijklmnopqrstuvwxyz';

  /// The uppercase letters 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
  /// This value is not locale-dependent and will not change.
  static const String asciiUppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// The concatenation of the [asciiLowercase] and [asciiUppercase]  constants.
  /// This value is not locale-dependent.
  static const String asciiLetters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// The string '0123456789'.
  static const String digits = '0123456789';

  /// The string '0123456789abcdefABCDEF'.
  static const String hexdigits = '0123456789abcdefABCDEF';

  /// The string '01234567'.
  static const String octdigits = '01234567';

  /// String of ASCII characters which are considered punctuation characters in
  /// the C locale: !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~.
  static const String punctuation = r'''!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''';

  /// A string containing all ASCII characters that are considered whitespace.
  /// This includes the characters space, tab, linefeed, return, formfeed,
  /// and vertical tab.
  static const String whitespace = ' \u{0009}\n\r\u{000C}\u{2B7F}';

  /// a string containing all Unicode characters that are considered whitespace.
  ///
  /// taken from https://en.wikipedia.org/wiki/Whitespace_character
  static const String allWhitespace =
      string.visibleWhitespace + string.invisibleWhitespace;

  /// all Unicode space characters with White_Space=yes
  ///
  /// taken from https://en.wikipedia.org/wiki/Whitespace_character
  static const String visibleWhitespace = '\u{0009}'
      '\u{000A}'
      '\u{000B}'
      '\u{000C}'
      '\u{000D}'
      '\u{0020}'
      '\u{0085}'
      '\u{00A0}'
      '\u{0020}'
      '\u{1680}'
      '\u{2000}'
      '\u{2002}'
      '\u{2001}'
      '\u{2003}'
      '\u{2002}'
      '\u{2002}'
      '\u{2003}'
      '\u{2003}'
      '\u{2004}'
      '\u{2005}'
      '\u{2006}'
      '\u{2007}'
      '\u{2008}'
      '\u{2009}'
      '\u{2008}'
      '\u{200A}'
      '\u{2028}'
      '\u{2029}'
      '\u{202F}'
      '\u{2009}'
      '\u{205F}'
      '\u{3000}';

  /// all Unicode space characters with White_Space=no
  ///
  /// taken from https://en.wikipedia.org/wiki/Whitespace_character
  static const String invisibleWhitespace = '\u{180E}'
      '\u{200B}'
      '\u{200C}'
      '\u{200D}'
      '\u{2060}'
      '\u{200B}'
      '\u{FEFF}'
      '\u{2060}'
      '\u{200B}';

  /// String of ASCII characters which are considered printable except spaces.
  /// This is a combination of digits, ascii_letters, and punctuation.
  static const String printableNoSpaces = digits + asciiLetters + punctuation;

  /// String of ASCII characters which are considered printable.
  /// This is a combination of digits, ascii_letters, punctuation,
  /// and whitespace.
  static const String printable = printableNoSpaces + whitespace;
}
