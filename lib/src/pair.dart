import 'package:meta/meta.dart';

/// a class with 2 values
@immutable
class Pair<A, B> {
  /// default constructor
  const Pair(this.$1, this.$2);

  /// gets a copy of this pair with values flipped
  Pair<B, A> get flipped => Pair($2, $1);

  /// first (left) value
  final A $1;

  /// second (right) value
  final B $2;

  /// convenience getter for [$1]
  A get left => $1;

  /// convenience getter for [$2]
  B get right => $2;

  @override
  bool operator ==(Object other) {
    return other is Pair && $1 == other.$1 && $2 == other.$2;
  }

  @override
  int get hashCode => $1.hashCode ^ $2.hashCode;

  @override
  String toString() => 'Pair(${$1}, ${$2})';
}
