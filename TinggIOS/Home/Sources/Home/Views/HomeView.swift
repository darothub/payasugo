//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//
import Common
import Core
import Combine
import SwiftUI
import Theme

struct HomeView: View {
    @EnvironmentObject var hvm: HomeViewModel
    var categories: [[Categorys]] {
        hvm.processedCategories
    }
    var chartData: [ChartData] {
        hvm.mapHistoryIntoChartData()
    }
    var airtimeServices: [MerchantService] {
        hvm.airTimeServices
    }
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    HomeTopViewDesign(parentSize: geo)
                    ActivateCardView(parentSize: geo) {
                        // Intentionally unimplemented...To Do
                    }
                    ActiveCategoryTabView(categories: categories)
                        .background(.white)
                        .shadow(radius: 0, y: 3)
                        .padding(.vertical, 10)
                    QuickTopupView(airtimeServices: airtimeServices)
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                                .foregroundColor(.white)
                                .shadow(radius: 3, x: 0, y: 3)
                        )
                    RechargeAndBillView()
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                                .foregroundColor(.white)
                                .shadow(radius: 3, x: 0, y: 3)
                        )
                    ExpensesGraphView(chartData: chartData)
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                                .foregroundColor(.white)
                                .shadow(radius: 3, x: 0, y: 3)
                        )
                    AddNewBillCardView()
                }
                .environmentObject(hvm)
            }.ignoresSafeArea()
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
