//
//  TextTable.swift
//  SwiftyTextTable
//
//  Created by Scott Hoyt on 2/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

private extension String {
    private func withPadding(count: Int) -> String {
        let length = characters.count
        if length < count {
            return self +
                Repeat(count: count - length, repeatedValue: " ").joinWithSeparator("")
        }
        return self
    }
}

private func fence(strings: [String], separator: String) -> String {
    return separator + strings.joinWithSeparator(separator) + separator
}

public struct TextTableColumn {
    public var header: String
    private var values: [String] = []

    public init(header: String) {
        self.header = header
    }

    var width: Int {
        return max(header.characters.count, values.reduce(0) { max($0, $1.characters.count) })
    }
}

public struct TextTable {
    private var columns: [TextTableColumn]

    public init(columns: [TextTableColumn]) {
        self.columns = columns
    }

    public mutating func addRow(values: CustomStringConvertible...) {
        var values = values
        if values.count < columns.count {
            let blank: CustomStringConvertible = ""
            values.appendContentsOf([CustomStringConvertible](count: columns.count - values.count, repeatedValue: blank))
        }
        columns = zip(columns, values).map {
            (column, value) in
            var column = column
            column.values.append(value.description)
            return column
        }
    }

    public func render() -> String {
        let separator = fence(columns.map({ column in
            Repeat(count: column.width + 2, repeatedValue: "-").joinWithSeparator("")
        }), separator: "+")
        let header = fence(columns.map({ " \($0.header.withPadding($0.width)) " }), separator: "|")
        let values = (0..<columns.first!.values.count).map({ rowIndex in
            fence(columns.map({ " \($0.values[rowIndex].withPadding($0.width)) " }), separator: "|")
        }).joinWithSeparator("\n")
        return [separator, header, separator, values, separator].joinWithSeparator("\n")
    }
}
