//
//  TextTable.swift
//  SwiftyTextTable
//
//  Created by Scott Hoyt on 2/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

extension String: CustomStringConvertible {
    public var description: String {
        return self
    }
}

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

    public var width: Int {
        return max(strippedLength(header), values.reduce(0) { max($0, strippedLength($1)) })
    }

    // MARK: Console Escape Stripping
    private static let strippingPattern = "(?:\u{001B}\\[(?:[0-9]|;)+m)*(.*?)(?:\u{001B}\\[0m)+"
    // swiftlint:disable:next force_try
    private static let strippingRegex = try! NSRegularExpression(pattern: strippingPattern, options: [])

    private func stripped(string: String) -> String {
        let matches = TextTableColumn.strippingRegex
            .matchesInString(string, options: [], range: NSRange(location: 0, length: string.characters.count))
            .map {
                (string as NSString).substringWithRange($0.rangeAtIndex(1))
            }
        return matches.isEmpty ? string : matches.joinWithSeparator("")
    }

    private func strippedLength(string: String) -> Int {
        return stripped(string).characters.count
    }
}

public struct TextTable {
    private var columns: [TextTableColumn]
    public var columnFence = "|"
    public var rowFence = "-"
    public var cornerFence = "+"

    public init(columns: [TextTableColumn]) {
        self.columns = columns
    }

    public mutating func addRow(values: CustomStringConvertible...) {
        let values = values.count >= columns.count ? values :
            values + [CustomStringConvertible](count: columns.count - values.count, repeatedValue: "")
        columns = zip(columns, values).map {
            (column, value) in
            var column = column
            column.values.append(value.description)
            return column
        }
    }

    public func render() -> String {
        let separator = fence(columns.map({ column in
            Repeat(count: column.width + 2, repeatedValue: rowFence).joinWithSeparator("")
        }), separator: cornerFence)
        let header = fence(columns.map({ " \($0.header.withPadding($0.width)) " }), separator: columnFence)
        let values = (0..<columns.first!.values.count).map({ rowIndex in
            fence(columns.map({ " \($0.values[rowIndex].withPadding($0.width)) " }), separator: columnFence)
        }).joinWithSeparator("\n")
        return [separator, header, separator, values, separator].joinWithSeparator("\n")
    }
}
