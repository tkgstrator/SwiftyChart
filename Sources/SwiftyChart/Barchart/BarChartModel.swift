//
//  File.swift
//  
//
//  Created by devonly on 2022/01/03.
//

import Foundation
import SwiftUI

public struct BarChartModel: ChartModel {
    public init(value: Float, color: Color, title: String) {
        self.value = value
        self.title = title
        self.color = color
    }
    
    public var value: Float
    public var title: String
    public var color: Color
}
