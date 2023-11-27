import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';

void main() async {
  // some python-like functionality
  for (final i in range(10)) {
    await sleep(i);
  }

  // some converters for easy (de)serialization
  const converter = AnyDateConverter();
  final date1 = converter.fromJson('25 Nov 2023');
  if (date1 == DateTime(2023, 11, 25)) {
    // it worked
  }
}
