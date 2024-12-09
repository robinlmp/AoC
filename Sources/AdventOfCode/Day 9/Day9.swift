import Algorithms

struct Day9: Solution {
    static let day = 9
    
    struct Block: Hashable, CustomStringConvertible {
        var description: String {
            id != nil ? "\(id!)" : "."
        }
        
        let id: Int?
    }
    
    let input: [Int]
    let chunks: [[Int]]
    let blocks: [Block]
    
    init(input: String) {
        self.input = input
            .compactMap {
                Int(String($0))
            }
        
        self.chunks = self
            .input
            .chunks(ofCount: 2)
            .compactMap {
                $0.compactMap(Int.init)
            }
   
        self.blocks = self.input
            .enumerated()
            .flatMap { index, number in
                let even = index % 2 == 0
                
                return (0..<number).map { _ in
                    return even ?
                    Block(id: index / 2) :
                    Block(id: nil)
                }
            }
    }
    
    func calculatePartOne() -> Int {
        let blocks = moveBlocks(self.blocks)
        return calculateChecksum(blocks)
    }
    
    func calculatePartTwo() -> Int {
        0
    }
}

extension Day9 {
    func calculateChecksum(_ blocks: [Block]) -> Int {
        blocks
            .enumerated()
            .map {
                $0 * ($1.id ?? 0)
            }.reduce(0, +)
    }
    
    func moveBlocks(_ blocks: [Block]) -> [Block] {
        var compactedBlocks: [Block] = blocks
            .compactMap { $0.id != nil ? $0 : nil }
        let emptyBlocks: [Block] = blocks
            .filter { $0.id == nil }
        
        let difference = blocks.count - compactedBlocks.count
        return blocks
            .compactMap {
                $0.id != nil ?
                $0 :
                compactedBlocks.popLast()
            }
            .dropLast(difference)
        + emptyBlocks
    }
}

extension Collection where Element == Day9.Block {
    func customDescription() -> String {
        map(\.description).joined()
    }
}
