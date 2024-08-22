import 'package:lean_extensions/src/string_values.dart';
import 'package:test/test.dart';

void main() {
  group('string_values.dart', () {
    test('sanity check - top-level values', () {
      expect(emptyString, equals(''));
      expect(base64chars, contains(base62chars));
      expect(asciiLetters, contains(asciiLowercase));
      expect(asciiLetters, contains(asciiUppercase));
      expect(digits, contains(octdigits));
      expect(printable, contains(digits));
      expect(printable, contains(asciiUppercase));
      expect(printable, contains(asciiLowercase));
      expect(printable, contains(punctuation));
      expect(printable, contains(whitespace));
      expect(printableNoSpaces, isNot(contains(whitespace)));
    });
    test('sanity check - string class', () {
      expect(string.empty, equals(''));
      expect(string.base64digits, contains(string.base62digits));
      expect(string.asciiLetters, contains(string.asciiLowercase));
      expect(string.asciiLetters, contains(string.asciiUppercase));
      expect(string.digits, contains(string.octdigits));
      expect(string.printable, contains(string.digits));
      expect(string.printable, contains(string.asciiUppercase));
      expect(string.printable, contains(string.asciiLowercase));
      expect(string.printable, contains(string.punctuation));
      expect(string.printable, contains(string.whitespace));
      expect(string.printableNoSpaces, isNot(contains(string.whitespace)));
    });
    test('sanity check - top level and class are equals', () {
      expect(emptyString, equals(string.empty));
      expect(base62chars, equals(string.base62digits));
      expect(base64chars, equals(string.base64digits));
      expect(asciiLowercase, equals(string.asciiLowercase));
      expect(asciiUppercase, equals(string.asciiUppercase));
      expect(asciiLetters, equals(string.asciiLetters));
      expect(digits, equals(string.digits));
      expect(hexdigits, equals(string.hexdigits));
      expect(octdigits, equals(string.octdigits));
      expect(punctuation, equals(string.punctuation));
      expect(whitespace, equals(string.whitespace));
      expect(printable, equals(string.printable));
      expect(printableNoSpaces, equals(string.printableNoSpaces));
    });
  });
}
