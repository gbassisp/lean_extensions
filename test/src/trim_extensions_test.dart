import 'package:lean_extensions/lean_extensions.dart';
import 'package:lean_extensions/src/string_values.dart';
import 'package:test/test.dart';

void main() {
  const regexps = [
    '[a-z]',
    '[a-z]?',
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
  group('trim extensions - with string "ab"', () {
    const str = 'abc12h3def';
    const b = 'ab';
    test('trimPattern', () {
      final trimmed = str.trimPattern(b);

      expect(trimmed, equals('c12h3def'));
    });
    test('trimPatternLeft', () {
      final trimmed = str.trimPatternLeft(b);

      expect(trimmed, equals('c12h3def'));
    });
    test('trimPatternRight', () {
      final trimmed = str.trimPatternRight(b);

      expect(trimmed, equals('abc12h3def'));
    });
  });
  group('trim extensions - with string "ef"', () {
    const str = 'abc12h3def';
    const b = 'ef';
    test('trimPattern', () {
      final trimmed = str.trimPattern(b);

      expect(trimmed, equals('abc12h3d'));
    });
    test('trimPatternLeft', () {
      final trimmed = str.trimPatternLeft(b);

      expect(trimmed, equals('abc12h3def'));
    });
    test('trimPatternRight', () {
      final trimmed = str.trimPatternRight(b);

      expect(trimmed, equals('abc12h3d'));
    });
  });
  group('trim extensions - with empty string', () {
    const str = 'abc12h3def';
    test('trimPattern', () {
      final trimmed = str.trimPattern(string.empty);

      expect(trimmed, equals('abc12h3def'));
    });
    test('trimPatternLeft', () {
      final trimmed = str.trimPatternLeft(string.empty);

      expect(trimmed, equals('abc12h3def'));
    });
    test('trimPatternRight', () {
      final trimmed = str.trimPatternRight(string.empty);

      expect(trimmed, equals('abc12h3def'));
    });
  });

  group('trimInvisible', () {
    var i = 0;
    final spaces = string.invisibleWhitespace.split('');
    const placeholder = '%HERE%';
    const restOfString = '-rest of string $placeholder-';
    const str = '$placeholder$placeholder$restOfString$placeholder$placeholder';
    for (final s in spaces) {
      final untrimmed = str.replaceAll(placeholder, s);
      final trimmed = restOfString.replaceAll(placeholder, s);
      test('$i - when space is $s in $untrimmed', () {
        expect(untrimmed.trimInvisible(), equals(trimmed));
      });
      i++;
    }
  });
}
