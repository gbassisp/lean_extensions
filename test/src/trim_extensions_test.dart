import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

void main() {
  const regexps = [
    '[a-z]',
    // '[a-z]?',
  ];
  for (final re in regexps) {
    group('trim extensions - simple RegExp(re)', () {
      const a = 'abc12h3def';
      final letters = RegExp(re);
      test('trimPattern', () {
        final trimmed = a.trimPattern(letters);

        expect(trimmed, equals('12h3'));
      });
      test('trimPatternLeft', () {
        final trimmed = a.trimPatternLeft(letters);

        expect(trimmed, equals('12h3def'));
      });
      test('trimPatternRight', () {
        final trimmed = a.trimPatternRight(letters);

        expect(trimmed, equals('abc12h3'));
      });
    });
  }
  group('trim extensions - with string "a"', () {
    const str = 'abc12h3def';
    const a = 'a';
    test('trimPattern', () {
      final trimmed = str.trimPattern(a);

      expect(trimmed, equals('bc12h3def'));
    });
    test('trimPatternLeft', () {
      final trimmed = str.trimPatternLeft(a);

      expect(trimmed, equals('bc12h3def'));
    });
    test('trimPatternRight', () {
      final trimmed = str.trimPatternRight(a);

      expect(trimmed, equals('abc12h3def'));
    });
  });
  group('trim extensions - with string "b"', () {
    const str = 'abc12h3def';
    const b = 'b';
    test('trimPattern', () {
      final trimmed = str.trimPattern(b);

      expect(trimmed, equals('abc12h3def'));
    });
    test('trimPatternLeft', () {
      final trimmed = str.trimPatternLeft(b);

      expect(trimmed, equals('abc12h3def'));
    });
    test('trimPatternRight', () {
      final trimmed = str.trimPatternRight(b);

      expect(trimmed, equals('abc12h3def'));
    });
  });
}
