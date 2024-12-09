import XCTest
@testable import AdventOfCode

final class Day9Tests: XCTestCase, SolutionTest {
    typealias SUT = Day9
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 1928)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 0)
    }
}

extension Day9Tests {
    func testMoveBlocks() throws {
        try XCTAssertEqual(sut.moveBlocks(sut.blocks).customDescription(), "0099811188827773336446555566..............")
    }
}
