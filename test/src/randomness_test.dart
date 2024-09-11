import 'dart:math';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';

import 'randomness_test_utils.dart';

void main() {
  testRandomValidity('nextChar', () => NextCharCase());
  testRandomValidity(
    'nextString - short',
    () => NextStringCase(2, string.base64digits),
  );
  testRandomValidity(
    'nextString - long',
    () => NextStringCase(5, string.digits),
  );
}

class NextCharCase extends RandomValidityCase<String> {
  @override
  int get codomainSize => string.printable.length;

  @override
  String generateNextValue(Random random) =>
      random.nextChar(chars: string.printable);
}

class NextStringCase extends RandomValidityCase<String> {
  NextStringCase(this.length, this.chars);

  final int length;
  final String chars;

  @override
  int get codomainSize => pow(chars.length, length).toInt();

  @override
  String generateNextValue(Random random) =>
      random.nextString(length: length, chars: chars);
}
