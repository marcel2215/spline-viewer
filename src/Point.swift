import Foundation

struct Point: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
