import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

const _exhaustive = bool.fromEnvironment('exhaustive');
bool get exhaustive {
  // ignore: avoid_print - test code only
  print('running test with exhaustive flag = $_exhaustive');
  return _exhaustive;
}

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

@isTest
void testFrequency<T>(
  String name,
  void Function(Map<T, int> occurrences) testCase,
) {
  final frequency = <T, int>{};
  test(
    name,
    () async {
      try {
        testCase(frequency);
        final size = frequency.length;
        final iterations = frequency.values.sum;
        final average = iterations ~/ size;
        final expectedSample = size * 10000.0;
        expect(
          iterations,
          greaterThan(expectedSample),
          reason: 'Sample size is too small. '
              'You generated $size cases in $iterations iterations. '
              'You need at least ${expectedSample / iterations}x more iters',
        );
        for (final entry in frequency.entries) {
          final k = entry.key;
          final value = entry.value;
          final reason = 'value $k had a frequency of $value';
          expect(value, greaterThan(average * 0.95), reason: reason);
          expect(value, lessThan(average * 1.05), reason: reason);
        }
      } finally {
        final fileName = fileRename(name);
        final data = frequency.entries
            .map((entry) => [entry.key, entry.value])
            .toList()
          ..insert(0, ['Value', 'Occurrences']);
        final csv = const ListToCsvConverter().convert(data);
        final directory = '${Directory.current.path}/test/results';
        await Directory(directory).create(recursive: true);
        final pathOfTheFileToWrite = '$directory/$fileName.csv';
        final file = File(pathOfTheFileToWrite);
        await file.writeAsString(csv);
      }
    },
    timeout: const Timeout(Duration(minutes: 15)),
    skip: !exhaustive,
  );
}
