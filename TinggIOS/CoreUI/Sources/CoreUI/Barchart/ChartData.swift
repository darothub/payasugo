//
//  File.swift
//  
//
//  Created by Abdulrasaq on 17/08/2022.
//

import Foundation
public struct ChartData: Equatable {
    public var xName: ChartMonth
    public var point: Double
    public init(xName: ChartMonth, point: Double){
        self.xName = xName
        self.point = point
    }
}

public enum ChartMonth: String, CaseIterable {
    case Jan, Feb, March, April, May,
    June, July, Aug, Sept, Oct, Nov, Dec
}

public let yearlyDefault = [
    ChartData(xName: .Jan, point: 1000),
    ChartData(xName: .Feb, point: 500),
    ChartData(xName: .March, point: 200),
    ChartData(xName: .April, point: 0),
    ChartData(xName: .May, point: 0),
    ChartData(xName: .June, point: 0),
    ChartData(xName: .July, point: 300),
    ChartData(xName: .Aug, point: 0),
    ChartData(xName: .Sept, point: 400),
    ChartData(xName: .Oct, point: 0),
    ChartData(xName: .Nov, point: 0),
    ChartData(xName: .Dec, point: 2000),
]

