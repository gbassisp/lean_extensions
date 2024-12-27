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
    'nextIntBetween - -99~99',
    () => NextIntBetweenCase(-99, 99),
  );
  testRandomValidity(
    'nextIntBetween - -2000~-1500',
    () => NextIntBetweenCase(-2000, -1500),
  );

  // 100-length
  const a1 = '11111111111111111111111111111111111111111111'
      '11111111111111111111111111111111111111111111111111111111';
  // a1 + 200
  const a2 = '11111111111111111111111111111111111111111111'
      '11111111111111111111111111111111111111111111111111111311';
  final a = BigInt.parse(a1);
  final b = BigInt.parse(a2);
  testRandomValidity(
    'nextBigIntBetween - $a1~$a2',
    () => NextBigIntBetweenCase(a, b),
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

  @override
  bool valueIsValid(int value) => value >= min && value < max;
}

class NextBigIntCase extends NextBigIntBetweenCase {
  NextBigIntCase(BigInt max) : super(BigInt.zero, max);

  @override
  BigInt generateNextValue(Random random) => random.nextBigInt(this.max);
}

class NextBigIntBetweenCase extends RandomValidityCase<BigInt> {
  NextBigIntBetweenCase(this.min, this.max);

  final BigInt min;
  final BigInt max;
  @override
  int get codomainSize => (max - min).toInt();

  @override
  BigInt generateNextValue(Random random) => random.nextBigIntBetween(min, max);

  @override
  bool valueIsValid(BigInt value) => value >= min && value < max;
}

class NextCharCase extends RandomValidityCase<String> {
  @override
  int get codomainSize => string.printable.length;

  @override
  String generateNextValue(Random random) =>
      random.nextChar(chars: string.printable);

  @override
  bool valueIsValid(String value) => string.printable.contains(value);
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

  @override
  bool valueIsValid(String value) {
    final chars = value.chars.toSet();
    for (final c in chars) {
      if (!this.chars.contains(c)) {
        return false;
      }
    }
    return true;
  }
}
