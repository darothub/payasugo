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

    var gradient: LinearGradient {
      LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        VStack(spacing: 0.0){
            let point = chartData.point < 1 ? "" : "KES\(String(format: "%.0f", chartData.point))"
            let height = Swift.min(chartData.point/30, 20000)
            Text("\(point)")
                .font(.system(size: 10))
              Rectangle()
                  .fill(.green)
                  .frame(width: 30, height: CGFloat(height))
                  .animation(.easeInOut, value: CGFloat(height))
            Text(chartData.xName.rawValue)
                .font(.caption)
        }

    }
    
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(chartData: ChartData(xName: .Jan, point: 1000), colors: [.green])
    }
}
