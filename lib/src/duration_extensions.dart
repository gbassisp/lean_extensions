/// extensions to convert [num] to [Duration]
extension LeanNumToDurationExtension on num {
  /// [Duration] from this as weeks
  Duration get weeks => (this * 7).days;

  /// [Duration] from this as days
  Duration get days => (this * 24).hours;

  /// [Duration] from this as hours
  Duration get hours => (this * 60).minutes;

  /// [Duration] from this as minutes
  Duration get minutes => (this * 60).seconds;

  /// [Duration] from this as seconds
  Duration get seconds => (this * 1000).milliseconds;

  /// [Duration] from this as milliseconds
  Duration get milliseconds => (this * 1000).microseconds;

  /// [Duration] from this as microseconds
  Duration get microseconds => Duration(microseconds: toInt());
}
