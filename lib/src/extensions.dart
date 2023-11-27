// ignore_for_file: unnecessary_cast

import 'dart:math';

import 'package:any_date/any_date.dart';

/// adds utility methods to [String]?
extension StringOrNullExtensions on String? {
  /// returns non-nullable string
  String get orEmpty => this ?? '';

  /// checks if string is null or empty
  bool get isNullOrEmpty => orEmpty.isEmpty;
}

const _anyDate = AnyDate();

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
  DateTime? tryToDateTime() => _anyDate.tryParse(this);

  /// converts to DateTime
  DateTime toDateTime() => _anyDate.parse(this);

  /// converts to DateTime without time component
  DateTime? tryToDate() => tryToDateTime()?.dateOnly;

  /// converts to DateTime without time component
  DateTime toDate() => toDateTime().dateOnly;

  /// naive implementation of sentence case, not using locale; this works for
  /// english, but has no guarantees for other languages
  String toSentenceCase() {
    return (length <= 1)
        ? toUpperCase()
        : '${substring(0, 1).toUpperCase()}' '${substring(1).toLowerCase()}';
  }
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

/// adds limit extensions on [Comparable]
extension ComparableExtensions<T extends Comparable<T>> on T {
  bool _smallerThan(T other) => compareTo(other) < 0;
  bool _greaterThan(T other) => compareTo(other) > 0;

  T _min(T other) => _smallerThan(other) ? this : other;
  T _max(T other) => _greaterThan(other) ? this : other;

  // these are implemented here and re-used by the extensions below because
  //the compiler can't see it on int and double
  T _limitTo(T min, T max) {
    assert(min.compareTo(max) <= 0, 'expected min ($min) <= max ($max)');
    final l = min._min(max);
    final u = max._max(min);
    return _withLowerLimit(l)._withUpperLimit(u);
  }

  T _withUpperLimit(T max) => _smallerThan(max) ? this : max;
  T _withLowerLimit(T min) => _greaterThan(min) ? this : min;

  /// returns this if it is between [min] and [max] (inclusive)
  /// otherwise returns [min] or [max] whichever is closer
  T limitTo(T min, T max) => _limitTo(min, max);

  /// returns this if it is not greater than [max], otherwise [max]
  T withUpperLimit(T max) => _withUpperLimit(max);

  /// returns this if it is not greater than [max], otherwise [max]
  T withLowerLimit(T min) => _withLowerLimit(min);
}

/// includes [ComparableExtensions] on double
extension DoubleExtensions on double {
  /// returns this if it is between [min] and [max] (inclusive)
  /// otherwise returns [min] or [max] whichever is closer
  double limitTo(double min, double max) =>
      (this as num)._limitTo(min, max).toDouble();

  /// returns this if it is not greater than [max], otherwise [max]
  double withUpperLimit(double max) =>
      (this as num)._withUpperLimit(max).toDouble();

  /// returns this if it is not greater than [max], otherwise [max]
  double withLowerLimit(double min) =>
      (this as num)._withLowerLimit(min).toDouble();
}

/// includes [ComparableExtensions] on double
extension IntExtensions on int {
  /// returns this if it is between [min] and [max] (inclusive)
  /// otherwise returns [min] or [max] whichever is closer
  int limitTo(int min, int max) => (this as num)._limitTo(min, max).toInt();

  /// returns this if it is not greater than [max], otherwise [max]
  int withUpperLimit(int max) => (this as num)._withUpperLimit(max).toInt();

  /// returns this if it is not greater than [max], otherwise [max]
  int withLowerLimit(int min) => (this as num)._withLowerLimit(min).toInt();
}

/// adds utility methods to [Iterable]
extension IterableOrNullExtensions<T> on Iterable<T>? {
  /// returns non-nullable iterable
  Iterable<T> get orEmpty => this ?? [];
}

/// adds utility methods to [Iterable]
extension IterableExtensions<T> on Iterable<T> {
  /// returns this iterable as a fixed-length list
  List<T> toArray() => toList(growable: false);

  /// returns item at [index] or null
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) {
      return null;
    }

    return elementAt(index);
  }

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

  /// separates an iterable with [separator] and cast to list
  List<T> separatedList(T separator) => separated(separator).toList();

  /// wraps an iterable with [item] at the start and end
  Iterable<T> wrapped(T item) => isEmpty ? this : [item, ...this, item];

  /// wraps an iterable with [item] at the start and end and cast to list
  List<T> wrappedList(T item) => wrapped(item).toList();
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
