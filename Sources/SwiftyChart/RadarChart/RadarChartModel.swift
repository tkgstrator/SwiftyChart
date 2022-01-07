//
//  LadarChartModel.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import Foundation
import SwiftUI

public struct RadarChartSet {
    public init(data: [CGFloat], caption: String, color: Color) {
        self.data = data
        self.caption = caption
        self.color = color
    }
    
    public var data: [CGFloat]
    public var caption: String
    public var color: Color
}

extension RadarChartSet: Identifiable {
    public var id: String { caption }
}
