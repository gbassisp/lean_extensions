import 'dart:math';

/// adds utility methods to [String]?
extension StringOrNullExtensions on String? {
  /// returns non-nullable string
  String get orEmpty => this ?? '';

  /// checks if string is null or empty
  bool get isNullOrEmpty => orEmpty.isEmpty;
}

/// adds utility methods to [String]
extension StringExtensions on String {
  /// tries to convert string to num
  num? tryToNum() => num.tryParse(this);

  /// converts to num
  num toNum() => num.parse(this);

  /// tries to convert string to int
  int? tryToInt() => tryToNum()?.toInt();

  /// converts to int
  int toInt() => toNum().toInt();

  /// tries to convert string to double
  double? tryToDouble() => tryToNum()?.toDouble();

  /// converts to double
  double toDouble() => toNum().toDouble();

  /// tries to convert string to DateTime
  DateTime? tryToDateTime() => DateTime.tryParse(this);

  /// converts to DateTime
  DateTime toDateTime() => DateTime.parse(this);

  /// converts to DateTime without time component
  DateTime? tryToDate() => tryToDateTime()?.dateOnly;

  /// converts to DateTime without time component
  DateTime toDate() => toDateTime().dateOnly;
}

/// adds utility methods to [num]
extension NumExtensions on num {
  bool get _isValid => !isNaN;

  /// checks if number is positive
  bool get isPositive => _isValid && this > 0;

  /// checkis if number is non negative
  bool get isNonNegative => _isValid && !isNegative || isZero;

  /// checkis if number is non positive
  bool get isNonPositive => _isValid && !isPositive || isZero;

  /// makes == 0 more readable
  bool get isZero => _isValid && abs() == 0.0;

  /// pads left with number of zeros
  String withLeading(int width) {
    if (this is int) {
      return '${this < 0 ? '-' : ''}${abs().toString().padLeft(width, '0')}';
    } else {
      return '${floor().withLeading(width)}.'
          '${(this - floor()).toString().split('.').last}';
    }
  }

  /// specifies number of decimal places
  double toPrecision(int places) => toStringAsFixed(places).toDouble();

  /// checks if is multiple of [number]
  bool isMultipleOf(num number) {
    if (number.isZero) {
      return false;
    }

    return (this % number).isZero;
  }
}

/// adds utility methods to [DateTime]
extension DateExtensions on DateTime {
  /// copy with
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// date only
  DateTime get dateOnly => DateTime(year, month, day);

  /// converts to Iso8601 date date only (yyyy-MM-dd)
  String toIso8601Date() {
    return '$year-${month.withLeading(2)}-${day.withLeading(2)}';
  }
}

/// adds utility methods to [Iterable]
extension IterableOrNullExtensions<T> on Iterable<T>? {
  /// returns non-nullable iterable
  Iterable<T> get orEmpty => this ?? [];
}

/// adds utility methods to [Iterable]
extension IterableExtensions<T> on Iterable<T> {
  /// shifts left by [count]
  Iterable<T> shiftLeft([int count = 1]) {
    if (count < 0) {
      return shiftRight(count.abs());
    }
    if (count.isZero) {
      return [...this];
    }
    // allow circular shift
    final c = count % length;

    return skip(c).followedBy(take(c));
  }

  /// shifts right by [count]
  Iterable<T> shiftRight([int count = 1]) {
    if (count < 0) {
      return shiftLeft(count.abs());
    }
    if (count.isZero) {
      return [...this];
    }
    // allow circular shift
    final c = count % length;

    return skip(length - c).followedBy(take(length - c));
  }

  /// separates an iterable with [separator] only between items;
  /// i.e., not at the start or end
  Iterable<T> separated(T separator) sync* {
    var first = true;
    for (final item in this) {
      if (first) {
        first = false;
      } else {
        yield separator;
      }

      yield item;
    }
  }

  /// wraps an iterable with [item] at the start and end
  Iterable<T> wrapped(T item) => isEmpty ? this : [item, ...this, item];
}

/// adds utility methods on [Random] to generate strings
extension RandomExtensions on Random {
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      'abcdefghijklmnopqrstuvwxyz'
      '0123456789';
  static final _symbols = _chars.split('');

  /// generates random character
  String nextChar() {
    final result = _symbols[nextInt(_symbols.length)];

    return result;
  }

  /// generates random string of length [length]
  String nextString([int length = 32]) {
    final result = List.generate(length, (index) => nextChar()).join();
    return result;
  }
}
