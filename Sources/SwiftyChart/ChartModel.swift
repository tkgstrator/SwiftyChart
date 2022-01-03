//
//  ChartModel.swift
//  
//
//  Created by devonly on 2022/01/02.
//

import Foundation
import SwiftUI

public protocol ChartModel: Identifiable {
    var id: UUID { get }
    var value: CGFloat { get }
    var title: String { get }
    var color: Color { get }
}

extension ChartModel {
    public var id: UUID { UUID() }
}
