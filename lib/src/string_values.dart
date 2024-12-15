/// Empty string: ''
const emptyString = string.empty;

/// chars used by base64 encoding
const base62chars = string.base62digits;

/// chars used by base64 encoding
const base64chars = string.base64digits;

// python inspired

/// The lowercase letters 'abcdefghijklmnopqrstuvwxyz'.
/// This value is not locale-dependent and will not change.
const asciiLowercase = string.asciiLowercase;

/// The uppercase letters 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
/// This value is not locale-dependent and will not change.
const asciiUppercase = string.asciiUppercase;

/// The concatenation of the [asciiLowercase] and [asciiUppercase] constants.
/// This value is not locale-dependent.
const asciiLetters = string.asciiLetters;

/// The string '0123456789'.
const digits = string.digits;

/// The string '0123456789abcdefABCDEF'.
const hexdigits = string.hexdigits;

/// The string '01234567'.
const octdigits = string.octdigits;

/// String of ASCII characters which are considered punctuation characters in
/// the C locale: !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~.
const punctuation = string.punctuation;

/// A string containing all ASCII characters that are considered whitespace.
/// This includes the characters space, tab, linefeed, return, formfeed,
/// and vertical tab.
const whitespace = string.whitespace;

/// a string containing all Unicode characters that are considered whitespace.
///
/// taken from https://en.wikipedia.org/wiki/Whitespace_character
const allWhitespace = string.allWhitespace;

/// all Unicode space characters with White_Space=yes
///
/// taken from https://en.wikipedia.org/wiki/Whitespace_character
const visibleWhitespace = string.visibleWhitespace;

/// all Unicode space characters with White_Space=no
///
/// taken from https://en.wikipedia.org/wiki/Whitespace_character
const invisibleWhitespace = string.invisibleWhitespace;

/// String of ASCII characters which are considered printable.
/// This is a combination of digits, ascii_letters, punctuation, and whitespace.
const printable = string.printable;

/// String of ASCII characters which are considered printable except spaces.
/// This is a combination of digits, ascii_letters, and punctuation.
const printableNoSpaces = string.printableNoSpaces;

/// static class to be used like in python
/// The constants defined as in python https://docs.python.org/3/library/string.html
// ignore: camel_case_types
class string {
  const string._();

  /// Empty string: ''
  static const empty = '';

  /// chars used by base64 encoding
  static const base62digits = digits + asciiUppercase + asciiLowercase;

  /// chars used by base64 encoding
  static const base64digits = '$base62digits+/';

  // python inspired

  /// The lowercase letters 'abcdefghijklmnopqrstuvwxyz'.
  /// This value is not locale-dependent and will not change.
  static const asciiLowercase = 'abcdefghijklmnopqrstuvwxyz';

  /// The uppercase letters 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
  /// This value is not locale-dependent and will not change.
  static const asciiUppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// The concatenation of the [asciiLowercase] and [asciiUppercase]  constants.
  /// This value is not locale-dependent.
  static const asciiLetters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// The string '0123456789'.
  static const digits = '0123456789';

  /// The string '0123456789abcdefABCDEF'.
  static const hexdigits = '0123456789abcdefABCDEF';

  /// The string '01234567'.
  static const octdigits = '01234567';

  /// String of ASCII characters which are considered punctuation characters in
  /// the C locale: !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~.
  static const punctuation = r'''!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''';

  /// A string containing all ASCII characters that are considered whitespace.
  /// This includes the characters space, tab, linefeed, return, formfeed,
  /// and vertical tab.
  static const whitespace = ' \u{0009}\n\r\u{000C}\u{2B7F}';

  /// a string containing all Unicode characters that are considered whitespace.
  ///
  /// taken from https://en.wikipedia.org/wiki/Whitespace_character
  static const allWhitespace =
      string.visibleWhitespace + string.invisibleWhitespace;

  /// all Unicode space characters with White_Space=yes
  ///
  /// taken from https://en.wikipedia.org/wiki/Whitespace_character
  static const visibleWhitespace = '\u{0009}'
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
  static const invisibleWhitespace = '\u{180E}'
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
  static const printableNoSpaces = digits + asciiLetters + punctuation;

  /// String of ASCII characters which are considered printable.
  /// This is a combination of digits, ascii_letters, punctuation,
  /// and whitespace.
  static const printable = printableNoSpaces + whitespace;
}
