//
//  AnglePair.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import Foundation
import SwiftUI

struct AnglePair: Hashable {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
//    let offsetAngle: CGFloat
    
    internal init(startAngle: Angle, endAngle: Angle, color: Color) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.color = color
//        self.offsetAngle = offsetAngle
    }
}

extension AnglePair: Identifiable {
    public var id: Angle { startAngle }
}

extension Array where Element == PieChartModel {
    var anglePairs: [AnglePair] {
        let totalValue: Float = self.map({ $0.value }).reduce(.zero, +)
        let values: [(Float, Color)] = self.map({ ($0.value, $0.color) })
        var startAngle: Angle = .degrees(-90)
        var angles: [AnglePair] = []
        
        for (value, color) in values {
            if !value.isZero {
                let endAngle = startAngle + .degrees(360 * CGFloat(value) / CGFloat(totalValue))
                angles.append(AnglePair(startAngle: startAngle, endAngle: endAngle, color: color))
                startAngle = endAngle
            }
        }
        return angles
    }
}
