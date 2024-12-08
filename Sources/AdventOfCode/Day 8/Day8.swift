struct Day8: Solution {
    static let day = 8
    
    var grid: [[Location]]
    let transmitterTypes: Set<String>
    let boundsMax: (Int, Int)
    
    init(input: String) {
        self.grid = input
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .enumerated()
            .map { (indexY, row) in
                row
                    .enumerated()
                    .map { (indexX, item) in
                        return Location(x: indexX, y: indexY, transmitter: String(item))
                    }
            }
        
        self.transmitterTypes = Set(grid.flatMap {
            $0.map(\.transmitter)
                .filter { $0 != "."}
        })
        
        if let last = grid.last?.last {
            self.boundsMax = (last.x, last.y)
        } else {
            preconditionFailure("no last item in grid")
        }
    }
    
    func calculatePartOne() -> Int {
        setAntiNodes().count
    }
    
    func calculatePartTwo() -> Int {
        setAntiNodes(partTwo: true).count
    }
}

extension Day8 {
    func setAntiNodes(partTwo: Bool = false) -> Set<Location> {
        let transmitterLocations = transmitterTypes
            .map {
                self.transmitterLocations(for: $0)
            }
        
        let result = transmitterLocations
            .flatMap { transmittersOfType in
                transmittersOfType
                    .compactMap { transmitterA in
                        transmittersOfType
                            .filter { $0 != transmitterA }
                            .map { transmitterB in
                                var tempResult: Set<Location> = []

                                let distance = transmitterA.distanceTo(transmitterB)
                                let locations = transmitterA.antiNodeLocationsFor(transmitterB)

                                var forward = (transmitterA.x, transmitterA.y) + distance
                                var backward = (transmitterA.x, transmitterA.y) - distance
                                
                                var isInBoundsA = isValidGridPosition(gridBounds: boundsMax, location: locations.0)
                                var isInBoundsB = isValidGridPosition(gridBounds: boundsMax, location: locations.1)
                                
                                let nodeA = transmitterA.antiNodeOn()
                                if partTwo {
                                    tempResult.insert(nodeA)
                                    
                                    isInBoundsA = isValidGridPosition(gridBounds: boundsMax, location: forward)
                                    isInBoundsB = isValidGridPosition(gridBounds: boundsMax, location: backward)
                                }
                                
                                while isInBoundsA && partTwo {
                                    let existing = grid[forward.1][forward.0]
                                    tempResult.insert(existing.antiNodeOn())
                                    forward = forward + distance
                                    isInBoundsA = isValidGridPosition(gridBounds: boundsMax, location: forward)
                                }
                                
                                while isInBoundsB && partTwo {
                                    let existing = grid[backward.1][backward.0]
                                    tempResult.insert(existing.antiNodeOn())
                                    backward = backward - distance
                                    isInBoundsB = isValidGridPosition(gridBounds: boundsMax, location: backward)
                                }
                                
                                if isInBoundsA && !partTwo {
                                    let existingA = grid[locations.0.1][locations.0.0]
                                    let new = antiNode(coords: locations.0, transmitter: existingA.transmitter, isAntinode: true, gridBounds: boundsMax)
                                    tempResult.insert(new)
                                }
                                
                                if isInBoundsB && !partTwo {
                                    let existingB = grid[locations.1.1][locations.1.0]
                                    let new = antiNode(coords: locations.1, transmitter: existingB.transmitter, isAntinode: true, gridBounds: boundsMax)
                                    tempResult.insert(new)
                                }
                            return tempResult
                        }
                    }
            }
       return Set(result
        .flatMap { $0.flatMap { Array($0) } }
       )
    }
    
    func antiNode(coords: (Int, Int), transmitter: String, isAntinode: Bool, gridBounds: (Int, Int)) -> Location {
        return .init(x: coords.0, y: coords.1, transmitter: transmitter, isAntinode: true)
    }
    
    func isValidGridPosition(gridBounds: (Int, Int), location: (Int, Int)) -> Bool {
        if location.0 >= 0 &&
            location.0 <= gridBounds.0 &&
            location.1 >= 0 &&
            location.1 <= gridBounds.1
        {
            return true
        }
        return false
    }
    
    func transmitterLocations(for string: String) -> [Location] {
        return grid
            .flatMap {
                $0.filter { item in
                    item.transmitter == string
                }
            }
    }
    
    struct Location: Hashable {
        let x: Int
        let y: Int
        let transmitter: String
        let isAntinode: Bool
        
        init(x: Int, y: Int, transmitter: String, isAntinode: Bool = false) {
            self.x = x
            self.y = y
            self.transmitter = transmitter
            self.isAntinode = isAntinode
        }
        
        func distanceTo(_ other: Location) -> (Int, Int) {
            return (other.x - self.x, other.y - self.y)
        }

        func antiNodeOn() -> Location {
            Location(x: self.x,
                     y: self.y,
                     transmitter: self.transmitter,
                     isAntinode: true)
        }
        
        func antiNodeLocationsFor(_ other: Location) -> ((Int, Int), (Int, Int)) {
            let distance = self.distanceTo(other)
            let first = (self.x - distance.0, self.y - distance.1)
            let second = (other.x + distance.0, other.y + distance.1)
            return (first, second)
        }
    }
}

infix operator + : AdditionPrecedence

func + (lhs: (Int, Int), rhs: (Int, Int)) -> (Int, Int) {
    (lhs.0 + rhs.0, lhs.1 + rhs.1)
}

infix operator - : AdditionPrecedence

func - (lhs: (Int, Int), rhs: (Int, Int)) -> (Int, Int) {
    (lhs.0 - rhs.0, lhs.1 - rhs.1)
}
