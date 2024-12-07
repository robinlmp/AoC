import XCTest
@testable import AdventOfCode

final class Day6Tests: XCTestCase, SolutionTest {
    typealias SUT = Day6
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 41)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 6)
    }
}

extension Day6Tests {
    func testObstacleLoop() throws {
        let tempGrid = (0...9).map {
            return SUT.Position(x: 0, y: $0, direction: nil, visited: false, obstacle: true)
        }
        XCTAssertEqual(try sut.checkObstacleLoop(tempGrid), nil)
        
        let loop = tempGrid + tempGrid.suffix(4)
        XCTAssertEqual(try sut.checkObstacleLoop(loop), true)
    }
    
    func testStartPosition() throws {
        XCTAssertEqual(try sut.currentPosition(grid: sut.flatGrid),
                       SUT.Position(
                        x: 4,
                        y: 6,
                        direction: .up,
                        visited: true,
                        obstacle: false
                       )
        )
    }
    
    func testGridBounds() throws {
        XCTAssertEqual(try sut.gridBoundsX, 9)
        XCTAssertEqual(try sut.gridBoundsY, 9)
    }
}
