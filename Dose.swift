import Foundation

struct Dose: Identifiable, Codable, Hashable {
    var id = UUID()
    var time: Date
    var taken: Bool
}
