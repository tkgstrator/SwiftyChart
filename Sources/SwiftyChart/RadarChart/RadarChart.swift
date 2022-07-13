//
//  SwiftUIView.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import SwiftUI

public struct RadarChart: View {
    @State var scale: CGFloat = .zero
    let images: [Image] = []
    let dataSet: [RadarChartSet]
    let categories: Int
    let maxValue: CGFloat
    
    public init(data dataSet: [RadarChartSet], maxValue: Float = .zero) {
        self.dataSet = dataSet
        self.categories = dataSet.first?.data.count ?? .zero
        self.maxValue = CGFloat((dataSet.flatMap({ $0.data }) + [maxValue]).max() ?? .zero)
    }
    
    var RadarView: some View {
        HStack(content: {
            VStack(alignment: .leading, spacing: nil, content: {
                ForEach(dataSet.indices, id: \.self) { index in
                    let data = dataSet[index]
                    VStack(alignment: .leading, spacing: 0, content: {
                        PercentText(value: data.data.reduce(0, +), total: Float(categories) * Float(maxValue))
                        HStack(alignment: .center, spacing: nil, content: {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(data.color)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .center)
                            Text(data.caption)
                        })
                    })
                }
            })
            Spacer()
            ZStack(content: {
                RadarChartGrid(categories: categories, divisions: 5)
                    .fill(Color.red.opacity(0.5))
                    .scaledToFit()
                RadarChartGrid(categories: categories, divisions: 5)
                    .stroke(Color.primary, lineWidth: 3)
                    .scaledToFit()
                ForEach(dataSet.indices, id: \.self) { index in
                    RadarChartPath(data: dataSet[index].data, maxValue: maxValue)
                        .stroke(dataSet[index].color, lineWidth: 2)
                        .scaledToFit()
                        .scaleEffect(scale)
                        .animation(.easeIn(duration: 1.0), value: scale)
                    RadarChartPath(data:dataSet[index].data, maxValue: maxValue)
                        .fill(dataSet[index].color.opacity(0.7))
                        .scaledToFit()
                        .scaleEffect(scale)
                        .animation(.easeIn(duration: 1.0), value: scale)
                }
                RadarChartBossLabel()
                    .scaledToFit()
            })
            .padding()
            .frame(maxHeight: 180)
        })
        .onAppear(perform: {
            withAnimation(.easeIn(duration: 1.0)) {
                scale = 1.0
            }
        })
    }
    
    public var body: some View {
        RadarView
    }
}

internal struct RadarChartBossLabel: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let midX: CGFloat = geometry.frame(in: .local).midX
            let midY: CGFloat = geometry.frame(in: .local).midY
            let count: CGFloat = CGFloat(BossId.allCases.count)
            let radius: CGFloat = min(midX, midY)
            
            ForEach(Array(BossId.allCases.enumerated()), id: \.offset) { index, bossId in
                Image(bossId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
                    .background(Circle().fill(Color.originary))
                    .position(
                        x: midX - radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
    }
}

enum BossId: Int, CaseIterable {
    case goldie     = 3
    case steelhead  = 6
    case flyfish    = 9
    case scrapper   = 12
    case steelEel   = 13
    case stinger    = 14
    case maws       = 15
    case griller    = 16
    case drizzler   = 21
}

extension Image {
    init(_ symbol: BossId) {
        self.init("SalmonId/\(symbol.rawValue)", bundle: .module)
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
    let data: [Float]
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
                    y: center.y - (radius * CGFloat(entry) / maxValue)
                )
                path.move(to: pt)
            default:
                let pt: CGPoint = CGPoint(
                    x: center.x - (radius * CGFloat(entry) / maxValue) * sin(CGFloat(index) / CGFloat(data.count) * 2 * .pi - .pi),
                    y: center.y + (radius * CGFloat(entry) / maxValue) * cos(CGFloat(index) / CGFloat(data.count) * 2 * .pi - .pi)
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
        if categories == 0 {
            return path
        }
        
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
    static var data: [RadarChartSet] = [
        RadarChartSet(data: [20, 30, 40, 50, 40], caption: "You", color: .blue),
        RadarChartSet(data: [30, 20, 40, 10, 25], caption: "Other", color: .red),
    ]
    static var previews: some View {
        ScrollView(content: {
            RadarChart(data: data)
                .preferredColorScheme(.dark)
        })
        .preferredColorScheme(.light)
    }
}
