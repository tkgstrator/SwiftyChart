//
//  SwiftUIView.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import SwiftUI

public struct RadarChart: View {
    @State var scale: CGFloat = 0.0
    let dataSet: [RadarChartSet]
    let categories: Int
    let maxValue: CGFloat
    
    public init(data dataSet: [RadarChartSet], maxValue: CGFloat = .zero) {
        self.dataSet = dataSet
        self.categories = dataSet.first?.data.count ?? .zero
        self.maxValue = (dataSet.flatMap({ $0.data }) + [maxValue]).max() ?? .zero
    }
    
    var RadarView: some View {
        ZStack(content: {
            RadarChartGrid(categories: categories, divisions: 5)
                .fill(Color.red.opacity(0.5))
                .aspectRatio(contentMode: .fit)
            RadarChartGrid(categories: categories, divisions: 5)
                .stroke(Color.primary, lineWidth: 3)
                .aspectRatio(contentMode: .fit)
            ForEach(dataSet.indices) { index in
                RadarChartPath(data: dataSet[index].data, maxValue: maxValue)
                    .stroke(dataSet[index].color, lineWidth: 3)
                    .aspectRatio(contentMode: .fit)
                RadarChartPath(data:dataSet[index].data, maxValue: maxValue)
                    .fill(dataSet[index].color.opacity(0.7))
                    .aspectRatio(contentMode: .fit)
            }
        })
            .frame(maxWidth: 400)
            .padding(.horizontal)
            .scaleEffect(scale)
            .onAppear(perform: {
                withAnimation(.easeInOut) {
                    scale = 1.0
                }
            })
    }
    
    public var body: some View {
        VStack(content: {
            RadarView
            LazyVGrid(columns: Array(repeating: .init(), count: 2), content: {
                ForEach(dataSet) { data in
                    HStack(content: {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(data.color)
                            .frame(width: 20, height: 20, alignment: .center)
                        Text(data.caption)
                            .bold()
                            .foregroundColor(.secondary)
                    })
                }
            })
        })

    }
}

internal struct RadarChartLabel: View {
    let labels: [String]

    var body: some View {
        GeometryReader(content: { geometry in
            let midX: CGFloat = geometry.frame(in: .local).midX
            let midY: CGFloat = geometry.frame(in: .local).midY
            let count: CGFloat = CGFloat(labels.count)
            let radius: CGFloat = min(midX, midY)
            
            ForEach(labels.indices) { index in
                Text(labels[index])
                    .bold()
                    .padding(.horizontal, 4)
                    .foregroundColor(Color.inverse)
                    .background(Capsule().fill(Color.originary))
                    .position(
                        x: midX + radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
    }
}

internal struct RadarChartPath: Shape {
    let data: [CGFloat]
    let maxValue: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(center.x, center.y)
        var path = Path()
        
        for (index, entry) in data.enumerated() {
            switch index {
                case 0:
                    let pt: CGPoint = CGPoint(
                        x: center.x,
                        y: center.y - (radius * entry / maxValue)
                    )
                    path.move(to: pt)
                default:
                    let pt: CGPoint = CGPoint(
                        x: center.x - (radius * entry / maxValue) * sin(CGFloat(index) / CGFloat(data.count) * 2 * .pi - .pi),
                        y: center.y + (radius * entry / maxValue) * cos(CGFloat(index) / CGFloat(data.count) * 2 * .pi - .pi)
                    )
                    path.addLine(to: pt)
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
        let radius = min(rect.midX, rect.midY)
        let stride = radius / CGFloat(divisions)
        var path = Path()
        
        for category in 1 ... categories {
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                     y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius))
        }
        //
        for step in 1 ... divisions {
            let rad = CGFloat(step) * stride
            path.move(to: CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
                                  y: rect.midY + sin(-.pi / 2) * rad))
            
            for category in 1 ... categories {
                path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
                                         y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad))
            }
            path.closeSubpath()
        }
        
        return path
    }
}

struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            RadarChart(data: [RadarChartSet(data: [20, 30, 40, 50, 40], caption: "Player", color: .blue)])
                .preferredColorScheme(.dark)
        })
            .preferredColorScheme(.light)
    }
}
