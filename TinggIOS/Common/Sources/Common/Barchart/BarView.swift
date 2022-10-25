//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 17/08/2022.
//

import SwiftUI

struct BarView: View {
    var chartData: ChartData
    var colors: [Color]
    @State var height: Double = 1200.0
    var minHeight: Double {
        var minHeight = 0.0
        if height > 10000 {
            minHeight = Swift.min(chartData.point/100, height)
        } else {
            minHeight = Swift.min(chartData.point/50, height)
        }
        return minHeight
    }
    var body: some View {
        VStack(spacing: 1.0){
            let point = chartData.point < 1 ? "" : "KES\(String(format: "%.0f", chartData.point))"
          
            Text("\(point)")
                .font(.system(size: 10))
              Rectangle()
                  .fill(.green)
                  .frame(width: 40, height: minHeight)
                  .animation(.easeInOut, value: minHeight)
                  .padding(.bottom, 0)
            Divider()
            Text(chartData.xName.rawValue)
                .font(.caption)
        }

    }
    
}

struct BarView_Previews: PreviewProvider {
    struct BarViewHolder: View {
        @State var height = 1200.0
        var body: some View {
            BarView(
                chartData: ChartData(xName: .Jan, point: 100),
                colors: [.green],
                height: height
            )
        }
    }
    static var previews: some View {
        BarViewHolder()
    }
}
