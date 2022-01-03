//
//  LadarChartModel.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import Foundation
import SwiftUI

public struct RadarChartModel: ChartModel {
    public init(value: CGFloat, title: String) {
        self.value = value
        self.title = title
    }
    
    public var value: CGFloat
    public var title: String
    public var color: Color = .primary
}
