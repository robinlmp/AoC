import RegexBuilder
import Foundation

struct Day3: Solution {
    static let day = 3

    let regex = #"mul\([0-999]+,[0-999]+\)"#
    let mulRegex = try? Regex(#"mul\([0-999]+,[0-999]+\)"#)
    let doRegex = try? Regex(#"do\(\)"#)
    let dontRegex = try? Regex(#"don't\(\)"#)
    let input: String
    
    init(input: String) {
        let combined = input.replacingOccurrences(of: "\n", with: "")
        self.input = combined
    }
    
    func calculatePartOne() -> Int {
        let strings = extractMulStrings(input: input)
        let muls = parseMulStrings(input: strings)
        
        return muls.reduce(into: 0) { partialResult, mul in
            partialResult += mul.result
        }
    }
    
    func calculatePartTwo() -> Int {
        let operators = extractOperators(input: input)
        return perform(operators: operators)
    }
    
    func parseMulStrings(input: [String]) -> [Mul] {
        return input.map {
            let pair = $0
                .replacingOccurrences(of: "mul(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .components(separatedBy: ",")
                .compactMap(Int.init)
            
            return Mul(left: pair.first, right: pair.last)
        }.compactMap { $0 }
    }
    
    func extractMulStrings(input: String) -> [String] {
        let matches: [String] = input.match(regex).flatMap { $0 }
        return matches
    }
    
    func perform(operators: [Day3HasStringRange]) -> Int {
        var active: Bool = true
        var total: Int = 0
        
        operators.forEach {
            if active, let mul = $0 as? MulPart2 {
                total += mul.result
            } else if $0 is Do {
                active = true
            } else if $0 is Dont {
                active = false
            }
        }
        return total
    }
    
    func extractOperators(input: String) -> [Day3HasStringRange] {
        guard let mulRegex = mulRegex,
              let doRegex = doRegex,
              let dontRegex = dontRegex
        else {
            print("failed regex init")
            return []
        }
        
        let ranges = input.ranges(of: mulRegex)
        let doRanges = input.ranges(of: doRegex)
        let dontRanges = input.ranges(of: dontRegex)
        
        let mul = ranges.compactMap {
            let pair = input[$0]
                .replacingOccurrences(of: "mul(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .components(separatedBy: ",")
                .compactMap(Int.init)
            
            let startIndex = input.distanceFromStart(to: $0.lowerBound)
            return MulPart2(left: pair.first, right: pair.last, startIndex: startIndex)
        }.compactMap { $0 }
        
        let dos = doRanges.compactMap {
            return Do(startIndex: input.distanceFromStart(to: $0.lowerBound))
        }
        
        let donts = dontRanges.compactMap {
            return Dont(startIndex: input.distanceFromStart(to: $0.lowerBound))
        }
        
        let all: [Day3HasStringRange] = mul + dos + donts
        return all.sorted { lhs, rhs in
            lhs.startIndex < rhs.startIndex
        }
    }
}

// MARK: Day 3 types
protocol Day3HasStringRange {
    var startIndex: Int { get }
}

extension Day3 { // part 2
    struct MulPart2: Day3HasStringRange {
        let left: Int
        let right: Int
        let startIndex: Int
        
        var result: Int {
            left * right
        }
        
        init?(left: Int?, right: Int?, startIndex: Int) {
            self.startIndex = startIndex
            if let left, let right {
                self.left = left
                self.right = right
            } else { return nil }
        }
    }
    
    struct Do: Day3HasStringRange {
        let startIndex: Int
    }
    
    struct Dont: Day3HasStringRange {
        let startIndex: Int
    }
}

extension Day3 { // part 1
    struct Mul {
        let left: Int
        let right: Int
        
        var result: Int {
            left * right
        }
        
        init?(left: Int?, right: Int?) {
            if let left, let right {
                self.left = left
                self.right = right
            } else { return nil }
        }
    }
}
