//
//  File.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import Foundation
import SwiftUI

public struct PieChartModel: ChartModel {
    public init(value: CGFloat, color: Color, title: String) {
        self.value = value
        self.color = color
        self.title = title
    }

    public let value: CGFloat
    public let color: Color
    public let title: String
}
