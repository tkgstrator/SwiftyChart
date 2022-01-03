//
//  SwiftUIView.swift
//  
//
//  Created by devonly on 2022/01/03.
//

import SwiftUI

public struct BarChart: View {
    @State var scale: CGFloat = .zero
    let data: [BarChartModel]
    let maxValue: CGFloat
    
    public init(data: [BarChartModel]) {
        self.data = data
        self.maxValue = data.map({ $0.value }).max() ?? .zero
    }
    
    public var body: some View {
        HStack(content: {
            VStack(alignment: .leading, spacing: nil, content: {
                ForEach(data) { data in
                    VStack(alignment: .leading, spacing: 0, content: {
//                        PercentText(value: data.value, total: total)
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
                HStack(content: {
                    ForEach(data.indices) { index in
                        BarChartCell(data: data[index], maxValue: maxValue)
                            .scaleEffect(CGSize(width: 1.0, height: scale), anchor: .bottom)
                            .animation(.spring())
                            .padding(.top)
                    }
                })
                    .onAppear(perform: {
                        scale = 1.0
                    })
            })
            
        })
    }
}

private struct BarChartCell: View {
    @State private var isSelected: Bool = false
    let value: CGFloat
    let color: Color
    
    init(data: BarChartModel, maxValue: CGFloat) {
        self.value = data.value / maxValue
        self.color = data.color
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color.opacity(isSelected ? 0.7 : 1.0))
            .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
//            .frame(maxWidth: 40)
    }
}

struct BarChart_Previews: PreviewProvider {
    static var data: [BarChartModel] = [
        BarChartModel(value: 10, color: .orange, title: "fistia-kun"),
        BarChartModel(value: 20, color: .red, title: "entei-kun"),
        BarChartModel(value: 30, color: .blue, title: "seimitsuai-kun"),
        BarChartModel(value: 40, color: .yellow, title: "seimitsudx-kun"),
        //        BarChartModel(value: 30, color: .blue, title: "seimitsuai-kun"),
        //        BarChartModel(value: 20, color: .red, title: "seimitsudx-kun"),
        //        BarChartModel(value: 10, color: .orange, title: "seimitsudx-kun")
    ]
    static var previews: some View {
        BarChart(data: data)
            .preferredColorScheme(.dark)
    }
}
