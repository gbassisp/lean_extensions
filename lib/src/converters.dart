import 'package:json_annotation/json_annotation.dart';
import 'package:lean_extensions/src/extensions.dart';

/// A convenience wrapper around [JsonConverter] that implement default toJson()
abstract class ToDynamicConverter<T> extends JsonConverter<T, dynamic> {
  /// default const constructor
  const ToDynamicConverter();
  @override
  dynamic toJson(T object) => object;
}

/// casts into nullable string
class AnyNullableStringConverter extends ToDynamicConverter<String?> {
  /// default const constructor
  const AnyNullableStringConverter();

  @override
  String? fromJson(dynamic json) => json?.toString();
}

const _stringOrNull = AnyNullableStringConverter();

/// casts into string if not null, otherwise casts to empty string
class AnyStringConverter extends ToDynamicConverter<String> {
  /// default const constructor
  const AnyStringConverter();

  @override
  String fromJson(dynamic json) => _stringOrNull.fromJson(json).orEmpty;
}

const _string = AnyStringConverter();

/// converts to nullable int
class AnyNullableIntConverter extends ToDynamicConverter<int?> {
  /// default const constructor
  const AnyNullableIntConverter();

  @override
  int? fromJson(dynamic json) => _string.fromJson(json).tryToInt();
}

/// converts to int
class AnyIntConverter extends ToDynamicConverter<int> {
  /// default const constructor
  const AnyIntConverter();

  @override
  int fromJson(dynamic json) => _string.fromJson(json).toInt();
}

/// converts to nullable double
class AnyNullableDoubleConverter extends ToDynamicConverter<double?> {
  /// default const constructor
  const AnyNullableDoubleConverter();

  @override
  double? fromJson(dynamic json) => _string.fromJson(json).tryToDouble();
}

/// converts to double
class AnyDoubleConverter extends ToDynamicConverter<double> {
  /// default const constructor
  const AnyDoubleConverter();

  @override
  double fromJson(dynamic json) => _string.fromJson(json).toDouble();
}

/// converts to nullable DateTime
class AnyNullableDateTimeConverter extends ToDynamicConverter<DateTime?> {
  /// default const constructor
  const AnyNullableDateTimeConverter();

  @override
  DateTime? fromJson(dynamic json) => _string.fromJson(json).tryToDateTime();

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}

/// converts to DateTime
class AnyDateTimeConverter extends ToDynamicConverter<DateTime> {
  /// default const constructor
  const AnyDateTimeConverter();

  @override
  DateTime fromJson(dynamic json) => _string.fromJson(json).toDateTime();

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

/// converts to nullable DateTime without the time component
class AnyNullableDateConverter extends ToDynamicConverter<DateTime?> {
  /// default const constructor
  const AnyNullableDateConverter();

  @override
  DateTime? fromJson(dynamic json) => _string.fromJson(json).tryToDate();

  @override
  String? toJson(DateTime? object) => object?.toIso8601Date();
}

/// converts to DateTime without the time component
class AnyDateConverter extends ToDynamicConverter<DateTime> {
  /// default const constructor
  const AnyDateConverter();

  @override
  DateTime fromJson(dynamic json) => _string.fromJson(json).toDate();

  @override
  String toJson(DateTime object) => object.toIso8601Date();
}
