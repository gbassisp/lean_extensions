import 'package:lean_extensions/src/range.dart';

const _base64 = '0123456789'
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    'abcdefghijklmnopqrstuvwxyz'
    '+/';
const _size = _base64.length;
final _mapped = {for (final i in range(_size)) _base64[i]: i};

String _toRadixString(BigInt number, int radix) {
  final valid = radix >= 2 && radix <= _size;
  if (!valid) {
    throw RangeError('Invalid value: Not in inclusive range 2..$_size: $radix');
  }

  if (number == BigInt.zero) {
    return '0';
  }

  var res = '';
  var n = number.abs();
  final b = BigInt.from(radix);
  while (n > BigInt.zero) {
    final r = (n % b).toInt();
    final c = _base64[r];
    res = '$c$res';
    n = n ~/ b;
  }

  return '${number.isNegative ? '-' : ''}$res';
}

/// converts a number from any base to a decimal number; numeral system
/// must be from base 10 to n, where n is between 2 and 64 inclusive
/// based on https://en.wikipedia.org/wiki/Base62 and
/// https://onlinelibrary.wiley.com/doi/abs/10.1002/spe.408
BigInt fromRadixString(String number, int radix) {
  final valid = radix >= 2 && radix <= _size;
  if (!valid) {
    throw RangeError('Invalid value: Not in inclusive range 2..$_size: $radix');
  }
  final n = number.replaceAll('-', '').trim();

  if (n.isEmpty) {
    throw ArgumentError.value(number);
  }

  var b = BigInt.one;
  final r = BigInt.from(radix);
  var res = BigInt.zero;
  final digits = n.split('').reversed;
  for (final d in digits) {
    final value = _mapped[d]!;
    res = res + b * BigInt.from(value);
    b = b * r;
  }

  return number.startsWith(RegExp(r'\s*-')) ? -res : res;
}

/// simple implementation of a number system conversion;
/// from base 10 to n, where n is between 2 and 64 inclusive
/// based on https://en.wikipedia.org/wiki/Base62 and
/// https://onlinelibrary.wiley.com/doi/abs/10.1002/spe.408
String toRadix(Object number, int radix) {
  return _toRadixString(BigInt.parse('$number'), radix);
}
