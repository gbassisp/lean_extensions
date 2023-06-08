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
class AnyStringOrNull extends ToDynamicConverter<String?> {
  /// default const constructor
  const AnyStringOrNull();

  @override
  String? fromJson(dynamic json) => json?.toString();
}

const _stringOrNull = AnyStringOrNull();

/// casts into string if not null, otherwise casts to empty string
class AnyString extends ToDynamicConverter<String> {
  /// default const constructor
  const AnyString();

  @override
  String fromJson(dynamic json) => _stringOrNull.fromJson(json).orEmpty;
}

const _string = AnyString();

/// converts to nullable int
class AnyIntOrNull extends ToDynamicConverter<int?> {
  /// default const constructor
  const AnyIntOrNull();

  @override
  int? fromJson(dynamic json) => _string.fromJson(json).tryToInt();
}

/// converts to int
class AnyInt extends ToDynamicConverter<int> {
  /// default const constructor
  const AnyInt();

  @override
  int fromJson(dynamic json) => _string.fromJson(json).toInt();
}

/// converts to nullable double
class AnyDoubleOrNull extends ToDynamicConverter<double?> {
  /// default const constructor
  const AnyDoubleOrNull();

  @override
  double? fromJson(dynamic json) => _string.fromJson(json).tryToDouble();
}

/// converts to double
class AnyDouble extends ToDynamicConverter<double> {
  /// default const constructor
  const AnyDouble();

  @override
  double fromJson(dynamic json) => _string.fromJson(json).toDouble();
}

/// converts to nullable DateTime
class AnyDateTimeOrNull extends ToDynamicConverter<DateTime?> {
  /// default const constructor
  const AnyDateTimeOrNull();

  @override
  DateTime? fromJson(dynamic json) => _string.fromJson(json).tryToDateTime();

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}

/// converts to DateTime
class AnyDateTime extends ToDynamicConverter<DateTime> {
  /// default const constructor
  const AnyDateTime();

  @override
  DateTime fromJson(dynamic json) => _string.fromJson(json).toDateTime();

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

/// converts to nullable DateTime without the time component
class AnyDateOrNull extends ToDynamicConverter<DateTime?> {
  /// default const constructor
  const AnyDateOrNull();

  @override
  DateTime? fromJson(dynamic json) => _string.fromJson(json).tryToDate();

  @override
  String? toJson(DateTime? object) => object?.toIso8601Date();
}

/// converts to DateTime without the time component
class AnyDate extends ToDynamicConverter<DateTime> {
  /// default const constructor
  const AnyDate();

  @override
  DateTime fromJson(dynamic json) => _string.fromJson(json).toDate();

  @override
  String toJson(DateTime object) => object.toIso8601Date();
}
