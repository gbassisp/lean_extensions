const _base64 = '0123456789'
    'abcdefghijklmnopqrstuvwxyz'
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    '+_';
const _size = _base64.length;

String _toRadixString(BigInt number, int base) {
  final valid = base >= 2 && base <= _size;
  if (!valid) {
    throw RangeError('Invalid value: Not in inclusive range 2..$_size: $base');
  }

  if (number == BigInt.zero) {
    return '0';
  }

  var res = '';
  var n = number.abs();
  final b = BigInt.from(base);
  while (n > BigInt.zero) {
    final r = (n % b).toInt();
    final c = _base64[r];
    res = '$c$res';
    n = n ~/ b;
  }

  return '${number.isNegative ? '-' : ''}$res';
}

/// simple implementation of a number system conversion;
/// from base 10 to n, where n is between 2 and 64 inclusive
String toRadix(Object number, int base) {
  return _toRadixString(BigInt.parse('$number'), base);
}
