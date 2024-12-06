import Foundation
struct Day5: Solution {
    static let day = 5
    
    let rules: [(Int, Int)]
    let updates: [[Int]]
    
    init(input: String) {
        let result = input
            .components(separatedBy: "\n\n")
            .filter { !$0.isEmpty }
        self.rules = result
            .first?
            .components(separatedBy: "\n")
            .compactMap {
                $0
                    .components(separatedBy: "|")
                    .compactMap(Int.init)
                    
            }
            .compactMap {
                guard let first = $0.first,
                let last = $0.last else {
                    return nil
                }
                return (first, last)
            } ?? []
    
        self.updates = result
            .last?
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .compactMap {
                $0
                    .components(separatedBy: ",")
                    .compactMap(Int.init)
            } ?? []
    }
    
    func calculatePartOne() -> Int {
        checkUpdatesPart1(updates, rules: rules)
    }
    
    func calculatePartTwo() -> Int {
        let filteredUpdates = updates.compactMap {
            if filterGoodUpdates(update: $0) == false {
                return $0
            } else { return nil }
        }
        
        return checkUpdatesPart2(filteredUpdates, rules: rules)
    }
}

extension Day5 {
    func checkUpdatesPart2(_ updates: [[Int]], rules: [(Int, Int)]) -> Int {
        updates.map {
            validateUpdatePart2(update: $0)
        }.reduce(0, +)
    }
    
    func validateUpdatePart2(update: [Int]) -> Int {
        let temp = update.sorted { lhs, rhs in
            let rules = getRules(number: lhs, rules: rules)
            let rightRules = rules.map(\.0)

            if rightRules.contains(rhs) {
                return false
            } else {
                return true
            }
        }
        print("update: ", update)
        print("temp: ", temp, "\n")
        return temp[(temp.count / 2)]
    }
    
    func filterGoodUpdates(update: [Int]) -> Bool {
        for (index, page) in zip(update.indices, update) {
            if index < update.count-1 {
                let rules = getRules(number: page, rules: rules)
                for index2 in index+1..<update.count {
                    for rule in rules {
                        if rule.0 == update[index2] {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func checkUpdatesPart1(_ updates: [[Int]], rules: [(Int, Int)]) -> Int {
        updates.map {
            validateUpdatePart1(update: $0)
        }.reduce(0, +)
    }
    
    func validateUpdatePart1(update: [Int]) -> Int {
        for (index, page) in zip(update.indices, update) {
            if index < update.count-1 {
                let rules = getRules(number: page, rules: rules)
                for index2 in index+1..<update.count {
                    for rule in rules {
                        if rule.0 == update[index2] {
                            return 0
                        }
                    }
                }
            }
        }
        return update[(update.count / 2)]
    }
    
    func getRules2(number: Int, rules: [(Int, Int)]) -> [(Int, Int)] {
        return rules.filter {
            $0.0 == number
        }
    }
    
    func getRules(number: Int, rules: [(Int, Int)]) -> [(Int, Int)] {
        return rules.filter {
            $0.1 == number
        }
    }
}
