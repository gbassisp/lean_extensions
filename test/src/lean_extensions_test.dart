// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

import 'test_utils.dart';
import 'truthy_test.dart';

// /// converts to nullable DateTime
// class AnyDateTimeOrNull extends ToDynamicConverter<DateTime?> {
//   /// default const constructor
//   const AnyDateTimeOrNull();

//   @override
//   DateTime? fromJson(dynamic json) => _string.fromJson(json).tryToDateTime();
// }

// /// converts to DateTime
// class AnyDateTime extends ToDynamicConverter<DateTime> {
//   /// default const constructor
//   const AnyDateTime();

//   @override
//   DateTime fromJson(dynamic json) => _string.fromJson(json).toDateTime();

//   @override
//   dynamic toJson(DateTime object) => object.toIso8601String();
// }

const dateString = '2021-01-01';
const dateStringWithT = '2021-01-01T00:00:00.000';
const dateTimeString = '2021-01-01 13:23:31';
const dateTimeStringWithT = '2021-01-01T13:23:31.000';
final TypeMatcher<AssertionError> isAssertionError = isA<AssertionError>();
final Matcher throwsAssertionError = throwsA(isAssertionError);
// valid locales
const us = [null, '', 'en', 'en_us', 'en-us', 'en-_us'];
const uk = ['en-au', 'en_uk', 'en_-nz'];
// invalid locales
const invalidLocales = ['pt', 'anything else'];

/// 1 million random 32-length strings
Iterable<String> get randomStrings =>
    List.generate(1000000, (index) => Random().nextString());

