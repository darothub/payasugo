//
//  BillsEntryUIView.swift
//  
//
//  Created by Abdulrasaq on 06/07/2023.
//
import Checkout
import Core
import CoreNavigation
import CoreUI
import SwiftUI

public struct BillsEntryUIView: View {
    @StateObject var billViewModel: BillViewModel = BillsDI.createBillViewModel()
    @EnvironmentObject var navigation: NavigationManager
    @State var chartData: [ChartData] = .init()
    @State var categorySectionHeight: CGFloat = 100.0
    @State var chartSectionHeight: CGFloat = 200.0
    @State var airtimeServices = [MerchantService]()
    @State var categories: [[CategoryDTO]] = [[CategoryDTO]]()
    @State var rechargeAndBill = [MerchantService]()
    @State var allRecharges = [String: [MerchantService]]()
    @State var fetchedBill = [DynamicInvoiceType]()
    @State var billType = DueBillType.dueBills
    @State var isShowingDueBills = false
    @State var isShowingUpcomingBills = false
    @State var dueBillIsLoading = false
    @State var colorTint:Color = .blue
    var quickTopUpListener: ServicesListener
    public init(quickTopUpListener: ServicesListener) {
        self.quickTopUpListener = quickTopUpListener
    }
    public var body: some View {
        VStack(spacing: 10) {
            DueBillsView(isShowingBills: $isShowingDueBills, isLoading: $dueBillIsLoading)
                .shadowBackground()
                .environmentObject(billViewModel)
            
            DueBillsView(isShowingBills: $isShowingUpcomingBills, billType: .upcomingBills, isLoading: $dueBillIsLoading)
                .shadowBackground()
                .environmentObject(billViewModel)

            RechargeAndBillView(quickTopUpListener: quickTopUpListener)
                .shadowBackground()
                .environmentObject(billViewModel)
          
            ExpensesGraphView(chartData: chartData)
                .shadowBackground()
                .environmentObject(billViewModel)
            
            AddNewBillCardView()
        }
        .onAppear {
            loadData()
        }
        
    }
    fileprivate func loadData()   {
        Task {
            await billViewModel.getDueBills()
            billViewModel.getSavedBills()
            billViewModel.getRechargeAndOtherBillServices()
            chartData = billViewModel.getBarChartData()
        }
    }
}

struct BillsEntryUIView_Previews: PreviewProvider {
    struct BillsEntryUIViewViewHolder: View, ServicesListener {
        func onQuicktop(serviceName: String) {
            //
        }
        
        var body: some View {
            BillsEntryUIView(quickTopUpListener: self)
                .environmentObject(NavigationManager.shared)
        }
    }
    static var previews: some View {
        BillsEntryUIViewViewHolder()
            .environmentObject(NavigationManager.shared)
    }
}
