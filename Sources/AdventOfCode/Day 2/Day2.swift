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
        input.filter {
            isSafePart2(list: $0) == true
        }.count
    }
    
    func isSafePart2(list: [Int]) -> Bool {
        let dif = Day2.calculateDifferences(list: list)
        let signs: [Int] = Day2.calculateSigns(differences: dif)
        let set = Set(signs)
        
        let growing = dif.filter { $0 > 0 }
        let shrinking = dif.filter { $0 < 0 }
        let same = dif.filter { $0 == 0 }
        
        let isGrowingList = growing.count > shrinking.count ? true : false
        
        let nonComformingItems = isGrowingList ?
        shrinking.count + same.count :
        growing.count + same.count
        
        if nonComformingItems > 1 {
            return false
        }
        
        if set.count == 1 {
            return true
        } else if set.count == 2 {
            let indexOfProblem = zip(dif.indices, dif)
                .filter {
                if isGrowingList {
                    if $0.1 < 1 || $0.1 > 3 {
                        return true
                    } else {
                        return false
                    }
                } else {
                    if $0.1 > -1 || $0.1 < -3 {
                        return true
                    } else {
                        return false
                    }
                }
            }.first
   
            guard let indexOfProblem else { return false }
            
            if indexOfProblem.0 == 0 || indexOfProblem.0 == list.count - 1 {
                return true
            } else {
                if abs(list[indexOfProblem.0 - 1] - list[indexOfProblem.0 + 1]) < 4 {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }

    func isSafePart1(list: [Int]) -> Bool {
        let signs: [Int] = Day2.calculateSigns(
            differences:
                Day2.calculateDifferences(list: list)
        )
        
        let set = Set(signs)
        
        if set.count == 1 {
            return true
        }
        
        return false
    }
    
    static func calculateDifferences(list: [Int]) -> [Int] {
        return list.enumerated().compactMap {
            if $0 > 0 {
                $1 - list[$0 - 1]
            } else { nil }
        }
    }
    
    static func calculateSigns(differences: [Int]) -> [Int] {
        return differences.map {
            if abs($0) > 3 {
                $0
            } else {
                $0.signum()
            }
        }
    }
}
