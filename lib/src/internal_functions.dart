import 'dart:math';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:lean_extensions/src/exceptions.dart';
import 'package:meta/meta.dart';

final _one = BigInt.one;
final _ten = BigInt.from(10);

@internal
BigInt nextBigIntComplete(Random random, BigInt max) {
  try {
    try {
      return nextBigInt1(random, max);
    } on InternalException catch (_) {
      return nextBigIntInclusive(random, max - _one);
    }
  } on InternalException catch (_) {
    return nextBigIntNotEvenlyDistributed(random, max);
  }
}

@internal
BigInt nextBigInt1(Random random, BigInt max) {
  if (max <= BigInt.zero) {
    throw RangeError(
      '$max must be greater than 0 to generate number between 0 and $max',
    );
  }

  final size = max.abs().toString().length;
  var res = _ten;
  for (final _ in range(100)) {
    final a = random.nextString(length: size, chars: string.digits);
    res = BigInt.parse(a);
    if (res < max) {
      return res;
    }
  }

  throw InternalException(
    'Unable to generate a random number between 0 and $max',
  );
}

@internal
BigInt nextBigIntInclusive(Random random, BigInt max) {
  if (max <= BigInt.zero) {
    throw RangeError(
      '$max must be greater than 0 to generate number between 0 and $max',
    );
  }

  final str = max.abs().toString();
  final size = str.length;
  final digits = str.chars.map(int.parse).toArray();
  final res = List<int>.filled(size, 0);
  var equalToUpperLimit = true;
  for (final i in range(size)) {
    final d = digits[i];
    final limit = equalToUpperLimit ? d + 1 : 10;
    final n = random.nextInt(limit);
    if (equalToUpperLimit) {
      equalToUpperLimit = n == d;
    }
    res[i] = n;
  }

  final r = BigInt.parse(res.join());
  if (r <= max) {
    return r;
  }

  throw InternalException(
    'Attempt to generate a random number between 0 and $max resulted in $r.\n'
    'This is definitely a bug',
  );
}

@internal
BigInt nextBigIntNotEvenlyDistributed(Random random, BigInt max) {
  if (max <= BigInt.zero) {
    throw RangeError(
      '$max must be greater than 0 to generate number between 0 and $max',
    );
  }

  if (max < _ten) {
    return BigInt.from(random.nextInt(max.toInt()));
  }
  final size = max.abs().toString().length;
  // using size - 1 ensures our value is less than max
  // but it also means it's not evenly distributed.
  // e.g., if max == 1100, then values from 1000 to 1099 inclusive will never
  // be returned
  final a = random.nextString(length: size - 1, chars: string.digits);
  final b = BigInt.parse(a);
  return b;
}
