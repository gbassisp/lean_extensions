/// an enum to represent a locale for internal logic
enum InternalLocale {
  /// en_US and en locales
  enUs,

  /// all other en_** locales
  enUk,

  /// any unimplemented locale
  unsupported,
}

/// an internal function to convert locale tag to enum for logic in switch
InternalLocale parseLocale(String? tag) {
  final t = _simple(tag);
  if (t.isEmpty) {
    return InternalLocale.enUs;
  }

  if (t.first == 'en') {
    t.removeAt(0);
    if (t.isEmpty || t.first == 'us') {
      return InternalLocale.enUs;
    } else {
      return InternalLocale.enUk;
    }
  }

  return InternalLocale.unsupported;
}

List<String> _simple(String? tag) {
  final t = tag;
  if (t == null) {
    return [];
  }

  return t
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('_+'), '-')
      .replaceAll('-+', '-')
      .split('-');
}
