## Master

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
