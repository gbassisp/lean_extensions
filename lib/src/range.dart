import 'package:lean_extensions/src/extensions.dart';
import 'package:meta/meta.dart';

/// Range builder function signature
@internal
typedef RangeFactory = Range Function(int a, int b, int c);

/// Python like range function
Range range(int a, [int? b, int? c]) {
  assert(Range._unsafe(a, b, c)._isValid, 'invalid arguments');

  return Range(a, b, c);
}

/// Python like range function - with some sanity checks
@internal
Range safeRange(int a, [int? b, int? c]) => Range(a, b, c);

/// Iterable of integers; Range is open ended on the right
@immutable
class Range extends Iterable<int> {
  /// safe constructor - returns empty range if arguments are invalid
  factory Range(int a, [int? b, int? c]) {
    // step is never zero:
    final step = c ?? 1;
    if (step.isZero || step.isNaN) {
      return Range.empty();
    }
    // sanity check
    assert(
      step != 0,
      'Something wrong with this logic; '
      'step should non-zero int, but got $step',
    );

    var start = 0;
    var stop = 0;
    // start and stop values:
    if (b != null) {
      start = a;
      stop = b;
    } else {
      start = 0;
      stop = a;
    }

    // confirm direction
    if (_isInRange(start, stop, step)) {
      return Range._(start, stop, step);
    }
    return Range.empty();
  }

  /// dynamic constructor that creates range based on passed arguments;
  /// It does not run any sanity checks, so it is possible to create invalid
  /// ranges where assertion errors will happen.
  factory Range._unsafe(int a, [int? b, int? c, RangeFactory? factory]) {
    final f =
        factory ?? (int a, int b, int c) => Range._(a, b, c).._assertValid();
    // both null
    if (b == null && c == null) {
      return f(0, a, 1);
    }

    if (b != null && c != null) {
      // both not null
      return f(a, b, c);
    }

    // one not null
    final d = b ?? c;
    if (d != null) {
      return f(a, d, 1);
    }

    throw ArgumentError('invalid arguments');
  }

  /// main constructor - no defaults
  const Range._(this.start, this.stop, this.step)
      : assert(
          (stop >= start && step > 0) || (stop <= start && step < 0),
          'stop must be greater than start when step is positive, '
          'or stop must be less than start when step is negative '
          'but got start: $start, stop: $stop, step: $step',
        ),
        assert(step != 0, 'step cannot be zero');

  /// empty range - same as range(0)
  factory Range.empty() => Range(0, 0, 1);

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

  /// check if range is valid
  bool get _isValid =>
      (stop >= start && step > 0) || (stop <= start && step < 0);

  void _assertValid() {
    assert(_isValid, 'invalid range: $this');
  }

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

bool _isInRange(int start, int stop, int step) {
  if (step == 0) {
    return false;
  }

  if (step > 0) {
    return start <= stop;
  }
  return start >= stop;
}
