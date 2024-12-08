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
        0
    }
}

extension Day8 {
    func setAntiNodes() -> Set<Location> {
        let transmitterLocations = transmitterTypes
            .map {
                self.transmitterLocations(for: $0)
            }
        
        let result = transmitterLocations
            .flatMap { transmittersOfType in
                transmittersOfType
                    .compactMap { transmitterA in
                        transmittersOfType.map { transmitterB in
                            var tempResult: Set<Location> = []
                            
                            if transmitterA != transmitterB {
//                                let distance = transmitterA.distanceTo(transmitterB)
                                let locations = transmitterA.antiNodeLocationsFor(transmitterB)
                                
                                if isValidGridPosition(gridBounds: boundsMax, location: locations.0) {
                                    let existing = grid[locations.0.1][locations.0.0]
                                    
                                    let new = antiNode(coords: locations.0, transmitter: existing.transmitter, isAntinode: true, gridBounds: boundsMax)
                                    tempResult.insert(new)
                                }
                                
                                if isValidGridPosition(gridBounds: boundsMax, location: locations.1) {
                                    let existing = grid[locations.1.1][locations.1.0]
                                    
                                    let new = antiNode(coords: locations.1, transmitter: existing.transmitter, isAntinode: true, gridBounds: boundsMax)
                                    tempResult.insert(new)
                                }
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
            print("location returned true", location)
            return true
        }
        print("griddbounds :", gridBounds)
        print("location :", location)
        print("location x: ", location.0)
        print("location y: ", location.1)
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
        
        func antiNodeLocationsFor(_ other: Location) -> ((Int, Int), (Int, Int)) {
            let distance = self.distanceTo(other)
            let first = (self.x - distance.0, self.y - distance.1)
            let second = (other.x + distance.0, other.y + distance.1)
            return (first, second)
        }
    }
}
