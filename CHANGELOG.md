## Master

##### Breaking

* Update to Swift 4.

##### Enhancements

* None

##### Bug Fixes

* None

## 0.7.1

##### Breaking

* None

##### Enhancements

* None

##### Bug Fixes

* Fix Swift 4.0.2 deprecation of String.characters

## 0.7.0

##### Breaking

* None

##### Enhancements

* CI tests for Xcode 9 and Swift 4 on Linux support.

##### Bug Fixes

* Fixes for Xcode 9 beta 3

## 0.6.0: Table Service

##### Breaking

* `TextTableColumn.width` was refactored to `TextTableColumn.width()` to better
  reflect the O(n) complexity of calculating this value.
* `TextTableObject` was renamed to `TextTableRepresentable`.

##### Enhancements

* Added Documentation.
* Re-enabled console formatting support for Linux.
* Improved compilation time.
* Added convenience method for rendering tables from an array of
  `TextTableRepresentable`s (`renderTextTable`).
* Now available via CocoaPods.

##### Bug Fixes

* None

## 0.5.0: Heading In The Right Direction

##### Breaking

* `TableObject.tableHeaders` was rename `TableObject.columnHeaders` for clarity.

##### Enhancements

* `TextTable`s can now optionally have table headers.
* `TableObject`s can now optionally supply a table header

##### Bug Fixes

* None

## 0.4.0: Swift 3.0 Support

##### Breaking

* `SwiftyTextTable` adopts the new Swift 3.0 convention of explicit first
  parameter labels for functions.
* Linux support for dealing with console formatting escape sequences has been
  removed for the time being due to regular expression portability problems.

##### Enhancements

* Swift 3.0 support!

##### Bug Fixes

* None

## 0.3.1: Swift 2.3 Support

##### Breaking

* None

##### Enhancements

* SwiftyTextTable is now compatible with Swift 2.3 on OS X and Linux thanks to
  the great work of [Norio Nomura](https://github.com/norio-nomura).

##### Bug Fixes

* None

## 0.3.0: Table Objects Oh My!

##### Breaking

* `TextTable.addRow` now takes an array instead of an argument list. This was to
  support `TextTableObject`.

##### Enhancements

* `TextTableObject` allows for easy table creation from an array of objects.
* Better SPM testing support.

##### Bug Fixes

* None

## 0.2.2: No Escape

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix length calculation for string with console escape sequences.  
  [Scott Hoyt](https://github.com/scottrhoyt)
  [#5](https://github.com/scottrhoyt/SwiftyTextTable/issues/5)
