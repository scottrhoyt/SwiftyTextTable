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

    func fooTable() -> TextTable {
        let foo = TextTableColumn(header: "foo")
        let bar = TextTableColumn(header: "bar")
        let baz = TextTableColumn(header: "baz")
        var table = TextTable(columns: [foo, bar, baz])
        table.addRow(values: ["1", "2"])
        table.addRow(values: [11, 22, 33])
        table.addRow(values: [111, 222, 333, 444])
        return table
    }

    func testRenderDefault() {
        let output = fooTable().render()
        let expected = "+-----+-----+-----+\n" +
                       "| foo | bar | baz |\n" +
                       "+-----+-----+-----+\n" +
                       "| 1   | 2   |     |\n" +
                       "| 11  | 22  | 33  |\n" +
                       "| 111 | 222 | 333 |\n" +
                       "+-----+-----+-----+"
        XCTAssertEqual(output, expected)
    }

    func testRenderDefaultWithHeader() {
        var table = fooTable()
        table.header = "foo table"
        let output = table.render()
        let expected = "+-----------------+\n" +
                       "| foo table       |\n" +
                       "+-----------------+\n" +
                       "| foo | bar | baz |\n" +
                       "+-----+-----+-----+\n" +
                       "| 1   | 2   |     |\n" +
                       "| 11  | 22  | 33  |\n" +
                       "| 111 | 222 | 333 |\n" +
                       "+-----+-----+-----+"
        XCTAssertEqual(output, expected)
    }

    func testRenderCustom() {
        var table = fooTable()
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

    func testRenderCustomWithHeader() {
        var table = fooTable()
        table.columnFence = "!"
        table.rowFence = "*"
        table.cornerFence = "."
        table.header = "foo table"
        let output = table.render()
        let expected = ".*****************.\n" +
                       "! foo table       !\n" +
                       ".*****************.\n" +
                       "! foo ! bar ! baz !\n" +
                       ".*****.*****.*****.\n" +
                       "! 1   ! 2   !     !\n" +
                       "! 11  ! 22  ! 33  !\n" +
                       "! 111 ! 222 ! 333 !\n" +
                       ".*****.*****.*****."
        XCTAssertEqual(output, expected)
    }

    func testStripping() {
        #if os(Linux)
            return
        #else
            let c1 = TextTableColumn(header: "\u{001B}[0mHello\u{001B}[0m")
            XCTAssertEqual(c1.width(), 5)

            let c2 = TextTableColumn(header: "\u{001B}[31m\u{001B}[4;31;93mHello World\u{001B}[0m\u{001B}[0m")
            XCTAssertEqual(c2.width(), 11)

            let c3 = TextTableColumn(header: "\u{001B}[0m\u{001B}[0m")
            XCTAssertEqual(c3.width(), 0)

            let c4 = TextTableColumn(header: "\u{001B}[31mHello World\u{001B}[0m")
            XCTAssertEqual(c4.width(), 11)

            let c5 = TextTableColumn(header: "\u{001B}[4;31;42;93;5mHello World\u{001B}[0m")
            XCTAssertEqual(c5.width(), 11)

            let c6 = TextTableColumn(header: "\u{001B}[4;31;93mHello World\u{001B}[0m")
            XCTAssertEqual(c6.width(), 11)

            let c7 = TextTableColumn(header: "Hello World")
            XCTAssertEqual(c7.width(), 11)
        
            let c8 = TextTableColumn(header: "\u{001B}[0;31mHello World\u{001B}[0;30m")
            XCTAssertEqual(c8.width(), 11)
        
            let c9 = TextTableColumn(header: "\u{001B}[1;31mHello World\u{001B}[0;30m")
            XCTAssertEqual(c9.width(), 11)

            let c10 = TextTableColumn(header: "\u{1B}[31mHello World\u{1B}[0m")
            XCTAssertEqual(c10.width(), 11)

            // Test underline
            let c11 = TextTableColumn(header: "\u{1B}[31;4mX\u{1B}[0m")
            XCTAssertEqual(c11.width(), 1)

            // Test bold
            let c12 = TextTableColumn(header: "\u{1B}[31;1mX\u{1B}[0m")
            XCTAssertEqual(c12.width(), 1)
        #endif
    }

    func testTextTableRepresentables() {
        // swiftlint:disable:next nesting
        struct TableObject: TextTableRepresentable {
            static var columnHeaders: [String] {
                return [ "foo", "bar", "baz"]
            }

            let foo: Int
            let bar: String
            let baz: Double

            var tableValues: [CustomStringConvertible] {
                return [foo, bar, baz]
            }
        }

        let objects = [
            TableObject(foo: 1, bar: "2", baz: 3),
            TableObject(foo: 11, bar: "22", baz: 33),
            TableObject(foo: 111, bar: "222", baz: 333)
        ]

        let expected = "+-----+-----+-------+\n" +
                       "| foo | bar | baz   |\n" +
                       "+-----+-----+-------+\n" +
                       "| 1   | 2   | 3.0   |\n" +
                       "| 11  | 22  | 33.0  |\n" +
                       "| 111 | 222 | 333.0 |\n" +
                       "+-----+-----+-------+"

        XCTAssertEqual(objects.renderTextTable(), expected)

        let emptyExpected = "+-----+-----+-----+\n" +
                            "| foo | bar | baz |\n" +
                            "+-----+-----+-----+\n" +
                            "\n"                    +
                            "+-----+-----+-----+"
        XCTAssertEqual([TableObject]().renderTextTable(), emptyExpected)
    }

    func testTextTableRepresentablesWithHeader() {
        // swiftlint:disable:next nesting
        struct TableObject: TextTableRepresentable {
            static var tableHeader: String? {
                return "foo table"
            }
            static var columnHeaders: [String] {
                return [ "foo", "bar", "baz"]
            }

            let foo: Int
            let bar: String
            let baz: Double

            var tableValues: [CustomStringConvertible] {
                return [foo, bar, baz]
            }
        }

        let objects = [
            TableObject(foo: 1, bar: "2", baz: 3),
            TableObject(foo: 11, bar: "22", baz: 33),
            TableObject(foo: 111, bar: "222", baz: 333)
        ]

        let expected = "+-------------------+\n" +
                       "| foo table         |\n" +
                       "+-------------------+\n" +
                       "| foo | bar | baz   |\n" +
                       "+-----+-----+-------+\n" +
                       "| 1   | 2   | 3.0   |\n" +
                       "| 11  | 22  | 33.0  |\n" +
                       "| 111 | 222 | 333.0 |\n" +
                       "+-----+-----+-------+"

        XCTAssertEqual(objects.renderTextTable(), expected)

        let emptyExpected = "+-----------------+\n" +
                            "| foo table       |\n" +
                            "+-----------------+\n" +
                            "| foo | bar | baz |\n" +
                            "+-----+-----+-----+\n" +
                            "\n"                    +
                            "+-----+-----+-----+"
        XCTAssertEqual([TableObject]().renderTextTable(), emptyExpected)
    }

    func testColumnHeaderUpdate() {
        var foo = TextTableColumn(header: "not-foo")
        foo.header = "foo"
        XCTAssertEqual(foo.width(), 3)
    }

    func testAddRows() {
        let foo = TextTableColumn(header: "foo")
        let bar = TextTableColumn(header: "bar")
        let baz = TextTableColumn(header: "baz")
        var table = TextTable(columns: [foo, bar, baz])
        table.addRows(values: [["1", "2"], [11, 22, 33], [111, 222, 333, 444]])

        XCTAssertEqual(fooTable().render(), table.render())
    }

    func testClearRows() {
        let foo = TextTableColumn(header: "foo")
        let bar = TextTableColumn(header: "bar")
        let baz = TextTableColumn(header: "baz")
        var table = TextTable(columns: [foo, bar, baz])
        table.addRows(values: [["1", "2"], [11, 22, 33], [111, 222, 333, 444]])
        table.clearRows()
        table.addRows(values: [["1", "2"], [11, 22, 33], [111, 222, 333, 444]])

        XCTAssertEqual(fooTable().render(), table.render())
    }

    func testAddRowPerformance() {
        var rows = usPresidents
        let columns = rows.removeFirst().map(TextTableColumn.init)
        var table = TextTable(columns: columns)

        measure {
            table.clearRows()
            rows.forEach { table.addRow(values: $0) }
            let output = table.render()
            let lines = output.components(separatedBy: .newlines)
            XCTAssertEqual(lines.count, rows.count + 4)
        }
    }

    func testAddRowsPerformance() {
        var rows = usPresidents
        let columns = rows.removeFirst().map(TextTableColumn.init)
        var table = TextTable(columns: columns)

        measure {
            table.clearRows()
            table.addRows(values: rows)
            let output = table.render()
            let lines = output.components(separatedBy: .newlines)
            XCTAssertEqual(lines.count, rows.count + 4)
        }
    }

    let usPresidents = [
        ["Presidency", "President", "Wikipedia Entry", "Took office", "Left office", "Party", "Portrait", "Thumbnail", "Home State"],
        ["1", "George Washington", "http://en.wikipedia.org/wiki/George_Washington", "30/04/1789", "4/03/1797", "Independent ", "GeorgeWashington.jpg", "thmb_GeorgeWashington.jpg", "Virginia"],
        ["2", "John Adams", "http://en.wikipedia.org/wiki/John_Adams", "4/03/1797", "4/03/1801", "Federalist ", "JohnAdams.jpg", "thmb_JohnAdams.jpg", "Massachusetts"],
        ["3", "Thomas Jefferson", "http://en.wikipedia.org/wiki/Thomas_Jefferson", "4/03/1801", "4/03/1809", "Democratic-Republican ", "Thomasjefferson.gif", "thmb_Thomasjefferson.gif", "Virginia"],
        ["4", "James Madison", "http://en.wikipedia.org/wiki/James_Madison", "4/03/1809", "4/03/1817", "Democratic-Republican ", "JamesMadison.gif", "thmb_JamesMadison.gif", "Virginia"],
        ["5", "James Monroe", "http://en.wikipedia.org/wiki/James_Monroe", "4/03/1817", "4/03/1825", "Democratic-Republican ", "JamesMonroe.gif", "thmb_JamesMonroe.gif", "Virginia"],
        ["6", "John Quincy Adams", "http://en.wikipedia.org/wiki/John_Quincy_Adams", "4/03/1825", "4/03/1829", "Democratic-Republican/National Republican ", "JohnQuincyAdams.gif", "thmb_JohnQuincyAdams.gif", "Massachusetts"],
        ["7", "Andrew Jackson", "http://en.wikipedia.org/wiki/Andrew_Jackson", "4/03/1829", "4/03/1837", "Democratic", "Andrew_jackson_head.gif", "thmb_Andrew_jackson_head.gif", "Tennessee"],
        ["8", "Martin Van Buren", "http://en.wikipedia.org/wiki/Martin_Van_Buren", "4/03/1837", "4/03/1841", "Democratic", "MartinVanBuren.gif", "thmb_MartinVanBuren.gif", "New York"],
        ["9", "William Henry Harrison", "http://en.wikipedia.org/wiki/William_Henry_Harrison", "4/03/1841", "4/04/1841", "Whig", "WilliamHenryHarrison.gif", "thmb_WilliamHenryHarrison.gif", "Ohio"],
        ["10", "John Tyler", "http://en.wikipedia.org/wiki/John_Tyler", "4/04/1841", "4/03/1845", "Whig", "JohnTyler.jpg", "thmb_JohnTyler.jpg", "Virginia"],
        ["11", "James K. Polk", "http://en.wikipedia.org/wiki/James_K._Polk", "4/03/1845", "4/03/1849", "Democratic", "JamesKPolk.gif", "thmb_JamesKPolk.gif", "Tennessee"],
        ["12", "Zachary Taylor", "http://en.wikipedia.org/wiki/Zachary_Taylor", "4/03/1849", "9/07/1850", "Whig", "ZacharyTaylor.jpg", "thmb_ZacharyTaylor.jpg", "Louisiana"],
        ["13", "Millard Fillmore", "http://en.wikipedia.org/wiki/Millard_Fillmore", "9/07/1850", "4/03/1853", "Whig", "MillardFillmore.png", "thmb_MillardFillmore.png", "New York"],
        ["14", "Franklin Pierce", "http://en.wikipedia.org/wiki/Franklin_Pierce", "4/03/1853", "4/03/1857", "Democratic", "FranklinPierce.gif", "thmb_FranklinPierce.gif", "New Hampshire"],
        ["15", "James Buchanan", "http://en.wikipedia.org/wiki/James_Buchanan", "4/03/1857", "4/03/1861", "Democratic", "JamesBuchanan.gif", "thmb_JamesBuchanan.gif", "Pennsylvania"],
        ["16", "Abraham Lincoln", "http://en.wikipedia.org/wiki/Abraham_Lincoln", "4/03/1861", "15/04/1865", "Republican/National Union", "AbrahamLincoln.jpg", "thmb_AbrahamLincoln.jpg", "Illinois"],
        ["17", "Andrew Johnson", "http://en.wikipedia.org/wiki/Andrew_Johnson", "15/04/1865", "4/03/1869", "Democratic/National Union", "AndrewJohnson.gif", "thmb_AndrewJohnson.gif", "Tennessee"],
        ["18", "Ulysses S. Grant", "http://en.wikipedia.org/wiki/Ulysses_S._Grant", "4/03/1869", "4/03/1877", "Republican", "UlyssesSGrant.gif", "thmb_UlyssesSGrant.gif", "Ohio"],
        ["19", "Rutherford B. Hayes", "http://en.wikipedia.org/wiki/Rutherford_B._Hayes", "4/03/1877", "4/03/1881", "Republican", "RutherfordBHayes.png", "thmb_RutherfordBHayes.png", "Ohio"],
        ["20", "James A. Garfield", "http://en.wikipedia.org/wiki/James_A._Garfield", "4/03/1881", "19/09/1881", "Republican", "James_Garfield.jpg", "thmb_James_Garfield.jpg", "Ohio"],
        ["21", "Chester A. Arthur", "http://en.wikipedia.org/wiki/Chester_A._Arthur", "19/09/1881", "4/03/1885", "Republican", "ChesterAArthur.gif", "thmb_ChesterAArthur.gif", "New York"],
        ["22", "Grover Cleveland", "http://en.wikipedia.org/wiki/Grover_Cleveland", "4/03/1885", "4/03/1889", "Democratic", "Grover_Cleveland_2.jpg", "thmb_Grover_Cleveland_2.jpg", "New York"],
        ["23", "Benjamin Harrison", "http://en.wikipedia.org/wiki/Benjamin_Harrison", "4/03/1889", "4/03/1893", "Republican", "BenjaminHarrison.gif", "thmb_BenjaminHarrison.gif", "Indiana"],
        ["24", "Grover Cleveland (2nd term)", "http://en.wikipedia.org/wiki/Grover_Cleveland", "4/03/1893", "4/03/1897", "Democratic", "Grover_Cleveland.jpg", "thmb_Grover_Cleveland.jpg", "New York"],
        ["25", "William McKinley", "http://en.wikipedia.org/wiki/William_McKinley", "4/03/1897", "14/9/1901", "Republican", "WilliamMcKinley.gif", "thmb_WilliamMcKinley.gif", "Ohio"],
        ["26", "Theodore Roosevelt", "http://en.wikipedia.org/wiki/Theodore_Roosevelt", "14/9/1901", "4/3/1909", "Republican", "TheodoreRoosevelt.jpg", "thmb_TheodoreRoosevelt.jpg", "New York"],
        ["27", "William Howard Taft", "http://en.wikipedia.org/wiki/William_Howard_Taft", "4/3/1909", "4/03/1913", "Republican", "WilliamHowardTaft.jpg", "thmb_WilliamHowardTaft.jpg", "Ohio"],
        ["28", "Woodrow Wilson", "http://en.wikipedia.org/wiki/Woodrow_Wilson", "4/03/1913", "4/03/1921", "Democratic", "WoodrowWilson.gif", "thmb_WoodrowWilson.gif", "New Jersey"],
        ["29", "Warren G. Harding", "http://en.wikipedia.org/wiki/Warren_G._Harding", "4/03/1921", "2/8/1923", "Republican", "WarrenGHarding.gif", "thmb_WarrenGHarding.gif", "Ohio"],
        ["30", "Calvin Coolidge", "http://en.wikipedia.org/wiki/Calvin_Coolidge", "2/8/1923", "4/03/1929", "Republican", "CoolidgeWHPortrait.gif", "thmb_CoolidgeWHPortrait.gif", "Massachusetts"],
        ["31", "Herbert Hoover", "http://en.wikipedia.org/wiki/Herbert_Hoover", "4/03/1929", "4/03/1933", "Republican", "HerbertHover.gif", "thmb_HerbertHover.gif", "Iowa"],
        ["32", "Franklin D. Roosevelt", "http://en.wikipedia.org/wiki/Franklin_D._Roosevelt", "4/03/1933", "12/4/1945", "Democratic", "FranklinDRoosevelt.gif", "thmb_FranklinDRoosevelt.gif", "New York"],
        ["33", "Harry S. Truman", "http://en.wikipedia.org/wiki/Harry_S._Truman", "12/4/1945", "20/01/1953", "Democratic", "HarryTruman.jpg", "thmb_HarryTruman.jpg", "Missouri"],
        ["34", "Dwight D. Eisenhower", "http://en.wikipedia.org/wiki/Dwight_D._Eisenhower", "20/01/1953", "20/01/1961", "Republican", "Dwight_D_Eisenhower.jpg", "thmb_Dwight_D_Eisenhower.jpg", "Texas"],
        ["35", "John F. Kennedy", "http://en.wikipedia.org/wiki/John_F._Kennedy", "20/01/1961", "22/11/1963", "Democratic", "John_F_Kennedy.jpg", "thmb_John_F_Kennedy.jpg", "Massachusetts"],
        ["36", "Lyndon B. Johnson", "http://en.wikipedia.org/wiki/Lyndon_B._Johnson", "22/11/1963", "20/1/1969", "Democratic", "Lyndon_B_Johnson.gif", "thmb_Lyndon_B_Johnson.gif", "Texas"],
        ["37", "Richard Nixon", "http://en.wikipedia.org/wiki/Richard_Nixon", "20/1/1969", "9/8/1974", "Republican", "RichardNixon.gif", "thmb_RichardNixon.gif", "California"],
        ["38", "Gerald Ford", "http://en.wikipedia.org/wiki/Gerald_Ford", "9/8/1974", "20/01/1977", "Republican", "Gerald_R_Ford.jpg", "thmb_Gerald_R_Ford.jpg", "Michigan"],
        ["39", "Jimmy Carter", "http://en.wikipedia.org/wiki/Jimmy_Carter", "20/01/1977", "20/01/1981", "Democratic", "James_E_Carter.gif", "thmb_James_E_Carter.gif", "Georgia"],
        ["40", "Ronald Reagan", "http://en.wikipedia.org/wiki/Ronald_Reagan", "20/01/1981", "20/01/1989", "Republican", "ReaganWH.jpg", "thmb_ReaganWH.jpg", "California"],
        ["41", "George H. W. Bush", "http://en.wikipedia.org/wiki/George_H._W._Bush", "20/01/1989", "20/01/1993", "Republican", "George_H_W_Bush.gif", "thmb_George_H_W_Bush.gif", "Texas"],
        ["42", "Bill Clinton", "http://en.wikipedia.org/wiki/Bill_Clinton", "20/01/1993", "20/01/2001", "Democratic", "Clinton.jpg", "thmb_Clinton.jpg", "Arkansas"],
        ["43", "George W. Bush", "http://en.wikipedia.org/wiki/George_W._Bush", "20/01/2001", "20/01/2009", "Republican", "George_W_Bush.jpg", "thmb_George_W_Bush.jpg", "Texas"],
        ["44", "Barack Obama", "http://en.wikipedia.org/wiki/Barack_Obama", "20/01/2009", "20/01/2017", "Democratic", "Barack_Obama.jpg", "thmb_Barack_Obama.jpg", "Illinois"],
        ["45", "Donald Trump", "http://en.wikipedia.org/wiki/Donald_Trump", "20/01/2017", "Incumbent", "Democratic", "Donald_Trump.jpg", "thmb_Donald_Trump.jpg", "New York"]
    ]

}

#if os(Linux)
    extension SwiftyTextTableTests {
        static var allTests: [(String, (SwiftyTextTableTests) -> () throws -> Void)] {
            return [
                ("testRenderDefault", testRenderDefault),
                ("testRenderDefaultWithHeader", testRenderDefaultWithHeader),
                ("testRenderCustom", testRenderCustom),
                ("testRenderCustomWithHeader", testRenderCustomWithHeader),
                ("testStripping", testStripping),
                ("testTextTableRepresentables", testTextTableRepresentables),
                ("testTextTableRepresentablesWithHeader", testTextTableRepresentablesWithHeader),
                ("testColumnHeaderUpdate", testColumnHeaderUpdate),
                ("testAddRows", testAddRows),
                ("testClearRows", testClearRows),
                ("testAddRowPerformance", testAddRowPerformance),
                ("testAddRowsPerformance", testAddRowsPerformance),
            ]
        }
    }
#endif
