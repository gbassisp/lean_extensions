import 'package:lean_extensions/src/closeable.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  group('Closeable', () {
    late _MockCloseable resource;

    setUp(() {
      resource = _MockCloseable([]);
    });

    test('close is called', () async {
      await resource.close();
      expect(resource.closed, isTrue);
    });

    group('runAndClose', () {
      test('executes function and closes resource', () {
        final result = resource.runAndClose((r) => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
      });

      test('closes resource even if function throws', () {
        expect(
          () => resource.runAndClose((r) => throw Exception('test')),
          throwsException,
        );
        expect(resource.closed, isTrue);
      });
    });

    group('runAndCloseAsync', () {
      test('executes async function and closes resource', () async {
        final result = await resource.runAndCloseAsync((r) async => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
      });

      test('closes resource even if async function throws', () async {
        await expectLater(
          resource.runAndCloseAsync((r) async => throw Exception('test')),
          throwsException,
        );
        expect(resource.closed, isTrue);
      });

      test('executes sync function and closes resource', () async {
        final result = await resource.runAndCloseAsync((r) => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
      });
    });

    group('useCloseable', () {
      test('executes function and closes resource', () {
        final result = useCloseable(resource, (r) => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
      });

      test('closes resource even if function throws', () {
        expect(
          () => useCloseable(resource, (r) => throw Exception('test')),
          throwsException,
        );
        expect(resource.closed, isTrue);
      });
    });
  });
}

class _MockCloseable with Closeable {
  _MockCloseable(this.closeables);

  bool closed = false;

  @protected
  @override
  Future<void> close() async {
    closed = true;
  }

  @protected
  @override
  final Iterable<Closeable> closeables;
}
