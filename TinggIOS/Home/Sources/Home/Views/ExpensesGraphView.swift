//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 16/08/2022.
//
import Common
import SwiftUI

struct ExpensesGraphView: View {
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        Section{
            BarChartView(data: hvm.mapHistoryIntoChartData(), colors: [.green, .green])
        }.padding(.horizontal, 20)
    }
}

struct ExpensesGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesGraphView()
    }
}
