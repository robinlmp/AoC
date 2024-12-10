import XCTest
@testable import AdventOfCode

final class Day9Tests: XCTestCase, SolutionTest {
    typealias SUT = Day9
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 1928)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 2858)
    }
}

extension Day9Tests {
    func testMoveBlocks() throws {
        try XCTAssertEqual(sut.moveBlocks(sut.blocks).customDescription(), "0099811188827773336446555566..............")
    }
    
    func testMoveFiles() throws {
        try XCTAssertEqual(sut.moveFiles(sut.blocks).customDescription(), "00992111777.44.333....5555.6666.....8888..")
    }
}
