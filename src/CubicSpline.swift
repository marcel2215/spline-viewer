import Foundation

struct CubicSpline {
    var points = [Point]()

    var interpolatedPoints: [Point] {
        guard points.count > 1 else { return points }

        let n = points.count - 1
        let x = points.map { $0.x }
        let a = points.map { $0.y }

        var b = [Double](repeating: 0.0, count: points.count)
        var c = [Double](repeating: 0.0, count: points.count)
        var d = [Double](repeating: 0.0, count: points.count)
        var l = [Double](repeating: 1.0, count: points.count)
        var z = [Double](repeating: 0.0, count: points.count)
        var mu = [Double](repeating: 0.0, count: points.count)

        var h = [Double](repeating: 0.0, count: n)
        var alpha = [Double](repeating: 0.0, count: n)

        for i in 0..<n {
            h[i] = x[i + 1] - x[i]
            alpha[i] = i == 0 ? 0 : (3 / h[i]) * (a[i + 1] - a[i]) - (3 / h[i - 1]) * (a[i] - a[i - 1])
        }

        for i in 1..<n {
            l[i] = 2 * (x[i + 1] - x[i - 1]) - h[i - 1] * mu[i - 1]
            mu[i] = h[i] / l[i]
            z[i] = (alpha[i] - h[i - 1] * z[i - 1]) / l[i]
        }

        for j in (0..<n).reversed() {
            c[j] = z[j] - mu[j] * c[j + 1]
            b[j] = (a[j + 1] - a[j]) / h[j] - h[j] * (c[j + 1] + 2 * c[j]) / 3
            d[j] = (c[j + 1] - c[j]) / (3 * h[j])
        }

        func interpolate(at x: Double) -> Double {
            var i = n - 1

            while i > 0, x < points[i].x {
                i -= 1
            }

            let deltaX = x - points[i].x
            return a[i] + b[i] * deltaX + c[i] * deltaX * deltaX + d[i] * deltaX * deltaX * deltaX
        }

        var result = [Point]()

        let minX = points.first!.x
        let maxX = points.last!.x

        for currentX in stride(from: minX, through: maxX, by: 0.1) {
            result.append(Point(x: currentX, y: interpolate(at: currentX)))
        }

        return result
    }
}

