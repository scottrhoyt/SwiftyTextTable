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

private extension String {
    func withPadding(count: Int) -> String {
        let length = characters.count
        if length < count {
            return self +
                repeatElement(" ", count: count - length).joined(separator: "")
        }
        return self
    }

    func stripped() -> String {
        let matches = strippingRegex
            .matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
            .map {
                NSString(string: self).substring(with: $0.rangeAt(1))
        }
        return matches.isEmpty ? self : matches.joined(separator: "")
    }

    func strippedLength() -> Int {
        return stripped().characters.count
    }
}

private func fence(strings: [String], separator: String) -> String {
    return separator + strings.joined(separator: separator) + separator
}

public struct TextTableColumn {
    public var header: String
    fileprivate var values: [String] = []

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
        columns = objects.isEmpty ? [] : type(of: objects[0]).tableHeaders.map { TextTableColumn(header: $0) }
        objects.forEach { addRow(values: $0.tableValues) }
    }

    public mutating func addRow(values: [CustomStringConvertible]) {
        let values = values.count >= columns.count ? values :
            values + [CustomStringConvertible](repeating: "", count: columns.count - values.count)
        columns = zip(columns, values).map {
            (column, value) in
            var column = column
            column.values.append(value.description)
            return column
        }
    }

    public func render() -> String {
        let separator = fence(strings: columns.map({ column in
            return repeatElement(rowFence, count: column.width + 2).joined(separator: "")
        }), separator: cornerFence)
        let header = fence(strings: columns.map({ " \($0.header.withPadding(count: $0.width)) " }), separator: columnFence)
        let values = columns.isEmpty ? "" : (0..<columns.first!.values.count).map({ rowIndex in
            fence(strings: columns.map({ " \($0.values[rowIndex].withPadding(count: $0.width)) " }), separator: columnFence)
        }).joined(separator: "\n")
        return [separator, header, separator, values, separator].joined(separator: "\n")
    }
}

#if !swift(>=3)
    internal func repeatElement<T>(_ element: T, count: Int) -> Repeated<T> {
        return Repeated(count: count, repeatedValue: element)
    }

    extension Sequence where Iterator.Element == String {
        internal func joined(separator: String) -> String {
            return self.joined(separator: separator)
        }
    }

    extension Array {
        internal init(repeating repeatedValue: Element, count: Int) {
            self.init(repeating: repeatedValue, count: count)
        }
    }
#endif

#if !swift(>=3) || os(Linux)
    extension NSString {
        internal func substring(with range: NSRange) -> String {
            return self.substring(with: range)
        }
    }

    extension NSRegularExpression {
        // swiftlint:disable:next line_length
        internal func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [NSTextCheckingResult] {
            return self.matches(in: string, options: options, range: range)
        }
    }

    extension NSTextCheckingResult {
        internal func range(at idx: Int) -> NSRange {
            return rangeAt(idx)
        }
    }
#endif
