import XCTest
@testable import AdventOfCode

final class Day2Tests: XCTestCase, SolutionTest {
    typealias SUT = Day2
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 2)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 4)
    }
}

extension Day2Tests {
    func testIsSafePart1() throws {
        XCTAssertTrue(try sut.isSafePart1(list: [1,2,3,4,5]))
        XCTAssertTrue(try sut.isSafePart1(list: [5,4,3,2,1]))
        
        XCTAssertFalse(try sut.isSafePart1(list: [5,4,8,2,1]))
        XCTAssertFalse(try sut.isSafePart1(list: [1,2,4,3,1]))
        
        XCTAssertFalse(try sut.isSafePart1(list: [1,2,7,8,9]))
        XCTAssertFalse(try sut.isSafePart1(list: [1,2,7,8,9].reversed()))
        
        XCTAssertTrue(try sut.isSafePart1(list: [1,2,5,6,8]))
        XCTAssertFalse(try sut.isSafePart1(list: [1,2,5,5,4]))
    }
    
    func testIsSafePart2() throws {
        XCTAssertFalse(try sut.isSafePart2(list: [1,3,5,10,9]))
        
        XCTAssertTrue(try sut.isSafePart2(list: [7,6,4,2,1]))
        
        XCTAssertFalse(try sut.isSafePart2(list: [1,2,7,8,9]))
        XCTAssertFalse(try sut.isSafePart2(list: [9,7,6,2,1]))
        
        XCTAssertTrue(try sut.isSafePart2(list: [1,3,2,4,5]))
        XCTAssertTrue(try sut.isSafePart2(list: [8,6,4,4,1]))
        XCTAssertTrue(try sut.isSafePart2(list: [1,3,6,7,9]))
        
        XCTAssertFalse(try sut.isSafePart2(list: [66, 68, 69, 71, 72, 71, 72, 69]))
    }
}
