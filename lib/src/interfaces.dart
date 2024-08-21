import 'package:meta/meta.dart';

/// An easy way to implement [Comparable] in a way that [compareTo] aggrees
/// with [>] and [==] operators
@immutable
abstract class EasyComparable<T> implements Comparable<T> {
  /// [>] operator to compare this and [other]. If this is overridden, the [<]
  /// operator uses it to compute its value, but can also be overridden
  bool operator >(Object other);

  @override
  @mustBeOverridden
  bool operator ==(Object other);

  @override
  @mustBeOverridden
  int get hashCode;

  /// [<] operator to compare this and [other]. Overriding it is optional,
  /// it has a default implementation that uses [==] and [>] operators
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
