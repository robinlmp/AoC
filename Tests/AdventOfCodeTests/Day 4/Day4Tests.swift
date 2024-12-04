import XCTest
@testable import AdventOfCode

final class Day4Tests: XCTestCase, SolutionTest {
    typealias SUT = Day4
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 18)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 9)
    }
}
