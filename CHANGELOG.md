## Master

##### Breaking

* None

##### Enhancements

* SwiftyTextTable is now compatible with both Swift 2.2 and Swift 3.0 on OS X
  and Linux thanks to the great work of [Norio Nomura](https://github.com/norio-nomura).

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
