import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:lean_extensions/src/extensions.dart';

/// A convenience wrapper around [JsonConverter] that implement default toJson()
abstract class ToDynamicConverter<T> extends JsonConverter<T, dynamic> {
  /// default const constructor
  const ToDynamicConverter();
  @override
  dynamic toJson(T object) => object;
}

/// Converts [Object]? into [bool] using its "truthy" value
///
/// **NOTE** extremely opinionated
class AnyBoolConverter extends ToDynamicConverter<bool> {
  /// default const constructor
  const AnyBoolConverter();
  @override
  bool fromJson(Object? json) => json.toBoolean();
}

/// Converts [Object]? into [bool]? using its "truthy" value
///
/// **NOTE** extremely opinionated
class AnyNullableBoolConverter extends ToDynamicConverter<bool?> {
  /// default const constructor
  const AnyNullableBoolConverter();
  @override
  bool? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    return json.toBoolean();
  }
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

/// converts to nullable num
class AnyNullableNumConverter extends ToDynamicConverter<num?> {
  /// default const constructor
  const AnyNullableNumConverter();

  @override
  num? fromJson(dynamic json) => _string.fromJson(json).tryToNum();
}

/// converts to num
class AnyNumConverter extends ToDynamicConverter<num> {
  /// default const constructor
  const AnyNumConverter();

  @override
  num fromJson(dynamic json) => _string.fromJson(json).toNum();
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

/// converts to Uri
class AnyUriConverter extends ToDynamicConverter<Uri> {
  /// default const constructor
  const AnyUriConverter();

  @override
  Uri fromJson(dynamic json) => Uri.parse(_string.fromJson(json));

  @override
  String toJson(Uri object) => object.toString();
}

/// converts to Uri if not null, otherwise returns null
class AnyUriOrNullConverter extends ToDynamicConverter<Uri?> {
  /// default const constructor
  const AnyUriOrNullConverter();

  static const _converter = AnyUriConverter();

  @override
  Uri? fromJson(dynamic json) =>
      json == null ? null : _converter.fromJson(json);

  @override
  String? toJson(Uri? object) =>
      object == null ? null : _converter.toJson(object);
}

/// converts to Uri if not null, otherwise returns null
class AnyBytesConverter extends ToDynamicConverter<Uint8List> {
  /// default const constructor
  const AnyBytesConverter({this.encodeToHex = false});

  /// optional flag to use hexadecimal notation when encoding [toJson]
  /// e.g., 0x12AB34
  ///
  /// This does not change [fromJson], because it checks for this regardless
  final bool encodeToHex;

  static final _hexRegex =
      RegExp('(?<pair>[0-9,a-f]{2})', caseSensitive: false);

  static final _fullHexRegex =
      RegExp('0x([0-9,a-f]{2})+', caseSensitive: false);

  static Iterable<String> _extractGroups(Iterable<RegExpMatch> matches) sync* {
    for (final match in matches) {
      yield match.namedGroup('pair').orEmpty;
    }
  }

  static Uint8List _fromString(String json) {
    if (json.startsWith('0x') && _fullHexRegex.hasMatch(json)) {
      final matches = _hexRegex.allMatches(json.substring(2));
      final extracted = _extractGroups(matches);
      final ints = extracted.map((pair) {
        assert(pair.length == 2, 'expected a hexadecimal byte $pair');
        return int.parse(pair, radix: 16);
      });
      final result = ints.toArray();
      assert(
        () {
          final resLength = result.length;
          final expected =
              // total length of 0x010203
              // minus the preffix 0x
              // divided by 2 (pairs of hex)
              (json.length - 2) / 2;

          return resLength == expected;
        }(),
        'res $result has length ${result.length} '
        'but expected ${(json.length - 2) / 2}',
      );
      return Uint8List.fromList(result);
    } else {
      return Uint8List.fromList(json.codeUnits);
    }
  }

  @override
  Uint8List fromJson(dynamic json) {
    if (json is String) {
      return _fromString(json);
    }

    final forceCastToIterable = json as Iterable<Object?>;
    final forceCastToInt = forceCastToIterable.map((e) => e! as int);

    return Uint8List.fromList(forceCastToInt.toArray());
  }

  @override
  String toJson(Uint8List object) {
    final ints = object.toArray();
    if (encodeToHex) {
      return '0x${ints.map((e) => e.toRadixString(16).padLeft(2, '0')).join()}';
    } else {
      return jsonEncode(ints);
    }
  }
}

/// converts to Uri if not null, otherwise returns null
class AnyBytesOrNullConverter extends ToDynamicConverter<Uint8List?> {
  /// default const constructor
  const AnyBytesOrNullConverter({this.encodeToHex = false});

  /// optional flag to use hexadecimal notation when encoding [toJson]
  /// e.g., 0x12AB34
  ///
  /// This does not change [fromJson], because it checks for this regardless
  final bool encodeToHex;
  static const _nonHexConverter = AnyBytesConverter();
  static const _hexConverter = AnyBytesConverter(encodeToHex: true);
  AnyBytesConverter get _converter =>
      encodeToHex ? _hexConverter : _nonHexConverter;

  @override
  Uint8List? fromJson(dynamic json) =>
      json == null ? null : _converter.fromJson(json);

  @override
  String? toJson(Uint8List? object) =>
      object == null ? null : _converter.toJson(object);
}
