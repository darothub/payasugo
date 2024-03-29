//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 16/08/2022.
//
import Charts
import CoreUI
import SwiftUI

struct ExpensesGraphView: View {
    var chartData = [ChartData]()
    var body: some View {
        Section{
            Chart(chartData, id: \.xName) { datum in
                BarMark(
                    x: .value("Month", datum.xName.rawValue),
                    y: .value("Amount", datum.point)
                ).foregroundStyle(.green)
            }
        }
        .padding(20)
    }
}

struct ExpensesGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesGraphView(chartData: yearlyDefault)
    }
}
