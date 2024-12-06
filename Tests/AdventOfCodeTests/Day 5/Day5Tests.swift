import XCTest
@testable import AdventOfCode

final class Day5Tests: XCTestCase, SolutionTest {
    typealias SUT = Day5
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 143)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 123)
    }
}

extension Day5Tests {
    func testValidatePart2() throws {
        let result = try sut.validateUpdatePart2(update: [75,97,47,61,53])
        XCTAssertEqual(result, 47)
        
        let result2 = try sut.validateUpdatePart2(update: [61,13,29])
        XCTAssertEqual(result2, 29)
        
        let result3 = try sut.validateUpdatePart2(update: [97,13,75,29,47])
        XCTAssertEqual(result3, 47)
    }
    
    func testValidateUpdate() throws {
        let result = try sut.validateUpdatePart1(update: [75,47,61,53,29])
        XCTAssertEqual(result, 61)
        
        let result2 = try sut.validateUpdatePart1(update: [61,13,29])
        XCTAssertEqual(result2, 0)
    }
    
    func testGetRules() throws {
        let rules61 = try sut.getRules(number: 61, rules: sut.rules)
        XCTAssertEqual(rules61.count, 3)
        let rules13 = try sut.getRules(number: 13, rules: sut.rules)
        XCTAssertEqual(rules13.count, 0)
        let rules97 = try sut.getRules(number: 97, rules: sut.rules)
        XCTAssertEqual(rules97.count, 6)
    }
}
