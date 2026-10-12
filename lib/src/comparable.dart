import 'package:meta/meta.dart';

/// similar to min() from the math lib, but applied to any [Comparable]
// ignore: strict_raw_type
A minComparable<A extends Comparable>(A p0, A p1) {
  return p0.compareTo(p1) > 0 ? p1 : p0;
}

/// similar to max() from the math lib, but applied to any [Comparable]
// ignore: strict_raw_type
A maxComparable<A extends Comparable>(A p0, A p1) {
  return p0.compareTo(p1) < 0 ? p1 : p0;
}

/// similar to [minComparable] and [maxComparable]
extension LeanComparableExtensions<T> on Comparable<T> {
  /// shorthand for: compareTo(other) == 0
  bool isEqualTo(T other) => compareTo(other) == 0;

  /// shorthand for: compareTo(other) > 0
  bool isGreaterThan(T other) => compareTo(other) > 0;

  /// shorthand for: compareTo(other) < 0
  bool isSmallerThan(T other) => compareTo(other) < 0;

  /// shorthand for: compareTo(other) >= 0
  bool isGreaterThanOrEqualTo(T other) => compareTo(other) >= 0;

  /// shorthand for: compareTo(other) <= 0
  bool isSmallerThanOrEqualTo(T other) => compareTo(other) <= 0;

  /// compares if this is between [min] and [max]
  ///
  /// additional named params allow making full/open-ended inclusive range
  /// comparison
  ///
  /// an assertion error is thrown if [min] and [max] are in the wrong order.
  /// on production code you always get false
  bool isBetween(
    T min,
    T max, {
    bool? inclusiveMin,
    bool? inclusiveMax,
  }) {
    if ((max as Comparable).isSmallerThan(min as Comparable)) {
      assert(false, 'min and max values passed in wrong order');
      return false;
    }

    final iMin = inclusiveMin ?? false;
    final iMax = inclusiveMax ?? false;

    if (iMin) {
      if (!isGreaterThanOrEqualTo(min)) return false;
    } else {
      if (!isGreaterThan(min)) return false;
    }

    if (iMax) {
      if (!isSmallerThanOrEqualTo(max)) return false;
    } else {
      if (!isSmallerThan(max)) return false;
    }

    return true;
  }
}

/// An easy way to implement [Comparable] in a way that [compareTo] aggrees
/// with [>] and [==] operators
@immutable
abstract class EasyComparable<T> implements Comparable<T> {
  /// [>] operator to compare this and [other]. If this is overridden, the [<]
  /// operator uses it to compute its value, but can also be overridden
  ///
  /// **USE [StrictComparable] IF YOU ONLY WANT TO COMPARE TO [T]**
  ///
  /// If you need to specify what Type is used on [>] and [<] operators, use
  /// [SpecificComparable]
  bool operator >(Object other);

  @override
  @mustBeOverridden
  bool operator ==(Object other);

  @override
  @mustBeOverridden
  int get hashCode;

  /// [<] operator to compare this and [other]. Overriding it is optional,
  /// it has a default implementation that uses [==] and [>] operators
  ///
  /// **USE [StrictComparable] IF YOU ONLY WANT TO COMPARE TO [T]**
  ///
  /// If you need to specify what Type is used on [>] and [<] operators, use
  /// [SpecificComparable]
  bool operator <(Object other) => this != other && !(this > other);

  @override
  int compareTo(T other) {
    if (other == null) {
      throw UnsupportedError('Null used in value comparison in $this');
    }

    if (this > other) {
      return 1;
    }

    if (this == other) {
      return 0;
    }

    if (this < other) {
      return -1;
    }

    throw UnsupportedError(
      'Comparing $this and $other returned false for >, == and <',
    );
  }
}

/// An easy way to implement [Comparable] in a way that [compareTo] aggrees
/// with [>] and [==] operators
///
/// This is a child class of [EasyComparable] that only takes the covariant
/// type [T] on the [>] and [<] operators
///
/// If you need to specify what Type is used on [>] and [<] operators, use
/// [SpecificComparable]
abstract class StrictComparable<T extends Object>
    extends SpecificComparable<T, T> {}

/// An easy way to implement [Comparable] in a way that [compareTo] aggrees
/// with [>] and [==] operators
///
/// This is a child class of [EasyComparable] that only takes the covariant
/// type [T] on the [>] and [<] operators
@immutable
abstract class SpecificComparable<T, U extends Object>
    extends EasyComparable<T> {
  /// [>] operator to compare this and [other]. If this is overridden, the [<]
  /// operator uses it to compute its value, but can also be overridden
  ///
  /// **USE [EasyComparable] IF YOU ONLY WANT TO COMPARE TO ANY [Object]**
  ///
  /// If you need to specify what Type is used on [>] and [<] operators, use
  /// [SpecificComparable]
  @override
  bool operator >(covariant U other);

  @override
  @mustBeOverridden
  bool operator ==(Object other);

  @override
  @mustBeOverridden
  int get hashCode;

  /// [<] operator to compare this and [other]. Overriding it is optional,
  /// it has a default implementation that uses [==] and [>] operators
  ///
  /// **USE [EasyComparable] IF YOU ONLY WANT TO COMPARE TO ANY [Object]**
  ///
  /// If you need to specify what Type is used on [>] and [<] operators, use
  /// [SpecificComparable]
  @override
  bool operator <(covariant U other) => this != other && !(this > other);
}
