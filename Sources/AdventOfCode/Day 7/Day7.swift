import Algorithms

infix operator >|<: AdditionPrecedence

func >|<(lhs: Int, rhs: Int) -> Int {
    Int(lhs.description + rhs.description)!
}

struct Equation {
    let target: Int
    let numbers: [Int]
}

struct Day7: Solution {
    static let day = 7
    
    let rows: [Equation]
    let operatorsPart1: [(Int, Int) -> Int] = [(+), (*)]
    let operatorsPart2: [(Int, Int) -> Int] = [(+), (*), (>|<)]
    
    init(input: String) {
        self.rows = input
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map {
                $0.components(separatedBy: ":")
                    .flatMap {
                        $0.components(separatedBy: " ")
                            .compactMap(Int.init)
                    }
            }
            .map {
                Equation(target: $0.first!, numbers: Array($0.dropFirst()))
            }
    }
    
    func calculatePartOne() -> Int {
        rows.reduce(into: 0) { result, row in
            result += checkEquation(row, operators: operatorsPart1)
        }
    }
    
    func calculatePartTwo() -> Int {
        rows.reduce(into: 0) { result, row in
            result += checkEquation(row, operators: operatorsPart2)
        }
    }
}

extension Day7 {
    func checkEquation(_ equation: Equation, operators: [(Int, Int) -> Int]) -> Int {
        
        let first = equation.numbers.first!
        let result = equation
            .numbers.suffix(from: 1)
            .reduce([first]) { result, number in
                result
                    .flatMap { value in
                        operators.map { operate in
                            return operate(value, number)
                        }
                    }
            }.contains(equation.target)
        return result ? equation.target : 0
    }
}








//import Algorithms
//
//struct Day7: Solution {
//    static let day = 7
//    
//    let rows: [[Int]]
//
//    let operatorOptions: Set<[Day7.Operator]>
//    let operatorOptions2: Set<[Day7.Operator]>
//
//    enum Operator: CaseIterable, Hashable {
//        static let part1Operators: [Self] = [.add, .multiply]
//        static let part2Operators: [Self] = [.add, .multiply, .concatenate]
//        
//        case add
//        case multiply
//        case concatenate
//        
//        func calculate(_ left: Int, _ right: Int) -> Int {
//            switch self {
//            case .add: return
//                left + right
//            case .multiply:
//                return left * right
//            case .concatenate: return
//                left >< right
//            }
//        }
//    }
//    
//    init(input: String) {
//        let parsed = input
//            .components(separatedBy: "\n")
//            .filter { !$0.isEmpty }
//            .map {
//                $0.components(separatedBy: ":")
//                    .flatMap {
//                        $0.components(separatedBy: " ")
//                            .compactMap(Int.init)
//                    }
//            }
//        
//        let max = parsed.max(by: { $0.count < $1.count })?.count ?? 0
//        
//        self.operatorOptions = Self.calculateOperatorCombinations(max: max)
//        self.operatorOptions2 = Self.calculateOperatorCombinations(max: max, operators: Operator.part2Operators)
//
//        rows = parsed
//    }
//    
//    func calculatePartOne() -> Int {
//        calcalateCalibrationValue().0
//    }
//    
//    func calculatePartTwo() -> Int {
//        let result = calcalateCalibrationValue()
//        
//        return calcalateCalibrationValue2(rows: result.1) + result.0
//    }
//}
//
//extension Day7 {
//    func calcalateCalibrationValue2(rows: [[Int]]) -> Int {
//        return rows.map {
//            var row = $0
//            let target = row.removeFirst()
//            
//            return part2CalculateRow(target: target, row: row) ? target : 0
//        }.reduce(0, +)
//    }
//    
//    func part2CalculateRow(target: Int, row: [Int]) -> Bool {
//        let part1perms = Set(
//            operatorOptions.map {
//                Array($0.prefix(row.count - 1))
//            }
//        )
//        
//        let part2perms = Set(
//            operatorOptions2.map {
//                Array($0.prefix(row.count - 1))
//            }
//        )
//
//        let perms = part2perms.subtracting(part1perms)
//        
//        return perms.compactMap {
//            if calculateRowForOperatorList($0, row: row) == target {
//                return true
//            } else {
//                return nil
//            }
//        }.contains(true)
//    }
//    
//    func calcalateCalibrationValue() -> (Int, [[Int]]) {
//        var returnRows: [[Int]] = []
//        
//        let result = self.rows.map {
//            var tempRow = $0
//            let target = tempRow.removeFirst()
//            
//            if part1CalculateRow(target: target, row: tempRow) {
//                return target
//            } else {
//                returnRows.append($0)
//                return 0
//            }
//        }.reduce(0, +)
//        
//        return (result, returnRows)
//    }
//
//    func part1CalculateRow(target: Int, row: [Int]) -> Bool {
//        let perms = Set(
//            operatorOptions.map {
//                Array($0.prefix(row.count - 1))
//            }
//        )
//        
//        for permutation in perms {
//            if calculateRowForOperatorList(permutation, row: row) == target {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func calculateRowForOperatorList(_ operators: [Operator], row: [Int]) -> Int {
//        let first = row[0]
//        let zipped = zip(operators, row.dropFirst())
//        return zipped.reduce(into: first) { partialResult, pair in
//            partialResult = pair.0.calculate(partialResult, pair.1)
//        }
//    }
//    
//    static func calculateOperatorCombinations(max: Int, operators: [Operator] = Operator.part1Operators)
//    -> Set<[Day7.Operator]>
//    {
//        let allOptions = (0...max).flatMap { _ in
//            operators
//        }
//        
//        let combos = Set(allOptions.uniquePermutations(ofCount: max - 2))
//
//        return combos
//    }
//}
//
//infix operator ><: AdditionPrecedence
//
//func ><(lhs: Int, rhs: Int) -> Int {
//    Int(lhs.description + rhs.description)!
//}
