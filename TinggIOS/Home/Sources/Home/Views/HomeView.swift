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
        hvm.servicesByCategory
    }
    var chartData: [ChartData] {
        hvm.mapHistoryIntoChartData()
    }
    var airtimeServices: [MerchantService] {
        hvm.airTimeServices
    }
    var fetchedBill: [FetchedBill] {
        hvm.dueBill
    }
    var rechargeAndBill: [MerchantService] {
        hvm.rechargeAndBill
    }
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                bodyView(geo: geo)
            }.ignoresSafeArea()
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)
    }
    @ViewBuilder
    func bodyView(geo: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            HomeTopViewDesign(parentSize: geo)
            ActivateCardView(parentSize: geo) {
                // Intentionally unimplemented...To Do
            }
            ActiveCategoryTabView(categories: categories)
                .background(.white)
                .shadow(radius: 0, y: 3)
                .padding(.vertical, 10)
                .handleViewState(uiModel: $hvm.categoryUIModel)
            
            QuickTopupView(airtimeServices: airtimeServices)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 3)
                )
                .handleViewState(uiModel: $hvm.quickTopUIModel)
            DueBillsView(fetchedBill: fetchedBill)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 3)
                )
                .frame(maxWidth: .infinity)
                .handleViewState(uiModel: $hvm.fetchBillUIModel)
            RechargeAndBillView(rechargeAndBill: rechargeAndBill)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 3)
                ).environmentObject(hvm)
                .handleViewState(uiModel: $hvm.rechargeAndBillUIModel)
            ExpensesGraphView(chartData: chartData)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 3)
                )
            AddNewBillCardView()
        }
        .environmentObject(hvm)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
