import 'dart:typed_data';

import 'package:lean_extensions/lean_extensions.dart';

/// adds extensions to collections of ints
extension LeanListIntBytesExtensions on Iterable<int> {
  /// converts this to [Uint8List]
  Uint8List toUint8List() => Uint8List.fromList(toArray());
}

/// adds extensions to [Uint8List]
extension LeanUint8ListBytesExtensions on Uint8List {
  /// converts to the hex string representation, e.g., '0x010203
  String toHexString() =>
      '0x${toList().map((e) => e.toRadixString(16).padLeft(2, '0')).join()}';
}
