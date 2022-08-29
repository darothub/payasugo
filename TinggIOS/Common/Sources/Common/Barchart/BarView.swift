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

    var body: some View {
        VStack(spacing: 1.0){
            let point = chartData.point < 1 ? "" : "KES\(String(format: "%.0f", chartData.point))"
            let height = Swift.min(chartData.point/500, 100000)
            Text("\(point)")
                .font(.system(size: 10))
              Rectangle()
                  .fill(.green)
                  .frame(width: 30, height: CGFloat(height))
                  .cornerRadius(5)
                  .animation(.easeInOut, value: CGFloat(height))
                  .padding(.bottom, 10)
            Text(chartData.xName.rawValue)
                .font(.caption)
        }

    }
    
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(chartData: ChartData(xName: .Jan, point: 70000), colors: [.green])
    }
}
