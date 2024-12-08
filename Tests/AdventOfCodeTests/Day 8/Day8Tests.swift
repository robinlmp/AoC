import XCTest
@testable import AdventOfCode

final class Day8Tests: XCTestCase, SolutionTest {
    typealias SUT = Day8
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 14)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 34)
    }
}

extension Day8Tests {
    func testTransmitterLocationsA() throws {
        try XCTAssertEqual(sut.transmitterLocations(for: "A").count, 3)
        try XCTAssertEqual(sut.transmitterLocations(for: "0").count, 4)
    }
    
    func testTransmitterTypes() throws {
        try XCTAssertEqual(sut.transmitterTypes, ["A", "0"])
    }
    
    func testAntiNodeLocationsFor() throws {
        let transmitters = try sut.transmitterLocations(for: "A")
        
        let locations = transmitters.first!.antiNodeLocationsFor(transmitters.last!)
        
//        ((3, 1), (12, 13))
        XCTAssertEqual(locations.0.0, 3)
        XCTAssertEqual(locations.0.1, 1)
        XCTAssertEqual(locations.1.0, 12)
        XCTAssertEqual(locations.1.1, 13)
    }
}
