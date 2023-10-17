import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

/// wrapper around Future.delayed to have a simpler syntax
Future<void> sleep(num seconds) =>
    Future.delayed(Duration(microseconds: (seconds * 1000000).toInt()));

/// evaluates a dart expression
Future<T> eval<T>(String expression, {T Function(String raw)? decoder}) async {
  final dec = decoder ?? jsonDecode;
  final uri = Uri.dataFromString(
    '''
    import "dart:isolate";
    import "package:lean_extensions/collection_extensions.dart";
    import "package:lean_extensions/dart_essentials.dart";
    import "package:lean_extensions/lean_extensions.dart";

    void main(_, SendPort port) {
      port.send($expression);
    }
    ''',
    mimeType: 'application/dart',
  );

  final port = ReceivePort();
  final isolate = await Isolate.spawnUri(uri, [], port.sendPort);
  final response = (await port.first).toString();

  port.close();
  isolate.kill();

  return dec(response) as T;
}
