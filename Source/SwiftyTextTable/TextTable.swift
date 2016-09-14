//
//  TextTable.swift
//  SwiftyTextTable
//
//  Created by Scott Hoyt on 2/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

// MARK: Console Escape Stripping
// Because of an error using the Linux implementation of Foundation's RegularExpression,
// escape stripping is only available on Apple platforms
#if os(Linux)
    private extension String {
        func stripped() -> String {
            return self
        }
    }
#else
    private let strippingPattern = "(?:\u{001B}\\[(?:[0-9]|;)+m)*(.*?)(?:\u{001B}\\[0m)+"

    // We can safely force try this regex because the pattern has be tested to work.
    // swiftlint:disable:next force_try
    private let strippingRegex = try! NSRegularExpression(pattern: strippingPattern, options: [])

    private extension String {
        func stripped() -> String {
            let matches = strippingRegex
                .matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
                .map {
                    NSString(string: self).substring(with: $0.rangeAt(1))
            }
            return matches.isEmpty ? self : matches.joined(separator: "")
        }
    }
#endif

// MARK: Helper Extensions

private extension String {
    func withPadding(count: Int) -> String {
        let length = characters.count
        if length < count {
            return self +
                repeatElement(" ", count: count - length).joined(separator: "")
        }
        return self
    }

    func strippedLength() -> Int {
        return stripped().characters.count
    }
}

private extension Array where Element: CustomStringConvertible {
    func paragraph() -> String {
        return self.map({ $0.description }).joined(separator: "\n")
    }
}

// MARK: - TextTable Protocols

public protocol TextTableObject {
    static var tableHeaders: [String] { get }
    var tableValues: [CustomStringConvertible] { get }
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
    public var header: String? = nil

    public init(columns: [TextTableColumn], header: String? = nil) {
        self.columns = columns
        self.header = header
    }

    public init<T: TextTableObject>(objects: [T], header: String? = nil) {
        self.header = header
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
            return repeatElement(rowFence, count: column.width + 2).joined()
        }), separator: cornerFence)

        var top: String
        if let tableHeader = renderTableHeader() {
            top = tableHeader
        } else {
            top = separator
        }

        let columnHeaders = fence(strings: columns.map({ " \($0.header.withPadding(count: $0.width)) " }), separator: columnFence)

        let values = columns.isEmpty ? "" : (0..<columns.first!.values.count).map({ rowIndex in
            fence(strings: columns.map({ " \($0.values[rowIndex].withPadding(count: $0.width)) " }), separator: columnFence)
        }).paragraph()

        return [top, columnHeaders, separator, values, separator].paragraph()
    }

    private func renderTableHeader() -> String? {
        guard let header = header else {
            return nil
        }

        let separator = cornerFence +
            repeatElement(rowFence, count: columns.reduce(0, { $0 + $1.width + 2 }) + columns.count - 1).joined() +
            cornerFence
        let title = fence(strings: [" \(header.withPadding(count: separator.characters.count - 4)) "], separator: columnFence)

        return [separator, title, separator].paragraph()
    }
}
