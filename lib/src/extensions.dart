/// adds utility methods to [String]?
extension StringOrNullUtils on String? {
  /// returns non-nullable string
  String get orEmpty => orElse('');

  /// returns non-nullable string, defaulting to passed value
  String orElse(String value) => this ?? value;
}

/// adds utility methods to [String]
extension StringUtils on String {
  /// tries to convert string to num
  num? tryToNum() => num.tryParse(this);

  /// converts to num
  num toNum() => num.parse(this);

  /// tries to convert string to int
  int? tryToInt() => int.tryParse(this);

  /// converts to int
  int toInt() => int.parse(this);

  /// tries to convert string to double
  double? tryToDouble() => double.tryParse(this);

  /// converts to double
  double toDouble() => double.parse(this);

  /// tries to convert string to DateTime
  DateTime? tryToDateTime() => DateTime.tryParse(this);

  /// converts to DateTime
  DateTime toDateTime() => DateTime.parse(this);

  /// converts to DateTime without time component
  DateTime? tryToDate() => tryToDateTime()?.dateOnly;

  /// converts to DateTime without time component
  DateTime toDate() => toDateTime().dateOnly;
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
}
