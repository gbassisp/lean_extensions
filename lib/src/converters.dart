import 'package:json_annotation/json_annotation.dart';

/// A convenience wrapper around [JsonConverter] that implement default toJson()
abstract class ToDynamicConverter<T> extends JsonConverter<T, dynamic> {
  /// default const constructor
  const ToDynamicConverter();

  @override
  dynamic toJson(T object) => object;
}
