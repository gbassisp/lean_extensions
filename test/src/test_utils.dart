import 'package:change_case/change_case.dart';
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

final isTruthy = _Truthy();
final isFalsy = isNot(isTruthy);

class _Truthy extends Matcher {
  @override
  Description describe(Description description) {
    return description.add('a truthy value');
  }

  @override
  bool matches(Object? item, Map<Object?, Object?> matchState) =>
      item.isTruthy && item.toBoolean() && !item.isFalsy;
}

String fileRename(String original) => original.toSnakeCase();
