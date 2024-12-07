import Algorithms

struct Day7: Solution {
    static let day = 7
    
    let rows: [[Int]]
    let operatorOptions: [[Day7.Operator]]
    
    enum Operator: CaseIterable, Hashable {
        static let part1Operators: [Self] = [.add, .multiply]
        
        case add
        case multiply
        
        func calculate(_ left: Int, _ right: Int) -> Int {
            switch self {
            case .add: return left + right
            case .multiply: return left * right
            }
        }
    }
    
    init(input: String) {
        let parsed = input
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map {
                $0.components(separatedBy: ":")
                    .flatMap {
                        $0.components(separatedBy: " ")
                            .compactMap(Int.init)
                    }
            }
        
        let max = parsed.max(by: { $0.count < $1.count })?.count ?? 0
        
        let operatorOptions = Self.calculateOperatorCombinations(max: max)
        
        self.operatorOptions = operatorOptions
        rows = parsed
    }
    
    func calculatePartOne() -> Int {
        calcalateCalibrationValue()
    }
    
    func calculatePartTwo() -> Int {
        0
    }
}

extension Day7 {
    func calcalateCalibrationValue() -> Int {
        var result = 0
        
        for row in rows {
            var row = row
            let target = row.removeFirst()
            
            if part1CalculateRow(target: target, row: row) {
                result += target
            }
        }
        return result
    }

    func part1CalculateRow(target: Int, row: [Int]) -> Bool {        
        let perms = Set(
            operatorOptions.map {
                Array($0.prefix(row.count))
            }
        )
        
        for permutation in perms {
            if calculateRowForOperatorList(permutation, row: row) == target {
                return true
            }
        }
        return false
    }
    
    func calculateRowForOperatorList(_ operators: [Operator], row: [Int]) -> Int {
        let first = row[0]
        let zipped = zip(operators, row.dropFirst())
        return zipped.reduce(into: first) { partialResult, pair in
            partialResult = pair.0.calculate(partialResult, pair.1)
        }
    }
    
    static func calculateOperatorCombinations(max: Int)
    -> [[Day7.Operator]]

    {
        let allOptions = (0...max).flatMap { _ in
            Operator.part1Operators
        }
        
        let combos = allOptions.uniquePermutations(ofCount: max - 1)

        return combos.map { $0 }
    }
}
