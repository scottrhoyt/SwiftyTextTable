//
//  SwiftyTextTableTests.swift
//  SwiftyTextTableTests
//
//  Created by Scott Hoyt on 2/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
import SwiftyTextTable

class SwiftyTextTableTests: XCTestCase {

    var table: TextTable!

    override func setUp() {
        super.setUp()
        let foo = TextTableColumn(header: "foo")
        let bar = TextTableColumn(header: "bar")
        let baz = TextTableColumn(header: "baz")
        table = TextTable(columns: [foo, bar, baz])
        table.addRow("1", "2")
        table.addRow(11, 22, 33)
        table.addRow(111, 222, 333, 444)
    }

    func testRenderDefault() {
        let output = table.render()
        let expected = "+-----+-----+-----+\n" +
                       "| foo | bar | baz |\n" +
                       "+-----+-----+-----+\n" +
                       "| 1   | 2   |     |\n" +
                       "| 11  | 22  | 33  |\n" +
                       "| 111 | 222 | 333 |\n" +
                       "+-----+-----+-----+"
        XCTAssertEqual(output, expected)
    }

    func testRenderCustom() {
        table.columnFence = "!"
        table.rowFence = "*"
        table.cornerFence = "."
        let output = table.render()
        let expected = ".*****.*****.*****.\n" +
                       "! foo ! bar ! baz !\n" +
                       ".*****.*****.*****.\n" +
                       "! 1   ! 2   !     !\n" +
                       "! 11  ! 22  ! 33  !\n" +
                       "! 111 ! 222 ! 333 !\n" +
                       ".*****.*****.*****."
        XCTAssertEqual(output, expected)
    }

    // MARK: - protocol XCTestCaseProvider for SPM
    lazy var allTests: [(String, () throws -> Void)] = [
        ("testRenderDefault", self.testRenderDefault),
        ("testRenderCustom", self.testRenderCustom)
    ]
}
