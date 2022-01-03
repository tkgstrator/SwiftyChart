//
//  LineChartModel.swift
//  
//
//  Created by devonly on 2022/01/03.
//

import Foundation
import SwiftUI

public struct LineChartModel: ChartModel {
    public init(value: CGFloat, title: String) {
        self.value = value
        self.title = title
    }

    public let value: CGFloat
    public let color: Color = .primary
    public let title: String
}

public struct LineChartModelSet: Identifiable {
    public init(data: [LineChartModel], title: String, color: Color) {
        self.data = data
        self.title = title
        self.color = color
    }

    public let id: UUID = UUID()
    public let data: [LineChartModel]
    public let color: Color
    public let title: String
}
