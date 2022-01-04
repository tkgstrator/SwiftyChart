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
            VStack(content: {
                GeometryReader(content:  { geometry in
                    LineGrid()
                        .trim(to: isVisible ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .square, dash: [10, 10, 10, 10]))
                        .opacity(0.5)
                    ForEach(dataSet) { data in
//                        Line(data: data.data.map({ $0.value }))
                        LineCurve(data: data.data.map({ $0.value }))
                            .trim(to: isVisible ? 1 : 0)
                            .stroke(data.color, lineWidth: 3)
                    }
                })
                LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .leading), count: 2), alignment: .center, content: {
                    ForEach(dataSet) { data in
                        HStack(alignment: .center, spacing: nil, content: {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(data.color)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .center)
                            Text(data.title)
                        })
                    }
                })
                    .padding()
            })
        })
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: 2.0)) {
                    isVisible = true
                }
            })
            .padding(.horizontal)
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

struct LineCurve: Shape {
    var data: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        let maxValue = data.max() ?? .zero
        let step = rect.width / (CGFloat(data.count) - 1)
        var path = Path()
        
        var p1: CGPoint = CGPoint(x: .zero, y: data[0] * rect.height / maxValue)
        
        // First Point
        path.move(to: p1)
        for index in 1..<data.count {
            let pt: CGPoint = CGPoint(x: CGFloat(index) * step, y: data[index] * rect.height / maxValue)
            let mid: CGPoint = midPoint(for: (p1, pt))
            path.addQuadCurve(to: mid, control: controlPoint(for: (mid, p1)))
            path.addQuadCurve(to: pt, control: controlPoint(for: (mid, pt)))
            p1 = pt
        }
        return path
    }
    
    func controlPoint(for points: (CGPoint, CGPoint)) -> CGPoint {
        var controlPoint = midPoint(for: points)
        let diffY = abs(points.1.y - controlPoint.y)

        if points.0.y < points.1.y {
          controlPoint.y += diffY
        } else if points.0.y > points.1.y {
          controlPoint.y -= diffY
        }
        return controlPoint
    }
    
    func midPoint(for points: (CGPoint, CGPoint)) -> CGPoint {
        CGPoint(x: (points.0.x + points.1.x) / 2 , y: (points.0.y + points.1.y) / 2)
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
        LineChartModelSet(data: (0...20).map({ _ in LineChartModel(value: CGFloat.random(in: 0..<1), title: "entei-kun") }), title: "entei-kun", color: .red),
        LineChartModelSet(data: (0...20).map({ _ in LineChartModel(value: CGFloat.random(in: 0..<1), title: "fistia-kun") }), title: "fistia-kun", color: .blue),
        LineChartModelSet(data: (0...20).map({ _ in LineChartModel(value: CGFloat.random(in: 0..<1), title: "soltia-kun") }), title: "soltia-kun", color: .green)
    ]
    static var previews: some View {
        LineChart(data: data)
    }
}
