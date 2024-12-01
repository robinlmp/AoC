import XCTest
@testable import AdventOfCode

final class Day1Tests: XCTestCase, SolutionTest {
    typealias SUT = Day1
    
    func testPartOne() throws {
        print(try sut.pairs)
        try XCTAssertEqual(sut.calculatePartOne(), 11)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 31)
    }
}

extension Day1Tests {
    func testDifference() throws {
        XCTAssertEqual(try sut.pairs.differenceAt(index: 0), 2)
        XCTAssertEqual(try sut.pairs.differenceAt(index: 1), 1)
        XCTAssertEqual(try sut.pairs.differenceAt(index: 2), 0)
        XCTAssertEqual(try sut.pairs.differenceAt(index: 5), 5)
        
        let localSut = SUT.Pairs(
            pairs: [[5, 1], [7, 7], [3, 3]]
        )
        XCTAssertEqual(localSut.differenceAt(index: 0), 2)
        XCTAssertEqual(localSut.differenceAt(index: 1), 2)
        XCTAssertEqual(localSut.differenceAt(index: 2), 0)
    }
    
    func testNumberMatchMultiply() throws {
        XCTAssertEqual(try sut.pairs.numberMatchMultiply(number: 3), 9)
    }
    
    func testPart2Total() throws {
        XCTAssertEqual(try sut.pairs.part2Total(), 31)
    }
}
