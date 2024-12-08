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
