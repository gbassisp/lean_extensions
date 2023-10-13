/// wrapper around Future.delayed to have a simpler syntax
Future<void> sleep(double seconds) =>
    Future.delayed(Duration(microseconds: (seconds * 1000000).toInt()));
