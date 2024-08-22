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

  /// String of ASCII characters which are considered printable except spaces.
  /// This is a combination of digits, ascii_letters, and punctuation.
  static const printableNoSpaces = digits + asciiLetters + punctuation;

  /// String of ASCII characters which are considered printable.
  /// This is a combination of digits, ascii_letters, punctuation,
  /// and whitespace.
  static const printable = printableNoSpaces + whitespace;
}
