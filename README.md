# SwiftyTextTable

A lightweight Swift library for generating text tables.

[![Build Status](https://travis-ci.org/scottrhoyt/SwiftyTextTable.svg?branch=master)](https://travis-ci.org/scottrhoyt/SwiftyTextTable)
[![codecov.io](https://codecov.io/github/scottrhoyt/SwiftyTextTable/coverage.svg?branch=master)](https://codecov.io/github/scottrhoyt/SwiftyTextTable?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installation

### Carthage (iOS 8+, OS X 10.9+)
You can use [Carthage](https://github.com/Carthage/Carthage) to install
`SwiftyTextTable` by adding it to your `Cartfile`:
```
github "scottrhoyt/SwiftyTextTable"
```

### Swift Package Manager
You can use [The Swift Package Manager](https://swift.org/package-manager) to
install `SwiftyTextTable` by adding the proper description to your
`Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", versions: "0.1.0" ..< Version.max)
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
table.addRow(1, 2, 3)
table.addRow(11, 22, 33)

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

### Row Padding/Truncation

When adding rows, `TextTable` will automatically pad the rows with empty strings
when there are fewer `values` than columns. `TextTable` will also disregard all
`values` over the column count.

```swift
let foo = TextTableColumn(header: "foo")
let bar = TextTableColumn(header: "bar")
let baz = TextTableColumn(header: "baz")

var table = TextTable(columns: [foo, bar, baz])

table.addRow(1, 2)
table.addRow(11, 22, 33)
table.addRow(111, 222, 333, 444)

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
