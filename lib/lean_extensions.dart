/// Extensions and converters to facilitate data modeling with minimal
/// dependencies.
library lean_extensions;

export 'package:collection/collection.dart'
    show
        ComparatorExtension,
        IterableComparableExtension,
        IterableDoubleExtension,
        IterableExtension,
        IterableIntegerExtension,
        IterableIterableExtension,
        IterableNullableExtension,
        IterableNumberExtension,
        ListComparableExtensions,
        ListExtensions;
export 'src/converters.dart';
export 'src/extensions.dart';
