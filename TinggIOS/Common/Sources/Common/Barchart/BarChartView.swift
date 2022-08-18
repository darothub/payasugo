//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 17/08/2022.
//

import SwiftUI

public struct BarChartView: View {
    var data: [ChartData]
    var colors: [Color]
    public init(data: [ChartData], colors: [Color]){
        self.data = data
        self.colors = colors
    }
    public var body: some View {
        HStack(alignment: .bottom, spacing: 3.0) {
            ForEach(data, id: \.xName) { chartdatum in
                BarView(chartData: chartdatum, colors: [.green])
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: [ChartData(xName: .Jan, point: 7000), ChartData(xName: .Feb, point: 0), ChartData(xName: .March, point: 1200)], colors: [.green, .green])
    }
}



