//
//  ExpensesGraphView.swift
//  
//
//  Created by Abdulrasaq on 12/07/2023.
//
import Charts
import Checkout
import Core
import CoreUI
import SwiftUI
struct ExpensesGraphView: View {
    var chartData = [ChartData]()
    @State var currency = ""
    @State var AnnotationAmount = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Expenses")
            
            Chart(chartData, id: \.xName) { datum in
                BarMark(
                    x: .value("Month", datum.xName.rawValue),
                    y: .value("Amount", datum.point),
                    height: .init(floatLiteral: 100)
                )
                .annotation(position: .top) {
                     Text("\(currency) \(formatNumber(datum.point))")
                         .foregroundColor(Color.gray)
                         .font(.system(size: 12, weight: .bold))
                 }
                .foregroundStyle(.green)
              
            }
            .frame(height: 200)
            .padding(.top)
        }

        .onAppear {
            if let country = AppStorageManager.getCountry() {
                currency = country.currency ?? ""
            }
        }
        .padding(20)
    }
}
