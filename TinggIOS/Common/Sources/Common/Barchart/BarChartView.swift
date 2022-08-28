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
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .bottom, spacing: 3.0) {
                    ForEach(data, id: \.xName) { chartdatum in
                        BarView(chartData: chartdatum, colors: [.green])
                    }
                }
            }
        }.frame(height: 240, alignment: .bottom)
        .padding(20)
        .background(.thinMaterial)
        .cornerRadius(6)
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: [ChartData(xName: .Jan, point: 70000), ChartData(xName: .Feb, point: 0), ChartData(xName: .March, point: 1200)], colors: [.green, .green])
    }
}



