//
//  PieChart.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import SwiftUI

public struct PieChart: View {
    @State var scale: CGFloat = .zero
    let total: Float
    let data: [PieChartModel]
    
    public init(data: [PieChartModel]) {
        self.data = data
        self.total = Float(data.map({ $0.value }).reduce(.zero, +))
    }
    
    public var body: some View {
        HStack(content: {
            VStack(alignment: .leading, spacing: nil, content: {
                ForEach(data) { data in
                    VStack(alignment: .leading, spacing: 0, content: {
                        PercentText(value: data.value, total: total)
                        HStack(alignment: .center, spacing: nil, content: {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(data.color)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .center)
                            Text(data.title)
                        })
                    })
                }
            })
            Spacer()
            GeometryReader(content: { geometry in
                ZStack(content: {
                    ForEach(data.anglePairs) { anglePair in
                        Pie(startAngle: anglePair.startAngle, endAngle: anglePair.endAngle)
                            .fill(anglePair.color)
                            .scaleEffect(scale)
                            .onAppear(perform: {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    scale = 1.0
                                }
                            })
                    }
                    .overlay(Circle().strokeBorder(Color.originary, lineWidth: 5))
                    .overlay(Circle().fill(Color.originary).frame(width: geometry.size.width * 0.55, height: geometry.size.width * 0.55, alignment: .center))
                })
            })
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 180)
        })
            .padding(.horizontal)
    }
}

private struct PercentText: View {
    let value: Float
    let total: Float
    
    var body: some View {
        Text(String(format: "%.02f%%", 100 * value / total))
            .font(Font.system(.caption, design: .monospaced))
            .bold()
            .foregroundColor(Color.secondary)
    }
}

struct PieChart_Previews: PreviewProvider {
    static let data: [PieChartModel] = [
        PieChartModel(value: 10, color: .orange, title: "fistia-kun"),
        PieChartModel(value: 20, color: .red, title: "entei-kun"),
        PieChartModel(value: 30, color: .blue, title: "seimitsuai-kun"),
        PieChartModel(value: 40, color: .yellow, title: "seimitsudx-kun"),
    ]
    static var previews: some View {
        ScrollView(content: {
            PieChart(data: data)
                .preferredColorScheme(.light)
            
        })
    }
}
