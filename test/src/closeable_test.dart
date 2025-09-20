import 'package:lean_extensions/src/closeable.dart';
import 'package:test/test.dart';

void main() {
  group('Closeable', () {
    late _MockCloseable resource;

    setUp(() {
      resource = _MockCloseable([]);
    });

    group('runAndClose', () {
      test('executes function and closes resource', () {
        final result = resource.runAndClose((r) => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });

      test('closes resource even if function throws', () {
        expect(
          () => resource.runAndClose((r) => throw Exception('test')),
          throwsException,
        );
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });
    });

    group('runAndCloseAsync', () {
      test('executes async function and closes resource', () async {
        final result = await resource.runAndCloseAsync((r) async => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });

      test('closes resource even if async function throws', () async {
        await expectLater(
          resource.runAndCloseAsync((r) async => throw Exception('test')),
          throwsException,
        );
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });

      test('executes sync function and closes resource', () async {
        final result = await resource.runAndCloseAsync((r) => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });
    });

    group('useCloseable', () {
      test('executes function and closes resource', () {
        final result = useCloseable(resource, (r) => 42);
        expect(result, 42);
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });

      test('closes resource even if function throws', () {
        expect(
          () => useCloseable(resource, (r) => throw Exception('test')),
          throwsException,
        );
        expect(resource.closed, isTrue);
        expect(resource.isClosed, isTrue);
      });
    });

    group('nested closeables', () {
      late _MockCloseable innerResource1;
      late _MockCloseable innerResource2;
      late _MockCloseable parentResource;

      setUp(() {
        innerResource1 = _MockCloseable([]);
        innerResource2 = _MockCloseable([]);
        parentResource = _MockCloseable([innerResource1, innerResource2]);
      });

      test('close() closes all resources when awaited', () async {
        final closeOrder = <String>[];
        final inner1 = _OrderedCloseable('inner1', closeOrder);
        final inner2 = _OrderedCloseable('inner2', closeOrder);
        final parent =
            _OrderedCloseable('parent', closeOrder, [inner1, inner2]);

        await parent.runAndCloseAsync((r) => null);

        expect(inner1.closed, isTrue);
        expect(inner2.closed, isTrue);
        expect(parent.closed, isTrue);
        expect(inner1.isClosed, isTrue);
        expect(inner2.isClosed, isTrue);
        expect(parent.isClosed, isTrue);
        // Parent is closed first by the mixin
        expect(closeOrder, ['parent', 'inner1', 'inner2']);
      });

      test('runAndClose closes all resources', () {
        final result = parentResource.runAndClose((r) => 42);

        expect(result, 42);
        expect(
          parentResource.closed,
          isTrue,
          reason: 'parent should be closed',
        );
        expect(
          innerResource1.closed,
          isTrue,
          reason: 'inner1 should be closed',
        );
        expect(
          innerResource2.closed,
          isTrue,
          reason: 'inner2 should be closed',
        );
        expect(
          parentResource.isClosed,
          isTrue,
          reason: 'parent should be closed',
        );
        expect(
          innerResource1.isClosed,
          isTrue,
          reason: 'inner1 should be closed',
        );
        expect(
          innerResource2.isClosed,
          isTrue,
          reason: 'inner2 should be closed',
        );
      });

      test('runAndCloseAsync closes all resources', () async {
        final result = await parentResource.runAndCloseAsync((r) async => 42);

        expect(result, 42);
        expect(
          parentResource.closed,
          isTrue,
          reason: 'parent should be closed',
        );
        expect(
          innerResource1.closed,
          isTrue,
          reason: 'inner1 should be closed',
        );
        expect(
          innerResource2.closed,
          isTrue,
          reason: 'inner2 should be closed',
        );
        expect(
          parentResource.isClosed,
          isTrue,
          reason: 'parent should be closed',
        );
        expect(
          innerResource1.isClosed,
          isTrue,
          reason: 'inner1 should be closed',
        );
        expect(
          innerResource2.isClosed,
          isTrue,
          reason: 'inner2 should be closed',
        );
      });

      test('useCloseable closes all resources', () {
        final result = useCloseable(parentResource, (r) => 42);

        expect(result, 42);
        expect(
          parentResource.closed,
          isTrue,
          reason: 'parent should be closed',
        );
        expect(
          innerResource1.closed,
          isTrue,
          reason: 'inner1 should be closed',
        );
        expect(
          innerResource2.closed,
          isTrue,
          reason: 'inner2 should be closed',
        );
        expect(
          parentResource.isClosed,
          isTrue,
          reason: 'parent should be closed',
        );
        expect(
          innerResource1.isClosed,
          isTrue,
          reason: 'inner1 should be closed',
        );
        expect(
          innerResource2.isClosed,
          isTrue,
          reason: 'inner2 should be closed',
        );
      });

      test('propagates exception but still closes all resources', () async {
        final throwingResource = _ThrowingCloseable();
        final normalResource = _MockCloseable([]);
        final parent = _MockCloseable([throwingResource, normalResource]);

        await expectLater(
          () {
            return parent.runAndCloseAsync((r) async => null);
          },
          throwsException,
        );

        expect(
          throwingResource.closed,
          isTrue,
          reason: 'throwing resource should be closed',
        );
        expect(
          normalResource.closed,
          isTrue,
          reason: 'normal resource should be closed',
        );
        expect(parent.closed, isTrue, reason: 'parent should be closed');
        expect(
          throwingResource.isClosed,
          isTrue,
          reason: 'throwing resource should be closed',
        );
        expect(
          normalResource.isClosed,
          isTrue,
          reason: 'normal resource should be closed',
        );
        expect(parent.isClosed, isTrue, reason: 'parent should be closed');
      });
    });
  });
}

class _MockCloseable with Closeable {
  _MockCloseable(this.closeables);

  bool closed = false;

  @override
  Future<void> close() async {
    closed = true;
  }

  @override
  final Iterable<Closeable> closeables;
}

class _ThrowingCloseable with Closeable {
  bool closed = false;

  @override
  Future<void> close() async {
    closed = true;
    throw Exception('Failed to close');
  }

  @override
  Iterable<Closeable> get closeables => const [];
}

class _OrderedCloseable with Closeable {
  _OrderedCloseable(this.name, this.closeOrder, [this.closeables = const []]);

  final String name;
  final List<String> closeOrder;
  bool closed = false;

  @override
  final Iterable<Closeable> closeables;

  @override
  Future<void> close() async {
    closeOrder.add(name);
    closed = true;
  }
}
