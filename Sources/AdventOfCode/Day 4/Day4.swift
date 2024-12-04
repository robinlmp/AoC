struct Day4: Solution {
    static let day = 4
    
    let letters: [LetterCoordinate]
    
    init(input: String) {
        let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let result = lines.map {
            $0.map(Character.init)
        }
        
        let letters = result.enumerated().flatMap { y in
            y.element.enumerated().map { x in
                return LetterCoordinate(letter: x.element, x: x.offset, y: y.offset)
            }
        }
        self.letters = letters
    }

    func calculatePartOne() -> Int {
        findXs(input: letters)
    }
    
    func calculatePartTwo() -> Int {
        findAs(input: letters)
    }
}

extension Day4 {
    enum Direction: CaseIterable {
        case up, down, left, right, upLeft, upRight, downLeft, downRight
        
        var offset: (Int, Int) {
            switch self {
            case .up: return (0, -1)
            case .down: return (0, 1)
            case .left: return (-1, 0)
            case .right: return (1, 0)
            case .upLeft: return (-1, -1)
            case .upRight: return (1, -1)
            case .downLeft: return (-1, 1)
            case .downRight: return (1, 1)
            }
        }
        
        static let bottomSide: [Self] = [.downLeft, .downRight]
        static let topSide: [Self] = [.upLeft, .upRight]
        static let leftSide: [Self] = [.upLeft, .downLeft]
        static let rightSide: [Self] = [.upRight, .downRight]
        
        static let allSides: [[Self]] = [bottomSide, topSide, leftSide, rightSide]
    }

    
    func findAs(input: [LetterCoordinate]) -> Int {
        let result = letters.compactMap {
            if $0.letter == "A" {
                return findX_MasForA(letterA: $0)
            } else { return nil }
        }.reduce(0, +)
        
        return result
    }
    
    func findX_MasForA(letterA: LetterCoordinate) -> Int {
        let pairS = findAdjacentPairs(letter: letterA, searching: "S")
        let pairM = findAdjacentPairs(letter: letterA, searching: "M")
        
        return pairS && pairM ? 1 : 0
    }
    
    func findAdjacentPairs(letter: LetterCoordinate, searching: Character) -> Bool {
        let result = Direction
            .allSides
            .map { side in
                let sideResult = side.compactMap { direction in
                    findAdjacentLetters(letter: letter,
                                        direction: direction,
                                        adjacentLetter: searching)
                }
                if sideResult.count == 2 {
                    return true
                } else {
                    return false
                }
            }
        return result.contains(true)
    }
    
    func findXs(input: [LetterCoordinate]) -> Int {
        let result = letters.compactMap {
            if $0.letter == "X" {
                return findXmasForX(x: $0.x, y: $0.y)
            } else { return nil }
        }.reduce(0, +)
        
        return result
    }
    
    func findXmasForX(x: Int, y: Int) -> Int {
        return Direction.allCases.map { direction in
            let letter = letters.filter {
                $0.x == x + direction.offset.0 &&
                $0.y == y + direction.offset.1
            }.first
            
            if letter?.letter == "M",
                let letterM = letter {
                if let letterA = findAdjacentLetters(letter: letterM, direction: direction, adjacentLetter: "A") {
                    if let letterS = findAdjacentLetters(letter: letterA, direction: direction, adjacentLetter: "S") {
                        return 1
                    }
                }
            }
            return 0
        }.reduce(0, +)
    }
    
    func findAdjacentLetters(
        letter: LetterCoordinate,
        direction: Direction,
        adjacentLetter: Character
    ) -> LetterCoordinate? {
        letters.filter {
            if $0.x == letter.x + direction.offset.0 &&
                $0.y == letter.y + direction.offset.1 &&
                $0.letter == adjacentLetter {
                return true
            } else { return false }
        }.first
    }
    
    struct LetterCoordinate {
        let letter: Character
        let x: Int
        let y: Int
    }
}
