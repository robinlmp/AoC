import XCTest
@testable import AdventOfCode

final class Day7Tests: XCTestCase, SolutionTest {
    typealias SUT = Day7
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 3749)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 11387)
    }
}

extension Day7Tests {
    func testCheckCalibrationPart1() throws {
        XCTAssertEqual(try sut.checkEquation(try sut.rows[0], operators: sut.operatorsPart1), 190)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[1], operators: sut.operatorsPart1), 3267)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[2], operators: sut.operatorsPart1), 0)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[3], operators: sut.operatorsPart1), 0)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[4], operators: sut.operatorsPart1), 0)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[5], operators: sut.operatorsPart1), 0)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[6], operators: sut.operatorsPart1), 0)
        XCTAssertEqual(try sut.checkEquation(try sut.rows[8], operators: sut.operatorsPart1), 292)
    }
}



//extension Day7Tests {
//    func testOperatorOptions() throws {
//        let options = Day7Tests.SUT.calculateOperatorCombinations(max: 3)
//        dump(options)
//    }
//    
//    func testCalculateRoeForOperatorList() throws {
//        let row = [9, 7, 18, 13]
//        let options1: [SUT.Operator] = [.add, .add, .add, .add]
//        let result1 = try sut.calculateRowForOperatorList(options1, row: row)
//        XCTAssertEqual(result1, 47)
//        
//        let options2: [SUT.Operator] = [.multiply, .add, .add, .add]
//        let result2 = try sut.calculateRowForOperatorList(options2, row: row)
//        XCTAssertEqual(result2, 94)
//        
//        let options3: [SUT.Operator] = [.multiply, .multiply, .multiply, .multiply, .multiply]
//        let result3 = try sut.calculateRowForOperatorList(options3, row: row)
//        XCTAssertEqual(result3, 14_742)
//    }
//    
//    func testCalibrationValue() throws {
//        try sut.calcalateCalibrationValue()
//    }
//}
