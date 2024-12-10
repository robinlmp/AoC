import Algorithms

struct Day9: Solution {
    static let day = 9
    
    struct Block: Hashable, CustomStringConvertible {
        let id: Int?
        var description: String {
            id != nil ? "\(id!)" : "."
        }
    }
    
    let input: [Int]
    let blocks: [Block]
    let filesAndGaps: [[Block]]
    
    init(input: String) {
        self.input = input
            .compactMap {
                Int(String($0))
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
        
        self.filesAndGaps = blocks.chunked(on: \.id).map {
            return Array($0.1)
        }
    }
    
    func calculatePartOne() -> Int {
        let blocks = moveBlocks(self.blocks)
        return calculateChecksum(blocks)
    }
    
    func calculatePartTwo() -> Int {
        let blocks = moveFiles(blocks)
        return calculateChecksum(blocks)
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
    
    func moveFiles(_ blocks: [Block]) -> [Block] {
        let files = filesAndGaps.filter {
            $0.map(\.id).contains(nil) == false
        }.reversed()
        var blocks: [Block] = blocks
        
        files
            .forEach { file in
                guard let emptyRange = blocks.firstRange(of: emptyBlocksFor(count: file.count)),
                      let fileRange = blocks.ranges(of: file).last else { return }

                if emptyRange.lowerBound < fileRange.lowerBound {
                    for i in emptyRange.indices {
                        blocks[i] = file[0]
                    }
                    
                    for i in fileRange {
                        blocks[i] = emptyBlocksFor(count: 1).first!
                    }
                }
        }
        
        return blocks
    }
    
    func emptyBlocksFor(count: Int) -> [Block] {
        (0..<count).map { _ in
            Block(id: nil)
        }
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
