import Foundation

extension String {
    func distanceFromStart(to index: String.Index) -> Int {
        distance(from: startIndex, to: index)
    }
}
