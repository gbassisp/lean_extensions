import 'package:collection/collection.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

void expectSameCollection(Object? value, Object? expected) {
  const d = DeepCollectionEquality();

  final diff = value is Map && expected is Map
      ? value.difference(expected)
      // ignore: inference_failure_on_collection_literal
      : {};

  expect(
    d.equals(value, expected),
    isTrue,
    reason: 'Received $value but expected $expected. '
        '${diff.entries.isEmpty ? '' : 'Difference: $diff'}',
  );
}

final throwsSomething = throwsA(anything);
final throwsNothing = isNot(throwsSomething);
