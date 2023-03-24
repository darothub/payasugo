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
    var maxHeight: Double {
        let sorted = data.sorted { cd1, cd2 in
            cd1.point < cd2.point
        }
        let distance = 200.0
        guard let lastDataPoint = sorted.last?.point else {
            return 0.0
        }
        if lastDataPoint <= 0.0 {
            return distance
        } else if lastDataPoint.truncatingRemainder(dividingBy: distance) == 0.0 {
            return lastDataPoint
        }
       
        let remainder = lastDataPoint/distance
        let result = remainder.rounded(.up) * distance
        return result
    }
    public init(data: [ChartData], colors: [Color]){
        self.data = data
        self.colors = colors
    }
    public var body: some View {
        VStack {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false){
                    horizontalAlignmentBarView()
                }
            }
            
        }
        .padding(20)
        .background(.thinMaterial)
        .cornerRadius(6)
    }
    @ViewBuilder
    func horizontalAlignmentBarView() -> some View {
        HStack(alignment: .bottom, spacing: 4.0) {
            Divider()
                .frame(height: (maxHeight/100) + 100)
                .padding(.vertical)
            ForEach(data.indices, id: \.self) { index in
                let chartdatum = data[index]
                BarView(chartData: chartdatum, colors: [.green], height: maxHeight)
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: [ChartData(xName: .Jan, point: 10000), ChartData(xName: .Feb, point: 0), ChartData(xName: .March, point: 1200)], colors: [.green, .green])
    }
}



