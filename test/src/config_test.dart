import 'dart:math';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:lean_extensions/src/numeral_system.dart';
import 'package:test/test.dart';

void main() {
  group('config', () {
    test('random char and string', () {
      const iters = 1000000;
      // set to a low number of chars
      LeanExtensions.charactersForRandomChar = 'a';
      final chars = <String>{};
      final strings = <String>{};
      final r = Random();
      for (final _ in range(iters)) {
        chars.add(r.nextChar());
        strings.add(r.nextString(50));
      }

      expect(chars, {'a'});
      expect(strings, {'a' * 50});

      // set to a high number of chars
      const others = '$base64chars&^%#@!()';
      const count = others.length;
      LeanExtensions.charactersForRandomChar = others;
      chars.clear();
      strings.clear();
      final chars2 = <String>{};
      // r should not require a new object
      for (final _ in range(iters)) {
        chars.add(r.nextChar());
        final str = r.nextString(50);
        strings.add(str);
        chars2.addAll(str.split(''));
      }

      expect(chars.length, count);
      expect(chars2.length, count);
      expect(strings.length, iters);
    });
  });
}
