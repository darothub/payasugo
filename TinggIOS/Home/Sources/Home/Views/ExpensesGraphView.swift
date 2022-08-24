//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 16/08/2022.
//

import Common
import SwiftUI

struct ExpensesGraphView: View {
//    @EnvironmentObject var hvm: HomeViewModel
    var chartData = [ChartData]()
    var body: some View {
        Section{
            BarChartView(data: chartData, colors: [.green, .green])
        }.padding(20)
            .frame(maxWidth: .infinity)
    }
}

struct ExpensesGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesGraphView()
    }
}
