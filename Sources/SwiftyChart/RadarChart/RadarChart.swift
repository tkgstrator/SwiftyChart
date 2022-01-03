//
//  SwiftUIView.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import SwiftUI

public struct RadarChart: View {
    @State var scale: CGFloat = .zero
    let data: [RadarChartModel]
    let maxValue: CGFloat
    
    public init(data: [RadarChartModel]) {
        self.data = data
        self.maxValue = data.map({ $0.value }).max() ?? .zero
    }
    
    public var body: some View {
        ZStack(content: {
            Group(content: {
                RadarChartGrid(categories: data.count, divisions: 5)
                    .fill(Color.red.opacity(0.3))
                RadarChartGrid(categories: data.count, divisions: 5)
                    .stroke(Color.primary, lineWidth: 3)
                RadarChartPath(data: data.map({ $0.value }))
                    .fill(.blue.opacity(0.8))
                    .scaleEffect(scale)
                RadarChartPath(data: data.map({ $0.value }))
                    .stroke(.blue, lineWidth: 3)
                    .scaleEffect(scale)
                RadarChartLabel(labels: data.map({ $0.title }))
                    .opacity(scale)
                    .transition(.opacity)
            })
                .padding(.horizontal)
                .onAppear(perform: {
                    withAnimation(.default) {
                        scale = 1.0
                    }
                })
                .onDisappear(perform: {
                    withAnimation(.default) {
                        scale = 0.0
                    }
                })
        })
    }
}

internal struct RadarChartLabel: View {
    let labels: [String]
    
    var body: some View {
        GeometryReader(content: { geometry in
            ForEach(labels.indices) { index in
                Text(labels[index])
                    .foregroundColor(Color.inverse)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.originary))
                    .position(
                        x: geometry.frame(in: .local).midX + 0.9 * geometry.frame(in: .local).midX * sin(2 * .pi / CGFloat(labels.count) * CGFloat(index)),
                        y: geometry.frame(in: .local).midY + 0.9 * geometry.frame(in: .local).midX * cos(2 * .pi / CGFloat(labels.count) * CGFloat(index))
                    )
            }
        })
    }
}

internal struct RadarChartPath: Shape {
    let data: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        guard
            3 <= data.count,
            let minimum = data.min(),
            0 <= minimum,
            let maximum = data.max()
        else { return Path() }
        
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) * 0.8
        var path = Path()
        
        for (index, entry) in data.enumerated() {
            switch index {
                case 0:
                    path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                          y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
                    
                default:
                    path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                             y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
            }
        }
        path.closeSubpath()
        return path
    }
}

internal struct RadarChartGrid: Shape {
    let categories: Int
    let divisions: Int
    
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) * 0.8
        let stride = radius / CGFloat(divisions)
        var path = Path()
        
        for category in 1 ... categories {
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                     y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius))
        }
        
        for step in 1 ... divisions {
            let rad = CGFloat(step) * stride
            path.move(to: CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
                                  y: rect.midY + sin(-.pi / 2) * rad))
            
            for category in 1 ... categories {
                path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
                                         y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad))
            }
        }
        
        return path
    }
}

struct RadarChart_Previews: PreviewProvider {
    static var data: [RadarChartModel] = [
        RadarChartModel(value: 90, title: "tkgling"),
        RadarChartModel(value: 95, title: "tkgling"),
        RadarChartModel(value: 100, title: "tkgling"),
        RadarChartModel(value: 85, title: "tkgling"),
        RadarChartModel(value: 80, title: "tkgling"),
        RadarChartModel(value: 95, title: "tkgling"),
        RadarChartModel(value: 75, title: "tkgling"),
        RadarChartModel(value: 65, title: "tkgling")
    ]
    static var previews: some View {
        RadarChart(data: data)
    }
}
