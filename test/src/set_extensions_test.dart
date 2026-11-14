import 'package:lean_extensions/lean_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('Set extensions', () {
    test('addUnique', () {
      final set = <int>{};
      expect(() => set.addUnique(1), returnsNormally);
      expect(() => set.addUnique(2), returnsNormally);
      expect(() => set.addUnique(3), returnsNormally);
      expect(
        () => set.addUnique(3),
        throwsStateError,
        reason: 'number already existed',
      );
    });
  });
}
