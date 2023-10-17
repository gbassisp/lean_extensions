import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:lean_extensions/lean_extensions.dart';

/// wrapper around Future.delayed to have a simpler syntax
Future<void> sleep(num seconds) =>
    Future.delayed(Duration(microseconds: (seconds * 1000000).toInt()));

/// evaluates a dart expression
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
      port.send(await $expression);
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

/// a wrapper around jsonDecode to upcast types from dynamic to primitives
dynamic extendedJsonDecode(String encoded) {
  const intConverter = AnyIntConverter();

  final r = jsonDecode(encoded);

  return r is Iterable ? r.map((e) => intConverter.fromJson(e)).toList() : r;
}
