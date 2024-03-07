<!-- dart package changelog -->

## 0.13.1

- Fix caret syntax on dependencies

## 0.13.0

- Started adding extensions to Map

## 0.12.1

- Fix: ensure fromRadixString() doesn't accept invalid digits

## 0.12.0

- Added `String` <-> `BigInt` converter extensions with support for radix up to 64

## 0.11.2

- Fix: ensure fromRadixString() is case insensitive when radix is <= 32

## 0.11.1

- Fix: allow changing characters to be used by Random() extensions more than once
- Added homeage to pubspec

## 0.11.0

- Allow setting characters to be used by Random() extensions
- Added `int.toRadixExtended()` extension to allow up to base 64 numeral system

## 0.10.1

- Bump dependency to include a required fix for `AnyDateConverter`

## 0.10.0

- Add `toSentenceCase()` and `toTitleCase()` extensions

## 0.9.1

- Update readme and improve score by providing example

## 0.9.0

- Created `eval()` function, just for fun; does not serve any real purpose and should not be used 😅

## 0.8.0

- Add `toArray()` `separatedList()` and `wrappedList()` on `Iterable`
- Add `AnyUriConverter` and `AnyUriOrNullConverter` to converters library
- Add `sleep()` to dart_essentials library

## 0.7.0

- Add `isNullOrEmpty` on `String?`

## 0.6.0

- Add `separated()` and `wrapped()` on `Iterable`

## 0.5.0

- Add `dart_essentials` library
  - includes `Range` class and `range()` function for loops similar to python
- Add a few more extensions on num

## 0.4.0

- Add `nextChar()` and `nextString()` on `Random`

## 0.3.0

- Add `AnyNumConverter` and `AnyNullableNumConverter`

## 0.2.0

- Exports extensions from collection package
- Add `shiftLeft()` and `shiftRight()` on `Iterable`. Not in place, it returns new object
- Renamed json converters

## 0.1.1

- Fix date only format
- Adds `orEmpty` on `Iterable?`

## 0.1.0

- Initial version
- Basic extensions on dart primitives
