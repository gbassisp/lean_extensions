import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:lean_extensions/lean_extensions.dart';
import 'package:meta/meta.dart';

/// wrapper around Future.delayed to have a simpler syntax
Future<void> sleep(num seconds) =>
    Future.delayed(Duration(microseconds: (seconds * 1000000).toInt()));

/// evaluates a dart expression.
///
/// **IMPORTANT**
///
/// This is just for fun; if the language doesn't support this, there is no
/// point in trying to use this hack!
///
/// I just wanted to how this works and experiment with the Dart VM
@experimental
Future<T> eval<T>(String expression, {T Function(String raw)? decoder}) async {
  final dec = decoder ?? extendedJsonDecode;
  final uri = Uri.dataFromString(
    '''
    import "dart:isolate";
    import 'dart:async';
    import 'dart:convert';
    import "package:lean_extensions/collection_extensions.dart";
    import "package:lean_extensions/dart_essentials.dart";
    import "package:lean_extensions/lean_extensions.dart";

    Future<void> main(_, SendPort port) async {
      port.send(extendedJsonEncode(await $expression));
    }
    ''',
    mimeType: 'application/dart',
  );

  final port = ReceivePort();
  final isolate = await Isolate.spawnUri(
    uri,
    [],
    port.sendPort,
  );
  final response = (await port.first).toString();

  port.close();
  isolate.kill();

  return dec(response) as T;
}

/// a wrapper around jsonEncode which resolves lazy iterators
dynamic extendedJsonEncode(dynamic value) {
  return value is Iterable ? value.map(extendedJsonEncode).toList() : value;
}

const _intConverter = AnyIntConverter();

/// a wrapper around jsonDecode to upcast types from dynamic to primitives
dynamic extendedJsonDecode(String encoded) {
  final r = jsonDecode(encoded);

  return r is Iterable ? r.map((e) => _intConverter.fromJson(e)).toList() : r;
}

/// Similar to Flutter's kDebugMode, but without relying on vm's properties.
///
/// This implementation is based on the fact that the `assert` function is
/// disabled in release mode.
bool get isDebugMode {
  try {
    assert(false, 'if this throws, then we are in debug mode');
    return false;
    // ignore: avoid_catching_errors - we intentionally throw for the logic
  } on AssertionError catch (_) {
    return true;
  }
}

// List<dynamic> _upcastJsonList(Iterable<dynamic> list) {}