void main() {
  group('converters', () {
    test('bool or null', () {
      const boolOrNull = AnyNullableBoolConverter();
      for (final t in truthy) {
        expect(boolOrNull.fromJson(t), isTrue);
      }
      for (final f in falsy) {
        expect(boolOrNull.fromJson(f), f == null ? isNull : isFalse);
      }
      for (final f in opinionatedFalsy) {
        expect(boolOrNull.fromJson(f), isFalse);
      }
    });

    test('bool', () {
      const boolean = AnyBoolConverter();
      for (final t in truthy) {
        expect(boolean.fromJson(t), isTrue);
      }
      for (final f in falsy) {
        expect(boolean.fromJson(f), isFalse);
      }
      for (final f in opinionatedFalsy) {
        expect(boolean.fromJson(f), isFalse);
      }
    });
    test('string or null', () {
      const stringOrNull = AnyNullableStringConverter();
      expect(stringOrNull.fromJson(null), null);
      expect(stringOrNull.fromJson(''), '');
      expect(stringOrNull.fromJson('a'), 'a');
      expect(stringOrNull.fromJson('1'), '1');
      expect(stringOrNull.fromJson(1), '1');
      expect(stringOrNull.fromJson(1.0), '1.0');
    });

    test('string', () {
      const string = AnyStringConverter();
      expect(string.fromJson(null), '');
      expect(string.fromJson(''), '');
      expect(string.fromJson('a'), 'a');
      expect(string.fromJson('1'), '1');
      expect(string.fromJson(1), '1');
      expect(string.fromJson(1.0), '1.0');
    });

    test('int or null', () {
      const intOrNull = AnyNullableIntConverter();
      expect(intOrNull.fromJson(null), null);
      expect(intOrNull.fromJson(''), null);
      expect(intOrNull.fromJson('a'), null);
      expect(intOrNull.fromJson('1'), 1);
      expect(intOrNull.fromJson(1), 1);
      expect(intOrNull.fromJson(1.0), 1);
    });

    test('int', () {
      const int = AnyIntConverter();
      expect(() => int.fromJson(null), throwsFormatException);
      expect(() => int.fromJson(''), throwsFormatException);
      expect(() => int.fromJson('a'), throwsFormatException);
      expect(int.fromJson('1'), 1);
      expect(int.fromJson(1), 1);
      expect(int.fromJson(1.0), 1);
    });

    test('double or null', () {
      const doubleOrNull = AnyNullableDoubleConverter();
      expect(doubleOrNull.fromJson(null), null);
      expect(doubleOrNull.fromJson(''), null);
      expect(doubleOrNull.fromJson('a'), null);
      expect(doubleOrNull.fromJson('1'), 1.0);
      expect(doubleOrNull.fromJson(1), 1.0);
      expect(doubleOrNull.fromJson(1.0), 1.0);
    });

    test('double', () {
      const double = AnyDoubleConverter();
      expect(() => double.fromJson(null), throwsFormatException);
      expect(() => double.fromJson(''), throwsFormatException);
      expect(() => double.fromJson('a'), throwsFormatException);
      expect(double.fromJson('1'), 1.0);
      expect(double.fromJson(1), 1.0);
      expect(double.fromJson(1.0), 1.0);
    });

    test('num or null', () {
      const numOrNull = AnyNullableNumConverter();
      expect(numOrNull.fromJson(null), null);
      expect(numOrNull.fromJson(''), null);
      expect(numOrNull.fromJson('a'), null);
      expect(numOrNull.fromJson('1'), 1);
      expect(numOrNull.fromJson(1), 1);
      expect(numOrNull.fromJson(1.0), 1.0);
    });

    test('num', () {
      const num = AnyNumConverter();
      expect(() => num.fromJson(null), throwsFormatException);
      expect(() => num.fromJson(''), throwsFormatException);
      expect(() => num.fromJson('a'), throwsFormatException);
      expect(num.fromJson('1'), 1);
      expect(num.fromJson(1), 1);
      expect(num.fromJson(1.0), 1.0);
    });

    test('DateTime or null', () {
      const dateTimeOrNull = AnyNullableDateTimeConverter();
      expect(dateTimeOrNull.fromJson(null), null);
      expect(dateTimeOrNull.fromJson(''), null);
      expect(dateTimeOrNull.fromJson('a'), null);
      expect(dateTimeOrNull.fromJson(dateString), DateTime(2021));
      expect(
        dateTimeOrNull.fromJson(dateTimeString),
        DateTime(2021, 1, 1, 13, 23, 31),
      );
      expect(
        dateTimeOrNull.fromJson(dateTimeStringWithT),
        DateTime(2021, 1, 1, 13, 23, 31),
      );

      // toJson
      expect(dateTimeOrNull.toJson(null), null);
      expect(dateTimeOrNull.toJson(DateTime(2021)), dateStringWithT);
      expect(
        dateTimeOrNull.toJson(DateTime(2021, 1, 1, 13, 23, 31)),
        dateTimeStringWithT,
      );
    });

    test('DateTime', () {
      const dateTime = AnyDateTimeConverter();
      expect(() => dateTime.fromJson(null), throwsFormatException);
      expect(() => dateTime.fromJson(''), throwsFormatException);
      expect(() => dateTime.fromJson('a'), throwsFormatException);
      expect(dateTime.fromJson(dateString), DateTime(2021));
      expect(
        dateTime.fromJson(dateTimeString),
        DateTime(2021, 1, 1, 13, 23, 31),
      );
      expect(
        dateTime.fromJson(dateTimeStringWithT),
        DateTime(2021, 1, 1, 13, 23, 31),
      );

      // toJson
      expect(dateTime.toJson(DateTime(2021)), dateStringWithT);
      expect(
        dateTime.toJson(DateTime(2021, 1, 1, 13, 23, 31)),
        dateTimeStringWithT,
      );
    });

    test('Date or null', () {
      const dateOrNull = AnyNullableDateConverter();
      expect(dateOrNull.fromJson(null), null);
      expect(dateOrNull.fromJson(''), null);
      expect(dateOrNull.fromJson('a'), null);
      expect(dateOrNull.fromJson(dateString), DateTime(2021));
      expect(
        dateOrNull.fromJson(dateTimeString),
        DateTime(2021),
      );
      expect(
        dateOrNull.fromJson(dateTimeStringWithT),
        DateTime(2021),
      );

      // toJson
      expect(dateOrNull.toJson(null), null);
      expect(dateOrNull.toJson(DateTime(2021)), dateString);
      expect(
        dateOrNull.toJson(DateTime(2021, 1, 1, 13, 23, 31)),
        dateString,
      );
    });

    test('Date', () {
      const date = AnyDateConverter();
      expect(() => date.fromJson(null), throwsFormatException);
      expect(() => date.fromJson(''), throwsFormatException);
      expect(() => date.fromJson('a'), throwsFormatException);
      expect(date.fromJson(dateString), DateTime(2021));
      expect(
        date.fromJson(dateTimeString),
        DateTime(2021),
      );
      expect(
        date.fromJson(dateTimeStringWithT),
        DateTime(2021),
      );

      // toJson
      expect(date.toJson(DateTime(2021)), dateString);
      expect(
        date.toJson(DateTime(2021, 1, 1, 13, 23, 31)),
        dateString,
      );
    });

    test('Uri - simple web url', () {
      const converter = AnyUriConverter();
      const url = 'https://github.com/gbassisp/lean_extensions';
      final uri = Uri.parse(url);
      // sanity check
      expect(
        Uri(
          scheme: 'https',
          host: 'github.com',
          pathSegments: ['gbassisp', 'lean_extensions'],
        ),
        uri,
      );

      expect(converter.fromJson(url), uri);
      expect(converter.fromJson(uri), uri);

      expect(converter.toJson(converter.fromJson(url)), url);
    });
    test('Uri - relative path', () {
      const converter = AnyUriConverter();
      const url = 'gbassisp/lean_extensions';
      final uri = Uri.parse(url);
      // sanity check
      expect(
        Uri(
          // scheme: 'https',
          // host: 'github.com',
          pathSegments: ['gbassisp', 'lean_extensions'],
        ),
        uri,
      );

      expect(converter.fromJson(url), uri);
      expect(converter.fromJson(uri), uri);

      expect(converter.toJson(converter.fromJson(url)), url);
    });
  });
  group('extensions', () {
    test('String?.orEmpty', () {
      const empty = '';
      const String? nullString = null;
      expect(nullString.orEmpty, empty);
      expect(empty.orEmpty, empty);
      expect('a'.orEmpty, 'a');
    });

    test('String?.isNullOrEmpty', () {
      const nonEmpty = 'bacon';
      const space = ' ';
      const empty = '';
      const String? nullString = null;
      expect(nullString.isNullOrEmpty, isTrue);
      expect(empty.isNullOrEmpty, isTrue);
      expect(nonEmpty.isNullOrEmpty, isFalse);
      expect(space.isNullOrEmpty, isFalse);
    });

    const str = 'abc';
    final re1 = RegExp('abc');
    final re2 = RegExp('abc?');
    final patterns = [str, re1, re2];
    for (final p in patterns) {
      test('String.endsWithPattern - pattern $p', () {
        expect(''.endsWithPattern(p), isFalse);
        expect('abcdef'.endsWithPattern(p), isFalse);
        expect('abc '.endsWithPattern(p), isFalse);
        expect('abc\n'.endsWithPattern(p), isFalse);

        expect('abc'.endsWithPattern(p), isTrue);
        expect('abcabc'.endsWithPattern(p), isTrue);
        expect('defabc'.endsWithPattern(p), isTrue);
      });
    }
    test('String.endsWithPattern - $re2', () {
      final p = re2;
      expect('ab'.endsWithPattern(p), isTrue);
    });

    test('String.endsWithPattern - .', () {
      const st = '.';
      final re = RegExp('.');
      for (final s in randomStrings) {
        expect(s.endsWithPattern(st), isFalse);
        expect(s.endsWithPattern(re), isTrue);
      }
    });

    test('String.normalizeLineBreaks', () {
      expect(''.normalizeLineBreaks(), '');
      expect(' '.normalizeLineBreaks(), ' ');
      expect('abc'.normalizeLineBreaks(), 'abc');
      expect('abc\n'.normalizeLineBreaks(), 'abc\n');
      expect('abc\r\n'.normalizeLineBreaks(), 'abc\n');
      expect('a\rbc'.normalizeLineBreaks(), 'a\nbc');
      // being realistic, mixed cases should never happen; but still supported
      expect('a\r\nb\nc'.normalizeLineBreaks(), 'a\nb\nc');
      expect(
        'a\r\n\n\r\r\n\r\nbc\n'.normalizeLineBreaks(),
        'a\n\n\n\n\nbc\n',
        reason: 'should replace the ones in brackets:\n'
            r'a(\r\n)(\n)(\r)(\r\n)(\r\n)bc(\n)',
      );
      expect('a\rb\nc'.normalizeLineBreaks(), 'a\nb\nc');
    });

    test('String.replaceLineBreaks', () {
      expect(''.replaceLineBreaks(), '');
      expect(' '.replaceLineBreaks(), ' ');
      expect('abc'.replaceLineBreaks(), 'abc');
      expect('abc\n'.replaceLineBreaks(), 'abc');
      expect('abc\r\n'.replaceLineBreaks(), 'abc');
      expect('a\r\nb\nc'.replaceLineBreaks(), 'abc');
      expect('a\r\n\n\r\r\n\r\nbc\n'.replaceLineBreaks(), 'abc');
      expect('a\rb\nc'.replaceLineBreaks(), 'abc');
      expect('a\rbc'.replaceLineBreaks(), 'abc');
    });

    test('String.replaceLineBreaks with something', () {
      const a = 'something';
      expect(''.replaceLineBreaks(a), '');
      expect(' '.replaceLineBreaks(a), ' ');
      expect('abc'.replaceLineBreaks(a), 'abc');
      expect('abc\n'.replaceLineBreaks(a), 'abc$a');
      expect('abc\r\n'.replaceLineBreaks(a), 'abc$a');
      expect('a\r\nb\nc'.replaceLineBreaks(a), 'a${a}b${a}c');
      expect('a\r\n\n\r\r\n\r\nbc\n'.replaceLineBreaks(a), 'a$a$a$a$a${a}bc$a');
      expect('a\rb\nc'.replaceLineBreaks(a), 'a${a}b${a}c');
      expect('a\rbc'.replaceLineBreaks(a), 'a${a}bc');

      // sanity check that \r is actually CR
      expect(
        '\r and \n or \r\n'.contains(r'\'),
        isFalse,
        reason: r'expected \r to be special char',
      );
    });

    test('String.tryToNum', () {
      expect('1'.tryToNum(), 1);
      expect('1.0'.tryToNum(), 1.0);
      expect('a'.tryToNum(), null);
      expect('one'.tryToNum(), 1);
      expect(' 1'.tryToNum(), 1);
      expect('1.0 '.tryToNum(), 1.0);
      expect('a '.tryToNum(), null);
      expect(' one '.tryToNum(), 1);
    });

    test('String.toNum', () {
      expect('1'.toNum(), 1);
      expect('1.0'.toNum(), 1.0);
      expect(() => 'a'.toNum(), throwsFormatException);
      expect('one'.toNum(), 1);
      expect(' 1'.toNum(), 1);
      expect('1.0 '.toNum(), 1.0);
      expect(() => 'a '.toNum(), throwsFormatException);
      expect(' one '.toNum(), 1);
    });

    test('String.tryToInt', () {
      expect('1'.tryToInt(), 1);
      expect('1.0'.tryToInt(), 1);
      expect('a'.tryToInt(), null);
      expect('one'.tryToInt(), 1);
      expect(' 1'.tryToInt(), 1);
      expect('1.0 '.tryToInt(), 1);
      expect('a '.tryToInt(), null);
      expect(' one '.tryToInt(), 1);
    });

    test('String.toInt', () {
      expect('1'.toInt(), 1);
      expect('1.0'.toInt(), 1);
      expect(() => 'a'.toInt(), throwsFormatException);
      expect('one'.toInt(), 1);
      expect(' 1'.toInt(), 1);
      expect('1.0 '.toInt(), 1);
      expect(() => 'a '.toInt(), throwsFormatException);
      expect(' one '.toInt(), 1);
    });

    test('String.tryToDouble', () {
      expect('1'.tryToDouble(), 1.0);
      expect('1.0'.tryToDouble(), 1.0);
      expect('a'.tryToDouble(), null);
      expect('one'.tryToDouble(), 1.0);
      expect(' 1'.tryToDouble(), 1.0);
      expect('1.0 '.tryToDouble(), 1.0);
      expect('a '.tryToDouble(), null);
      expect(' one '.tryToDouble(), 1.0);
    });

    test('String.toDouble', () {
      expect('1'.toDouble(), 1.0);
      expect('1.0'.toDouble(), 1.0);
      expect(() => 'a'.toDouble(), throwsFormatException);
      expect('one'.toDouble(), 1.0);
      expect(' 1'.toDouble(), 1.0);
      expect('1.0 '.toDouble(), 1.0);
      expect(() => 'a '.toDouble(), throwsFormatException);
      expect(' one '.toDouble(), 1.0);
    });

    test('String.tryToDateTime', () {
      expect(dateString.tryToDateTime(), DateTime(2021));
      expect(
        dateTimeString.tryToDateTime(),
        DateTime(2021, 1, 1, 13, 23, 31),
      );
      expect('a'.tryToDateTime(), null);
    });

    test('String.toDateTime', () {
      expect(dateString.toDateTime(), DateTime(2021));
      expect(
        dateTimeString.toDateTime(),
        DateTime(2021, 1, 1, 13, 23, 31),
      );
      expect(() => 'a'.toDateTime(), throwsFormatException);
    });

    test('String.tryToDate', () {
      expect(dateString.tryToDate(), DateTime(2021));
      expect(dateTimeString.tryToDate(), DateTime(2021));
      expect('a'.tryToDate(), null);
    });

    test('String.toDate', () {
      expect(dateString.toDate(), DateTime(2021));
      expect(dateTimeString.toDate(), DateTime(2021));
      expect(() => 'a'.toDate(), throwsFormatException);
    });

    test('String.toSentenceCase', () {
      // basic - up to 1 word
      expect(''.toSentenceCase(), '');
      expect('a'.toSentenceCase(), 'A');
      expect('A'.toSentenceCase(), 'A');
      expect('ab'.toSentenceCase(), 'Ab');
      expect('Ab'.toSentenceCase(), 'Ab');
      expect('aB'.toSentenceCase(), 'Ab');
      expect('AB'.toSentenceCase(), 'Ab');

      // 2 words
      expect('ab AB'.toSentenceCase(), 'Ab ab');
      expect('Ab aB'.toSentenceCase(), 'Ab ab');
      expect('aB ab'.toSentenceCase(), 'Ab ab');
      expect('AB Ab'.toSentenceCase(), 'Ab ab');

      // with emojis
      expect('💙 dart is awesome'.toSentenceCase(), '💙 dart is awesome');
      expect('💙 dart iS aweSomE'.toSentenceCase(), '💙 dart is awesome');
      expect('💙 DART is awesome'.toSentenceCase(), '💙 dart is awesome');
      expect('💙 dart IS awesome'.toSentenceCase(), '💙 dart is awesome');

      // with spaces
      expect(' dart is awesome'.toSentenceCase(), ' Dart is awesome');
      expect('\n dart iS aweSomE'.toSentenceCase(), '\n Dart is awesome');
      expect('\nDART is awesome'.toSentenceCase(), '\nDart is awesome');
      expect('\n\ndart IS awesome'.toSentenceCase(), '\n\nDart is awesome');

      // multiple sentences
      expect(
        '💙 dart is awesome. but ThIs is a hack'.toSentenceCase(),
        '💙 dart is awesome. But this is a hack',
      );
      expect(
        '💙 dart is awesome.   but this is a hack'.toSentenceCase(),
        '💙 dart is awesome.   But this is a hack',
      );
      expect(
        '💙 dart is awesome.\nbut this is a hack'.toSentenceCase(),
        '💙 dart is awesome.\nBut this is a hack',
      );
      expect(
        '💙 dart is awesome.\n  but this is a hack'.toSentenceCase(),
        '💙 dart is awesome.\n  But this is a hack',
      );
    });
    test('String.toTitleCase', () {
      // basic - up to 1 word
      expect(''.toTitleCase(), '');
      expect('a'.toTitleCase(), 'A');
      expect('A'.toTitleCase(), 'A');
      expect('ab'.toTitleCase(), 'Ab');
      expect('Ab'.toTitleCase(), 'Ab');
      expect('aB'.toTitleCase(), 'Ab');
      expect('AB'.toTitleCase(), 'Ab');

      // 2 words
      expect('ab AB'.toTitleCase(), 'Ab Ab');
      expect('Ab aB'.toTitleCase(), 'Ab Ab');
      expect('aB ab'.toTitleCase(), 'Ab Ab');
      expect('AB Ab'.toTitleCase(), 'Ab Ab');

      // with emojis
      expect('💙 dart is awesome'.toTitleCase(), '💙 Dart Is Awesome');
      expect('💙 dart iS aweSomE'.toTitleCase(), '💙 Dart Is Awesome');
      expect('💙 DART is awesome'.toTitleCase(), '💙 Dart Is Awesome');
      expect('💙 dart IS awesome'.toTitleCase(), '💙 Dart Is Awesome');

      // with spaces
      expect(' dart is awesome'.toTitleCase(), ' Dart Is Awesome');
      expect('\n dart iS aweSomE'.toTitleCase(), '\n Dart Is Awesome');
      expect('\nDART is awesome'.toTitleCase(), '\nDart Is Awesome');
      expect('\n\ndart IS awesome'.toTitleCase(), '\n\nDart Is Awesome');

      // multiple sentences
      expect(
        '💙 dart is awesome. but ThIs is a hack'.toTitleCase(),
        '💙 Dart Is Awesome. But This Is A Hack',
      );
      expect(
        '💙 dart is awesome.   but this is a hack'.toTitleCase(),
        '💙 Dart Is Awesome.   But This Is A Hack',
      );
      expect(
        '💙 dart is awesome.\nbut this is a hack'.toTitleCase(),
        '💙 Dart Is Awesome.\nBut This Is A Hack',
      );
      expect(
        '💙 dart is awesome.\n  but this is a hack'.toTitleCase(),
        '💙 Dart Is Awesome.\n  But This Is A Hack',
      );
    });

    test('num.isPositive', () {
      expect(1.isPositive, isTrue);
      expect(0.isPositive, isFalse);
      expect((-1).isPositive, isFalse);
      expect(double.nan.isPositive, isFalse);
      expect(double.infinity.isPositive, isTrue);
      expect(double.negativeInfinity.isPositive, isFalse);
      expect(0.1.isPositive, isTrue);
      expect(0.0.isPositive, isFalse);
      expect((-0.0).isPositive, isFalse);
      expect((-0.1).isPositive, isFalse);
    });

    test('num.isNonPositive', () {
      expect(1.isNonPositive, isFalse);
      expect(0.isNonPositive, isTrue);
      expect((-1).isNonPositive, isTrue);
      expect(double.nan.isNonPositive, isFalse);
      expect(double.infinity.isNonPositive, isFalse);
      expect(double.negativeInfinity.isNonPositive, isTrue);
      expect(0.1.isNonPositive, isFalse);
      expect(0.0.isNonPositive, isTrue);
      expect((-0.0).isNonPositive, isTrue);
      expect((-0.1).isNonPositive, isTrue);
    });

    test('num.isNonNegative', () {
      expect(1.isNonNegative, isTrue);
      expect(0.isNonNegative, isTrue);
      expect((-1).isNonNegative, isFalse);
      expect(double.nan.isNonNegative, isFalse);
      expect(double.infinity.isNonNegative, isTrue);
      expect(double.negativeInfinity.isNonNegative, isFalse);
      expect(0.1.isNonNegative, isTrue);
      expect(0.0.isNonNegative, isTrue);
      expect((-0.0).isNonNegative, isTrue);
      expect((-0.1).isNonNegative, isFalse);
    });

    test('num.withLeading', () {
      expect(1.withLeading(1), '1');
      expect(1.withLeading(2), '01');
      expect(1.withLeading(3), '001');
      expect(1.withLeading(4), '0001');

      expect(1.0.withLeading(1), '1.0');
      expect(1.0.withLeading(2), '01.0');
      expect(1.0.withLeading(3), '001.0');
      expect(1.0.withLeading(4), '0001.0');

      expect(1000000.withLeading(1), '1000000');
      expect(1000000.withLeading(2), '1000000');
      expect(1000000.withLeading(3), '1000000');
      expect(1000000.withLeading(10), '0001000000');

      // same but with negative numbers
      expect((-1).withLeading(1), '-1');
      expect((-1).withLeading(2), '-01');
      expect((-1).withLeading(3), '-001');
      expect((-1).withLeading(4), '-0001');

      expect((-1.0).withLeading(1), '-1.0');
      expect((-1.0).withLeading(2), '-01.0');
      expect((-1.0).withLeading(3), '-001.0');
      expect((-1.0).withLeading(4), '-0001.0');

      expect((-1000000).withLeading(1), '-1000000');
      expect((-1000000).withLeading(2), '-1000000');
      expect((-1000000).withLeading(3), '-1000000');
      expect((-1000000).withLeading(10), '-0001000000');
    });

    test(
      'num.toPrecision',
      () {
        expect(1.1234.toPrecision(0), 1.0);
        expect(1.1234.toPrecision(1), 1.1);
        expect(1.1234.toPrecision(2), 1.12);
        expect(1.1234.toPrecision(3), 1.123);
        expect(1.1234.toPrecision(4), 1.1234);
        expect(1.1234.toPrecision(5), 1.1234);

        expect(-1.1234.toPrecision(0), -1.0);
        expect(-1.1234.toPrecision(1), -1.1);
        expect(-1.1234.toPrecision(2), -1.12);
        expect(-1.1234.toPrecision(3), -1.123);
        expect(-1.1234.toPrecision(4), -1.1234);
        expect(-1.1234.toPrecision(5), -1.1234);
      },
    );

    test('num.isMultipleOf', () {
      expect(1.isMultipleOf(0), isFalse);
      expect(1.isMultipleOf(1), isTrue);
      expect(1.isMultipleOf(2), isFalse);

      expect(2.isMultipleOf(0), isFalse);
      expect(2.isMultipleOf(1), isTrue);
      expect(2.isMultipleOf(2), isTrue);
      expect(2.isMultipleOf(-2), isTrue);

      expect((-2).isMultipleOf(0), isFalse);
      expect((-2).isMultipleOf(1), isTrue);
      expect((-2).isMultipleOf(2), isTrue);
      expect((-2).isMultipleOf(-2), isTrue);
    });

    test('num.isZero', () {
      expect(1.isZero, isFalse);
      expect(0.isZero, isTrue);
      expect((-1).isZero, isFalse);
      expect(double.nan.isZero, isFalse);
      expect(double.infinity.isZero, isFalse);
      expect(double.negativeInfinity.isZero, isFalse);
      expect(0.1.isZero, isFalse);
      expect(0.0.isZero, isTrue);
      expect((-0.0).isZero, isTrue);
      expect((-0.1).isZero, isFalse);
    });

    test('int.toNumeral()', () {
      for (final tag in [...us, ...uk]) {
        expect(0.toNumeral(tag), 'zero');
        expect(10.toNumeral(tag), 'ten');
        expect(100.toNumeral(tag), 'one hundred');
      }
      // invalid locale
      for (final i in range(-100, 100)) {
        for (final tag in invalidLocales) {
          expect(() => i.toNumeral(tag), throwsUnimplementedError);
        }
      }
      for (final tag in uk) {
        expect(999.toNumeral(tag), 'nine hundred and ninety-nine');
      }
      for (final tag in us) {
        expect(999.toNumeral(tag), 'nine hundred ninety-nine');
      }
    });

    // this is tested on others_test.dart
    test('int.toRadixExtended()', () {
      for (final i in range(2, 65)) {
        expect(0.toRadixExtended(i), '0');
        expect(i.toRadixExtended(i), '10');
      }
    });

    test('DateTime.copyWith', () {
      final date = DateTime(2021, 1, 1, 13, 23, 31);
      expect(date.copyWith(), date);
      expect(date.copyWith(year: 2022), DateTime(2022, 1, 1, 13, 23, 31));
      expect(date.copyWith(month: 2), DateTime(2021, 2, 1, 13, 23, 31));
      expect(date.copyWith(day: 2), DateTime(2021, 1, 2, 13, 23, 31));
      expect(date.copyWith(hour: 2), DateTime(2021, 1, 1, 2, 23, 31));
      expect(date.copyWith(minute: 2), DateTime(2021, 1, 1, 13, 2, 31));
      expect(date.copyWith(second: 2), DateTime(2021, 1, 1, 13, 23, 2));
      expect(
        date.copyWith(millisecond: 2),
        DateTime(2021, 1, 1, 13, 23, 31, 2),
      );
      expect(
        date.copyWith(microsecond: 2),
        DateTime(2021, 1, 1, 13, 23, 31, 0, 2),
      );
    });

    test('Iterable?.orEmpty', () {
      const empty = <int>[];
      const Iterable<int>? nullIterable = null;
      expect(nullIterable.orEmpty, empty);
      expect(empty.orEmpty, empty);
      expect([1].orEmpty, [1]);
      expect({1}.orEmpty, {1});
    });

    test('Comparable.limit', () {
      expect(1.limitTo(0, 2), 1);
      expect(1.limitTo(1, 2), 1);
      expect(1.limitTo(2, 2), 2);
      expect(() => 1.limitTo(3, 2), throwsAssertionError);
      expect(1.limitTo(0, 1), 1);
      expect(1.limitTo(1, 1), 1);
      expect(() => 1.limitTo(2, 1), throwsAssertionError);
    });

    test('Iterable.toArray()', () {
      final a = [3, 1, 2].toArray();
      final b = [1, 2, 3];

      // list is mutable
      expect(a, containsAll(b));
      expect(a, isNot(containsAllInOrder(b)));
      expect(a..sort(), containsAllInOrder(b));

      // cannot change size
      expect(() => a.add(0), throwsA(anything));
      expect(() => a.remove(1), throwsA(anything));
    });

    test('Iterable.elementArOrNull', () {
      // non-empty list
      expect([1, 2, 3].elementAtOrNull(0), 1);
      expect([1, 2, 3].elementAtOrNull(1), 2);
      expect([1, 2, 3].elementAtOrNull(2), 3);
      expect([1, 2, 3].elementAtOrNull(3), null);
      expect([1, 2, 3].elementAtOrNull(-1), null);

      // empty list
      expect(<int>[].elementAtOrNull(0), null);
      expect(<int>[].elementAtOrNull(1), null);
      expect(<int>[].elementAtOrNull(-1), null);
    });

    test('Iterable.shiftLeft', () {
      expect([1, 2, 3].shiftLeft(0), [1, 2, 3]);
      expect([1, 2, 3].shiftLeft(1), [2, 3, 1]);
      expect([1, 2, 3].shiftLeft(2), [3, 1, 2]);
      expect([1, 2, 3].shiftLeft(3), [1, 2, 3]);
      expect([1, 2, 3].shiftLeft(4), [2, 3, 1]);
      expect([1, 2, 3].shiftLeft(-1), [3, 1, 2]);
      expect([1, 2, 3].shiftLeft(-2), [2, 3, 1]);
      expect([1, 2, 3].shiftLeft(-3), [1, 2, 3]);
      expect([1, 2, 3].shiftLeft(-4), [3, 1, 2]);
    });

    test('Iterable.shiftRight', () {
      expect([1, 2, 3].shiftRight(0), [1, 2, 3]);
      expect([1, 2, 3].shiftRight(1), [3, 1, 2]);
      expect([1, 2, 3].shiftRight(2), [2, 3, 1]);
      expect([1, 2, 3].shiftRight(3), [1, 2, 3]);
      expect([1, 2, 3].shiftRight(4), [3, 1, 2]);
      expect([1, 2, 3].shiftRight(-1), [2, 3, 1]);
      expect([1, 2, 3].shiftRight(-2), [3, 1, 2]);
      expect([1, 2, 3].shiftRight(-3), [1, 2, 3]);
      expect([1, 2, 3].shiftRight(-4), [2, 3, 1]);
    });

    test('Iterable.separated', () {
      expect([1, 2, 3].separated(0), [1, 0, 2, 0, 3]);
      expect([1].separated(0), [1]);
      expect(<int>[].separated(0), <int>[]);
    });

    test('Iterable.separatedList', () {
      expect([1, 2, 3].separatedList(0), [1, 0, 2, 0, 3]);
      expect([1].separatedList(0), [1]);
      expect(<int>[].separatedList(0), <int>[]);
    });

    test('Iterable.wrapped', () {
      expect([1, 2, 3].wrapped(0), [0, 1, 2, 3, 0]);
      expect([1].wrapped(0), [0, 1, 0]);
      expect(<int>[].wrapped(0), <int>[]);
    });

    test('Iterable.wrappedList', () {
      expect([1, 2, 3].wrappedList(0), [0, 1, 2, 3, 0]);
      expect([1].wrappedList(0), [0, 1, 0]);
      expect(<int>[].wrappedList(0), <int>[]);
    });

    group(
      'Random.nextChar and nextString',
      () {
        // random string
        testFrequency<String>('Random.nextChar', (frequency) {
          final random = Random();
          // probabilistic test; run 100mi times just to be sure
          for (var i = 0; i < 100000000; i++) {
            final char = random.nextChar();
            frequency[char] = (frequency[char] ?? 0) + 1;
            expect(char, isNotEmpty);
          }

          expect(frequency.length, 64);
        });

        // random string
        testFrequency<String>('Random.nextString long strings', (frequency) {
          final random = Random();
          final results = <String>{};
          // probabilistic test; run 10mi times just to be sure
          const limit = 10000000;
          for (var i = 0; i < limit; i++) {
            final string = random.nextString(length: 100);
            expect(string.length, 100);
            final isNew = results.add(string);
            expect(isNew, isTrue);
            for (final char in string.split('')) {
              frequency[char] = (frequency[char] ?? 0) + 1;
            }
          }

          expect(frequency.length, 64);
        });

        testFrequency<String>('Random.nextString short strings', (frequency) {
          final random = Random();
          const limit = 200000000;
          const length = 3;
          const chars = string.asciiLowercase;
          for (var i = 0; i < limit; i++) {
            final res = random.nextString(length: length, chars: chars);
            expect(res.length, length);
            frequency[res] = (frequency[res] ?? 0) + 1;
          }

          expect(frequency.length, pow(chars.length, length));
        });

        // random string - test seed
        test('Random.nextString can be seeded', () {
          final r = Random();
          for (final _ in range(100)) {
            final k = r.nextInt(1 << 32);
            final random = Random(k);
            final random2 = Random(k);

            // same seed must produce same pseudo random values
            for (final _ in range(100)) {
              expect(
                random.nextString(length: 100),
                random2.nextString(length: 100),
              );
            }
          }
        });
      },
    );
    group('Random.nextBigInt', () {
      testFrequency('Random.nextBigInt is normally distributed', (frequency) {
        final random = Random();
        final results = <BigInt>{};
        const intLimit = 999;
        final limit = BigInt.from(intLimit);
        // probabilistic test; run 10mi times just to be sure
        // extremely unlikely to fail

        const iterations = 10000000;
        for (var i = 0; i < iterations; i++) {
          final value = random.nextBigInt(limit);
          expect(value, lessThan(limit));
          expect(value, greaterThanOrEqualTo(BigInt.zero));
          results.add(value);
          frequency[value] = (frequency[value] ?? 0) + 1;
        }

        // expect to have generated all numbers from 0 to 1000
        expect(frequency.length, intLimit);
        const average = iterations ~/ intLimit;
        for (final entry in frequency.entries) {
          final k = entry.key;
          final value = entry.value;
          // each number from 0 to 1000 is normally distributed
          final reason = 'value $k had a frequency of $value';
          expect(value, greaterThan(average * 0.95), reason: reason);
          expect(value, lessThan(average * 1.05), reason: reason);
        }
      });

      test(
        'Random.nextBigInt converges',
        () {
          final random = Random();
          final results = <BigInt>{};
          final limit = BigInt.parse('5' * 1000);

          // run 10mi times and still should always be a new number
          for (final _ in range(10000000)) {
            final value = random.nextBigInt(limit);
            expect(value, lessThan(limit));
            expect(value, greaterThanOrEqualTo(BigInt.zero));
            final isNew = results.add(value);
            expect(isNew, isTrue);
          }
        },
        skip: notExhaustive,
      );

      test('Random.nextBigInt short conversion case', () {
        final random = Random();
        final results = <BigInt>{};
        final limit = BigInt.parse('5' * 1000);

        // run 10mi times and still should always be a new number
        for (final _ in range(10000)) {
          final value = random.nextBigInt(limit);
          expect(value, lessThan(limit));
          expect(value, greaterThanOrEqualTo(BigInt.zero));
          final isNew = results.add(value);
          expect(isNew, isTrue);
        }
      });

      test('Random.nextBigInt can be seeded', () {
        final r = Random();
        final max =
            BigInt.parse('123456789123456789123456789123456789123456789');
        for (final _ in range(100)) {
          final k = r.nextInt(1 << 32);
          final random = Random(k);
          final random2 = Random(k);

          // same seed must produce same pseudo random values
          for (final _ in range(100)) {
            expect(
              random.nextBigInt(max),
              random2.nextBigInt(max),
            );
          }
        }
      });
    });
  });
}
