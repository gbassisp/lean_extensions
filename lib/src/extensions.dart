/// adds utility methods to [String]?
extension StringOrNullUtils on String? {
  /// returns non-nullable string
  String get orEmpty => this ?? '';
}

/// adds utility methods to [String]
extension StringUtils on String {
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
extension NumUtils on num {
  /// pads left with number of zeros
  String withLeading(int width) => toString().padLeft(width, '0');
}

/// adds utility methods to [DateTime]
extension DateUtils on DateTime {
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
  String toIso8601Date() => '$year-${month.withLeading(2)}-${day.withLeading(2)}';
}

/// adds utility methods to [Iterable]
extension IterableOrNullUtils<T> on Iterable<T>? {
  /// returns non-nullable iterable
  Iterable<T> get orEmpty => this ?? [];
}
