import Algorithms

struct Day1: Solution {
    static let day = 1
    let pairs: Pairs
    
    /// Initialise your solution
    ///
    /// - parameters:
    ///   - input: Contents of the `Day1.input` file within the same folder as this source file
    init(input: String) {
        self.pairs = Pairs(
            pairs: input
                .components(separatedBy: .newlines)
                .map {
                    $0.components(separatedBy: .whitespaces)
                        .compactMap(Int.init)
                    
                }
        )
    }

    /// Return your answer to the main activity of the advent calendar
    ///
    /// If you need to, you can change the return type of this method to any type that conforms to `CustomStringConvertible`, i.e. `String`, `Float`, etc.
    func calculatePartOne() -> Int {
        pairs.totalDifference()
    }

    /// Return your solution to the extension activity
    /// _ N.B. This is only unlocked when you have completed part one! _
    func calculatePartTwo() -> Int {
        pairs.part2Total()
    }
}

extension Day1 {
    struct Pairs {
        let pairs: [[Int]]
        
        var leftList: [Int] {
            pairs.compactMap(\.first).sorted()
        }
        var rightList: [Int] {
            pairs.compactMap(\.last).sorted()
        }
        
        func differenceAt(index: Int) -> Int {
            abs(leftList[index] - rightList[index])
        }
        
        func totalDifference() -> Int {
            return leftList
                .indices
                .reduce(into: 0) { result, index in
                    result += differenceAt(index: index)
            }
        }
        
        func numberMatchMultiply(number: Int) -> Int {
            rightList.filter {
                $0 == number
            }.count * number
        }
        
        func part2Total() -> Int {
            leftList.reduce(into: 0) { result, number in
                result += numberMatchMultiply(number: number)
            }
        }
    }
}
