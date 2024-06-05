import SwiftUI
import Charts

struct ContentView: View {
    @State private var spline = CubicSpline()
    @State private var chartColor = Color.blue
    @State private var parameter = 0.0
    @State private var isShowingDerivatives = false

    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        return formatter
    }()

    var body: some View {
        VStack {
            Chart {
                ForEach(spline.interpolatedPoints) { point in
                    LineMark(x: .value("X", point.x), y: .value("Y", point.y))
                }
                .interpolationMethod(.monotone)
                .foregroundStyle(chartColor)
            }
            GroupBox {
                DisclosureGroup {
                        Text("Points")
                            .font(.headline)
                        ForEach($spline.points, id: \.id) { $point in
                            HStack {
                                Text("X: ")
                                TextField("X", value: $point.x, formatter: decimalFormatter)
                                Stepper("", value: $point.x, in: 0...1000)
                                Text("Y: ")
                                TextField("Y", value: $point.y, formatter: decimalFormatter)
                                Stepper("", value: $point.y, in: 0...1000)
                                Button {
                                    spline.points.removeAll {$0.id == point.id }
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                        .labelStyle(.iconOnly)
                                }
                            }
                        }
                    HStack {
                        Button {
                            spline.points.append(Point(x: 0, y: 0))
                        } label: {
                            Label("Add Point", systemImage: "plus")
                        }
                        Button {
                           reset()
                        } label: {
                            Label("Reset", systemImage: "arrow.circlepath")
                        }
                        Button {
                            spline.points.removeAll()
                        } label: {
                            Label("Clear", systemImage: "trash")
                        }
                    }
                    ColorPicker(selection: $chartColor, label: {
                        Text("Color")
                    })
                } label: {
                    Text("Settings")
                }
            }
            GroupBox {
                DisclosureGroup("Derivatives") {
                    HStack {
                        Text("Parameter:")
                        TextField("Parameter", value: $parameter, formatter: decimalFormatter)
                        Button("Calculate") {
                            isShowingDerivatives = true
                        }
                    }
                    .sheet(isPresented: $isShowingDerivatives) {
                        VStack {
                            Text("Parameter: \(parameter)")
                            Text("Value: \(spline.interpolatedValue(at: parameter))")
                            Text("First derivative: \(spline.firstDerivative(at: parameter))")
                            Text("Second derivative: \(spline.secondDerivative(at: parameter))")
                            Button("Close") {
                                isShowingDerivatives = false
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            reset()
        }
    }

    private func reset() {
        spline.points.removeAll()
        spline.points.append(Point(x: 10, y: 50))
        spline.points.append(Point(x: 40, y: 40))
        spline.points.append(Point(x: 100, y: 125))
        spline.points.append(Point(x: 200, y: 110))
        spline.points.append(Point(x: 400, y: 220))
        spline.points.append(Point(x: 650, y: 140))
    }
}

#Preview {
    ContentView()
}
