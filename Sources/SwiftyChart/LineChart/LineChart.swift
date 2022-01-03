//
//  SwiftUIView.swift
//  
//
//  Created by devonly on 2022/01/03.
//

import SwiftUI

public struct LineChart: View {
    @State var isVisible: Bool = false
    let dataSet: [LineChartModelSet]
    
    public init(data: [[LineChartModel]]) {
        self.dataSet = data.map({ LineChartModelSet(data: $0, title: "", color: .primary) })
    }
    
    public init(data: [LineChartModelSet]) {
        self.dataSet = data
    }
    
    public var body: some View {
        ZStack(content: {
            GeometryReader(content:  { geometry in
                LineGrid()
                    .trim(to: isVisible ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .square, dash: [10, 10, 10, 10]))
                    .opacity(0.5)
                ForEach(dataSet) { data in
                    Line(data: data.data.map({ $0.value }))
                        .trim(to: isVisible ? 1 : 0)
                        .stroke(data.color, lineWidth: 3)
                }
            })
        })
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: 2.0)) {
                    isVisible = true
                }
            })
            .frame(height: 300)
    }
}

struct LineGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for index in 0..<10 {
            path.move(to: CGPoint(x: .zero, y: rect.height / 10 * CGFloat(index)))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height / 10 * CGFloat(index)))
        }
        return path
    }
}

struct Line: Shape {
    var data: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        let maxValue = data.max() ?? .zero
        let step = rect.width / (CGFloat(data.count) - 1)
        var path = Path()
        
        path.move(to: CGPoint(x: .zero, y: data[0] * rect.height / maxValue))
        for (index, value) in data.enumerated() {
            let pt = CGPoint(x: CGFloat(index) * step, y: value * rect.height / maxValue)
            path.addLine(to: pt)
        }
        return path
    }
}

struct LineChart_Previews: PreviewProvider {
    static var data: [LineChartModelSet] = [
        LineChartModelSet(data: (0...20).map({ _ in LineChartModel(value: CGFloat.random(in: 0..<1), title: "") }), title: "", color: .red),
        LineChartModelSet(data: (0...20).map({ _ in LineChartModel(value: CGFloat.random(in: 0..<1), title: "") }), title: "", color: .blue),
        LineChartModelSet(data: (0...20).map({ _ in LineChartModel(value: CGFloat.random(in: 0..<1), title: "") }), title: "", color: .green)
    ]
    static var previews: some View {
        LineChart(data: data)
    }
}
