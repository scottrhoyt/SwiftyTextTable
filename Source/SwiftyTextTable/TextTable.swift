//
//  TextTable.swift
//  SwiftyTextTable
//
//  Created by Scott Hoyt on 2/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

// MARK: Console Escape Stripping
private let strippingPattern = "(?:\u{001B}\\[(?:[0-9]|;)+m)*(.*?)(?:\u{001B}\\[0m)+"

// We can safely force try this regex because the pattern has be tested to work.
// swiftlint:disable:next force_try
private let strippingRegex = try! NSRegularExpression(pattern: strippingPattern, options: [])

// MARK: - TextTable Protocols

public protocol TextTableObject {
    static var tableHeaders: [String] { get }
    var tableValues: [CustomStringConvertible] { get }
}

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

    func stripped() -> String {
        let matches = strippingRegex
            .matchesInString(self, options: [], range: NSRange(location: 0, length: self.characters.count))
            .map {
                (self as NSString).substringWithRange($0.rangeAtIndex(1))
        }
        return matches.isEmpty ? self : matches.joinWithSeparator("")
    }

    func strippedLength() -> Int {
        return stripped().characters.count
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
        return max(header.strippedLength(), values.reduce(0) { max($0, $1.strippedLength()) })
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

    public init<T: TextTableObject>(objects: [T]) {
        columns = objects.isEmpty ? [] : objects[0].dynamicType.tableHeaders.map { TextTableColumn(header: $0) }
        for object in objects {
            addRow(object.tableValues)
        }
    }

    public mutating func addRow(values: [CustomStringConvertible]) {
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
