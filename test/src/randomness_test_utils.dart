import 'dart:math';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTestGroup
void testRandomValidity<T extends Object>(
  String name,
  RandomValidityCase<T> Function() fn, {
  bool? skip,
}) {
  final testCase = fn.call();
  final n = name;
  group(
    n,
    () {
      test(
        '$n - seeded randoms produce the same value',
        testCase._generateSeeded,
      );
      test(
        '$n - random values are not in order',
        testCase._checkOrder,
        skip: !testCase.isComparable,
      );
      test(
        '$n - sample is big enough to generate all possible values in codomain',
        testCase._checkCodomainAndImage,
      );
      test(
        '$n - random values are normally distributed',
        testCase._checkDistribution,
      );
      test('$n - random values are not predictable', () {});
    },
    skip: skip,
  );
}

abstract class RandomValidityCase<T extends Object> {
  T generateNextValue(Random random);
  int get codomainSize;
  bool get isComparable => true;

  final _seed = Random().nextInt(1 << 32);
  final _main = Random();
  late final _seededs = List.generate(3, (_) => Random(_seed));
  final _smallSample = 100000;
  late final _sampleSize = max(_smallSample, codomainSize * 10000);
  List<T>? _sample;
  Map<T, int>? _frequency;

  void _generateSeeded() {
    for (final _ in range(_smallSample)) {
      final toCompare = <T>[];
      for (final r in _seededs) {
        final next = generateNextValue(r);
        toCompare.add(next);
      }
      _expectAllEqual(toCompare);
    }
  }

  List<T> _generateMain() {
    if (_sample != null) {
      _generateFrequency();
      return _sample!;
    }

    final g = List.generate(_sampleSize, (_) => generateNextValue(_main));
    // if concurrent, _sample may have been created in the meantime:
    _sample ??= g;
    return _generateMain();
  }

  Map<T, int> _generateFrequency() {
    if (_frequency != null) {
      return _frequency!;
    }

    final g = _sample ?? _generateMain();
    final f = <T, int>{};
    for (final i in g) {
      f[i] = (f[i] ?? 0) + 1;
    }
    _frequency ??= f;
    return _generateFrequency();
  }

  void _checkOrder() {
    final sample = _generateMain();
    expect(sample, isNotEmpty);
    expect(sample.length, equals(_sampleSize));
    final clone = [...sample]..sort();
    final reason = 'Generated values should not be sorted: $sample';
    expect(clone, isNot(containsAllInOrder(sample)), reason: reason);
    expect(clone.reversed, isNot(containsAllInOrder(sample)), reason: reason);
  }

  void _checkCodomainAndImage() {
    final sample = _generateFrequency();
    expect(sample, isNotEmpty);
    expect(
      sample.length,
      equals(codomainSize),
      reason: 'Not all elements of codomain were generated in a sample of '
          '$_sampleSize.\n$sample',
    );
  }

  void _checkDistribution() {
    final frequency = _generateFrequency();
    expect(frequency, isNotEmpty);
    expect(frequency.length, codomainSize);
    final average = _sampleSize ~/ codomainSize;
    for (final entry in frequency.entries) {
      final k = entry.key;
      final value = entry.value;
      final reason = 'value $k had a frequency of $value';
      expect(value, greaterThan(average * 0.95), reason: reason);
      expect(value, lessThan(average * 1.05), reason: reason);
    }
  }
}

void _expectAllEqual<T>(Iterable<T> collection) {
  final s = collection.toSet();
  final reason = 'Expected $collection to have only 1 unique value, but got $s';
  expect(s.length, equals(1), reason: reason);
}
