struct Day2: Solution {
    static let day = 2
    
    let input: [[Int]]
    
    init(input: String) {
        self.input = input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty}
            .map {
                $0.components(separatedBy: .whitespaces)
                    .compactMap(Int.init)
            }
    }

    func calculatePartOne() -> Int {
        input.filter {
            isSafePart1(list: $0) == true
        }.count
    }
    
    func calculatePartTwo() -> Int {
        0
    }

    func isSafePart1(list: [Int]) -> Bool {
        let signs: [Int] = calculateSigns(
            differences:
                calculateDifferences(list: list)
        )
        
        let set = Set(signs)
        
        if set.count == 1 {
            return true
        }
        
        return false
    }
    
    func calculateDifferences(list: [Int]) -> [Int] {
        return list.enumerated().compactMap {
            if $0 > 0 {
                $1 - list[$0 - 1]
            } else { nil }
        }
    }
    
    func calculateSigns(differences: [Int]) -> [Int] {
        return differences.map {
            if abs($0) > 3 {
                $0
            } else {
                $0.signum()
            }
        }
    }
}
