# SwiftyTextTable

A lightweight Swift library for generating text tables.

[![Build Status](https://travis-ci.org/scottrhoyt/SwiftyTextTable.svg?branch=master)](https://travis-ci.org/scottrhoyt/SwiftyTextTable)
[![codecov.io](https://codecov.io/github/scottrhoyt/SwiftyTextTable/coverage.svg?branch=master)](https://codecov.io/github/scottrhoyt/SwiftyTextTable?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Platform OS X + Linux](https://img.shields.io/badge/Platform-OS%20X%20%2B%20Linux-blue.svg)
[![Language Swift 2.3](https://img.shields.io/badge/Language-Swift%202.3-orange.svg)](https://swift.org)

## Swift 3.0

Currently Swift 3.0 support is a work in progress. The library is stable under
OS X using Xcode 8 or SPM, but not Linux. To access Swift 3.0 support use the
branch `swift3`.

The Swift 3.0 implementation is not backwards compatible with Swift < 3.0 and
introduces breaking changes due to explicit first parameter labels for
functions.

SwiftyTextTable 0.4.0 will introduce Swift 3.0 support. To prevent problems in
codebases not yet updated to Swift 3.0, pin your version to `0.3.1`.

## Installation

### Carthage (OS X)
You can use [Carthage](https://github.com/Carthage/Carthage) to install
`SwiftyTextTable` by adding it to your `Cartfile`:
```
github "scottrhoyt/SwiftyTextTable"
```

### Swift Package Manager (OS X + Linux)
You can use [The Swift Package Manager](https://swift.org/package-manager) to
install `SwiftyTextTable` by adding the proper description to your
`Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", versions: "0.3.1" ..< Version.max)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is
still in early design and development, for more infomation checkout its
[GitHub Page](https://github.com/apple/swift-package-manager)

### Manual

Simply copy the `*.swift` files from the `Source/SwiftyTextTable` directory into
your project.

## Usage

```swift
import SwiftyTextTable

// First create some columns
let foo = TextTableColumn(header: "foo")
let bar = TextTableColumn(header: "bar")
let baz = TextTableColumn(header: "baz")

// Then create a table with the columns
var table = TextTable(columns: [foo, bar, baz])

// Then add some rows
table.addRow([1, 2, 3])
table.addRow([11, 22, 33])

// Then render the table and use
let tableString = table.render()
print(tableString)

/*
+-----+-----+-----+
| foo | bar | baz |
+-----+-----+-----+
| 1   | 2   | 3   |
| 11  | 22  | 33  |
+-----+-----+-----+
*/
```

Any `CustomStringConvertible` can be used for row `values`.

### Fence Custimization

You can also customize the output of `TextTable.render()` by using different
values for `columnFence`, `rowFence`, and `cornerFence`.

```swift
table.columnFence = ":"
table.rowFence = "."
table.cornerFence = "."

print(table.render())

/*
...................
: foo : bar : baz :
...................
: 1   : 2   :     :
: 11  : 22  : 33  :
...................
*/
```

### Row Padding/Truncation

When adding rows, `TextTable` will automatically pad the rows with empty strings
when there are fewer `values` than columns. `TextTable` will also disregard all
`values` over the column count.

```swift
let foo = TextTableColumn(header: "foo")
let bar = TextTableColumn(header: "bar")
let baz = TextTableColumn(header: "baz")

var table = TextTable(columns: [foo, bar, baz])

table.addRow([1, 2])
table.addRow([11, 22, 33])
table.addRow([111, 222, 333, 444])

let tableString = table.render()
print(tableString)

/*
+-----+-----+-----+
| foo | bar | baz |
+-----+-----+-----+
| 1   | 2   |     |
| 11  | 22  | 33  |
| 111 | 222 | 333 |
+-----+-----+-----+
*/
```

### Creating Tables from Arrays of Objects with `TextTableObject`

Let's say you have an array of objects that looks this:

```swift
enum AnimalType: String, CustomStringConvertible {
    case Dog = "Dog"
    case Cat = "Cat"
    case Gorilla = "Gorilla"

    var description: String {
        return self.rawValue
    }
}

struct Pet {
    let type: AnimalType
    let name: String
    let canHazPizza: Bool
}

let furball = Pet(type: .Cat, name: "Furball", canHazPizza: false)
let bestFriend = Pet(type: .Dog, name: "Best Friend", canHazPizza: true)
let scary = Pet(type: .Gorilla, name: "Scary", canHazPizza: true)
let pets = [furball, bestFriend, scary]
```

Now you want to print a table containing your `pets`. You can accomplish this
by having `Pet` conform to `TextTableObject`:

```swift
extension Pet: TextTableObject {
    static var tableHeaders: [String] {
        return ["Name", "Animal", "Can Haz Pizza?"]
    }

    var tableValues: [CustomStringConvertible] {
        return [name, type, canHazPizza ? "yes" : "no"]
    }
}
```

You can now print a table of your `pets` simply:

```swift
let table = TextTable(objects: pets)
print(table.render())

/*
+-------------+---------+----------------+
| Name        | Animal  | Can Haz Pizza? |
+-------------+---------+----------------+
| Furball     | Cat     | no             |
| Best Friend | Dog     | yes            |
| Scary       | Gorilla | yes            |
+-------------+---------+----------------+
*/
```

## License

SwiftyTextTable is released under the [MIT License](https://github.com/scottrhoyt/SwiftyTextTable/blob/master/LICENSE).
