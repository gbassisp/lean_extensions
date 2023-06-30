import 'package:lean_extensions/src/extensions.dart';
import 'package:meta/meta.dart';

/// Python like range function
Range range(int a, [int? b, int? c]) => Range(a, b, c);

/// Python like range function - with some sanity checks
Range safeRange(int a, [int? b, int? c]) => Range(a, b, c);

/// Iterable of integers; Range is open ended on the right
@immutable
class Range extends Iterable<int> {
  /// dynamic constructor that creates range based on passed arguments
  factory Range(int a, [int? b, int? c]) {
    // both null
    if (b == null && c == null) {
      return Range._(0, a, 1);
    }

    if (b != null && c != null) {
      // both not null
      return Range._(a, b, c);
    }

    // one not null
    final d = b ?? c;
    if (d != null) {
      return Range._(a, d, 1);
    }

    throw ArgumentError('invalid arguments');
  }

  /// main constructor
  const Range._(this.start, this.stop, this.step)
      : assert(
          (stop >= start && step > 0) || (stop <= start && step < 0),
          'stop must be greater than start when step is positive, '
          'or stop must be less than start when step is negative '
          'but got start: $start, stop: $stop, step: $step',
        ),
        assert(step != 0, 'step cannot be zero');

  /// safe constructor
  factory Range.safe({required int stop, int start = 0, int step = 1}) {
    // step is never zero:
    final s = (step.isZero || step.isNaN ? 1 : step);

    // range goes in right direction
    if (stop >= start && s.isNegative) {
      return Range._(start, stop, s.abs());
    }
    if (stop <= start && s.isPositive) {
      return Range._(start, stop, -s.abs());
    }
    return Range._(start, stop, s);
  }

  /// start of range
  final int start;

  /// stop of range
  final int stop;

  /// step of range
  final int step;

  @override
  String toString() => 'Range(start: $start, stop: $stop, step: $step)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Range &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          stop == other.stop &&
          step == other.step;

  @override
  int get hashCode => start.hashCode ^ stop.hashCode ^ step.hashCode;

  /// check direction of range
  bool get _isForward => step > 0;

  @override
  Iterator<int> get iterator {
    return _iter.iterator;
  }

  Iterable<int> get _iter sync* {
    var start = this.start;
    while (true) {
      if (_isForward && start >= stop) {
        break;
      }
      if (!_isForward && start <= stop) {
        break;
      }
      yield start;
      start += step;
    }
  }
}
