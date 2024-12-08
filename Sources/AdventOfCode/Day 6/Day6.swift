import Collections

struct Day6: Solution {
    static let day = 6
    
    let grid: [[Position]]
    let flatGrid: [Position]
    let gridBoundsX: Int
    let gridBoundsY: Int
    let startPosition: Position
    
    init(input: String) {
        let temp = input
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map {
                $0
            }
        
        let result = temp.map {
            $0
                .compactMap(Character.init)
        }
        
        grid = result.enumerated().map { indexY, row in
            row.enumerated().map { indexX, item in
                if let direction = Direction(rawValue: item) {
                    return Position(x: indexX,
                                    y: indexY,
                                    direction: direction,
                                    visited: true,
                                    obstacle: false
                    )
                } else if item == "#" {
                    return Position(x: indexX,
                             y: indexY,
                             direction: nil,
                             visited: false,
                             obstacle: true
                    )
                } else {
                    return Position(x: indexX,
                             y: indexY,
                             direction: nil,
                             visited: false,
                             obstacle: false
                    )
                }
            }
        }
        
        let flat = grid.flatMap(\.self)
        
        self.startPosition = flat.first(where: {
            $0.direction != nil
        })!
        
        self.flatGrid = flat
        
        gridBoundsX = flatGrid
            .map(\.x)
            .max() ?? 0
        
        gridBoundsY = flatGrid
            .map(\.y)
            .max() ?? 0
        
    }
    
    func calculatePartOne() -> Int {
        do {
            return try guardsJourney(grid: flatGrid)
        } catch {
            print(error)
        }
        return 0
    }
    
    func calculatePartTwo() -> Int {
        checkLocations(grid: grid)
    }
}

extension Day6 {
    func checkLocations(grid: [[Position]]) -> Int {
        var loopsForObstacle: [Position] = []
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                let position = grid[y][x]
                if position.obstacle {
                    continue
                } else {
                    var tempGrid = grid
                    tempGrid[y][x] = position.modify(obstacle: true)

                    // modified grid with 1 changed obstacle
                    if checkLooping(grid: tempGrid) {
                        loopsForObstacle.append(position)
                    }
                }
            }
        }
        return loopsForObstacle.count
    }
    
    func checkLooping(grid: [[Position]]) -> Bool {
        var grid = grid
        var currentPosition = startPosition
        
        var obstacleLocations: [Position] = []
        
        while currentPosition.x < gridBoundsX && currentPosition.y < gridBoundsY && currentPosition.x >= 0 && currentPosition.y >= 0 {
            
            
            
            if let loop = checkObstacleLoop(obstacleLocations) {
                return loop
            }
            
            guard let direction = currentPosition.direction else {
                preconditionFailure("current position should have a direction")
            }
            
            currentPosition = currentPosition.modify(visited: true)
            currentPosition = currentPosition.modify(direction: nil)
            grid[currentPosition.y][currentPosition.x] = currentPosition
            
            let nextX = currentPosition.x + direction.move.0
            let nextY = currentPosition.y + direction.move.1
            
            if nextX < 0 || nextY < 0 || nextX > gridBoundsX || nextY > gridBoundsY {
                return false
            }
            
            if grid[nextY][nextX].obstacle {
                obstacleLocations.append(grid[nextY][nextX])
                currentPosition = currentPosition.modify(direction: direction.next)
                continue
            }
            
            currentPosition = grid[nextY][nextX].modify(direction: direction).modify(visited: true)
        }
        return false
    }
    
    func checkObstacleLoop(_ obstacles: [Position]) -> Bool? {
        if obstacles.count > 8 {
            let obstaclesSet = Set(obstacles)
            
            if obstaclesSet.count < obstacles.count - 20 {
                return true
            }
            
            let split = obstacles.suffix(8)
            let set = Set(split)
            
            if set.count == 4 {
                return true
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func guardsJourney(grid: [Position]) throws -> Int {
        var isMoving = true
        var tempGrid = grid
        
        while isMoving {
            guard let guardPosition = currentPosition(grid: tempGrid) else {
                throw GridError.currentPosition
            }
            
            if guardPosition.x > gridBoundsX ||
                guardPosition.x < 0 ||
                guardPosition.y > gridBoundsY ||
                guardPosition.y < 0 {
                
                isMoving = false
                return tempGrid.filter(\.visited).count
            } else {
                if let newGrid = try movePosition(grid: tempGrid) {
                    tempGrid = newGrid
                } else {
                    return tempGrid.filter(\.visited).count
                }
            }
        }
    }
    
    func movePosition(grid: [Position]) throws -> [Position]? {
        var tempGrid = grid
        
        guard let currentPosition = currentPosition(grid: tempGrid) else {
            return nil
        }
        
        guard let currentIndex = tempGrid.firstIndex(of: currentPosition) else {
            return nil
        }
        
        guard let nextIndex = tempGrid.firstIndex(where: {
            $0.x == currentPosition.x + (currentPosition.direction?.move.0 ?? 0) &&
            $0.y == currentPosition.y + (currentPosition.direction?.move.1 ?? 0)
        }) else {
            return nil
        }
        
        let nextPosition = tempGrid[nextIndex]

            if nextPosition.obstacle == true {
                tempGrid[currentIndex] =
                Position(x: currentPosition.x,
                         y: currentPosition.y,
                         direction: currentPosition.direction?.next,
                         visited: true,
                         obstacle: false)
            } else {
                tempGrid[nextIndex] =
                Position(x: nextPosition.x,
                         y: nextPosition.y,
                         direction: currentPosition.direction,
                         visited: true,
                         obstacle: false)
                tempGrid[currentIndex] =
                Position(x: currentPosition.x,
                         y: currentPosition.y,
                         direction: nil,
                         visited: true,
                         obstacle: false)
            }
        
        return tempGrid
    }
    
    func currentPosition(grid: [Position]) -> Position? {
        if let start = grid.first(where: {
            return $0.direction != nil
        }) {
            return start
        } else {
            return nil
        }
    }
    
    enum GridError: Error {
        case currentPosition
        case outOfBounds
    }
    
    enum Direction: Character, CaseIterable {
        case up = "^"
        case down = "v"
        case left = "<"
        case right = ">"
        
        var move: (Int, Int) {
            switch self {
            case .up: return (0,-1)
            case .down: return (0,1)
            case .left: return (-1,0)
            case .right: return (1,0)
            }
        }
        
        var next: Direction {
            switch self {
            case .up: return .right
            case .down: return .left
            case .left: return .up
            case .right: return .down
            }
        }
    }
    
    struct Position: Hashable {
        let x: Int
        let y: Int
        let direction: Direction?
        let visited: Bool
        let obstacle: Bool
        
        func modify(direction: Direction?) -> Self {
            .init(x: x,
                  y: y,
                  direction: direction,
                  visited: visited,
                  obstacle: obstacle)
        }
        
        func nextDirection() -> Self {
            .init(x: x,
                  y: y,
                  direction: direction?.next,
                  visited: true,
                  obstacle: obstacle)
        }
        
        func modify(visited: Bool) -> Self {
            .init(x: x,
                  y: y,
                  direction: direction,
                  visited: visited,
                  obstacle: obstacle)
        }
        
        func modify(obstacle: Bool) -> Self {
            .init(x: x,
                  y: y,
                  direction: direction,
                  visited: false,
                  obstacle: obstacle)
        }
    }
}
