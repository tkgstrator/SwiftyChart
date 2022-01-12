//
//  File.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import Foundation
import SwiftUI

public struct PieChartModel: ChartModel {
    public init(value: Float, color: Color, title: String) {
        self.value = value
        self.color = color
        self.title = title
    }

    public let value: Float
    public let color: Color
    public let title: String
}
