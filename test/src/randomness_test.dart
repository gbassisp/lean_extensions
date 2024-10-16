import 'dart:math';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';

import 'randomness_test_utils.dart';

void main() {
  testRandomValidity(
    'nextIntBetween - 0~10',
    () => NextIntBetweenCase(0, 10),
  );
  testRandomValidity(
    'nextIntBetween - -10~10',
    () => NextIntBetweenCase(-10, 10),
  );
  testRandomValidity(
    'nextIntBetween - -1000~1000',
    () => NextIntBetweenCase(-1000, 1000),
  );
  testRandomValidity(
    'nextBigInt - short',
    () => NextBigIntCase(BigInt.from(10)),
  );
  testRandomValidity(
    'nextBigInt - long',
    () => NextBigIntCase(BigInt.from(100)),
  );
  testRandomValidity('nextChar', () => NextCharCase());
  testRandomValidity(
    'nextString - short',
    () => NextStringCase(1, string.base64digits),
  );
  testRandomValidity(
    'nextString - long',
    () => NextStringCase(3, string.digits),
  );
}

class NextIntBetweenCase extends RandomValidityCase<int> {
  NextIntBetweenCase(this.min, this.max);

  final int min;
  final int max;
  @override
  int get codomainSize => max - min;

  @override
  int generateNextValue(Random random) => random.nextIntBetween(min, max);
}

class NextBigIntCase extends RandomValidityCase<BigInt> {
  NextBigIntCase(this.max);

  final BigInt max;
  @override
  int get codomainSize => max.toInt();

  @override
  BigInt generateNextValue(Random random) => random.nextBigInt(max);
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

class NotRandomCase extends RandomValidityCase<int> {
  int i = 0;
  @override
  int get codomainSize => 10;

  @override
  int generateNextValue(Random random) {
    return ++i;
  }
}
