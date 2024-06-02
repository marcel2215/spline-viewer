import Foundation

struct Point: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
