import XCTest
@testable import AdventOfCode

final class Day3Tests: XCTestCase, SolutionTest {
    typealias SUT = Day3
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 161)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 48)
    }
    
    func testRegex() throws {
        let string = "12mul(12,134)890mul(0,742)fsfgrw33"
        
        let matches: [String] = string.match(try sut.regex).flatMap { $0 }
        
        XCTAssertEqual(matches.count, 2)
        XCTAssertEqual(matches.first, "mul(12,134)")
        XCTAssertEqual(matches.last, "mul(0,742)")
    }
    
    func testRanges() throws {
        let string = "12mul(12,134)8do()90mul(0,742)fsdon't()fgrw33"
        
        guard let mulRegex = try sut.mulRegex,
              let doRegex = try sut.doRegex,
              let dontRegex = try sut.dontRegex
        else {
            print("failed regex init")
            return
        }
        
        let ranges = string.ranges(of: mulRegex)
        let doRanges = string.ranges(of: doRegex)
        let dontRanges = string.ranges(of: dontRegex)
        
        if let upperBound = ranges.first?.upperBound {
            print("upper bound: ",
                  string.distanceFromStart(to: upperBound)
            )
        }
    }
    
    func testArrayCreation() throws {
        let operators = try sut.extractOperators(input: try sut.input)
        
        dump(operators)
    }
}
