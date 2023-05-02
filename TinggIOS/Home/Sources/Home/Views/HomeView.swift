//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//
import CoreUI
import CoreNavigation
import Core
import Combine
import SwiftUI
import Theme

struct HomeView: View {
    
    @EnvironmentObject var hvm: HomeViewModel
    @State var profileImageUrl: String = ""
    @EnvironmentObject var navigation: NavigationUtils
    var categories: [[CategoryEntity]] {
        hvm.servicesByCategory
    }
    var chartData: [ChartData] {
        hvm.mapHistoryIntoChartData()
    }
    var airtimeServices: [MerchantService] {
        hvm.airTimeServices
    }
    var rechargeAndBill: [MerchantService] {
        hvm.rechargeAndBill
    }
    var profileImageURL : String {
        hvm.getProfile()?.photoURL ?? ""
    }
    @State var fetchedBill = [Invoice]()
    @Binding var drawerStatus: DrawerStatus
    @State var showDueBills = true
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                bodyView(geo: geo)
                    .onTapGesture {
                        handleNavigationDrawer()
                    }
            }.ignoresSafeArea()
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)
    }
 
    @ViewBuilder
    func bodyView(geo: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            HomeTopViewDesign(parentSize: geo, onHamburgerIconClick: {
                drawerStatus = .open
            })
            ActivateCardView(parentSize: geo) {
                // TODO
            }
            ActiveCategoryTabView(categories: categories)
                .background(.white)
                .shadow(radius: 0, y: 3)
                .padding(.vertical, 10)
                .handleViewStates(uiModel: $hvm.categoryUIModel, showAlert: $hvm
                    .showAlert)
            
            QuickTopupView(airtimeServices: airtimeServices)
                .shadowBackground()
                .handleViewStates(uiModel: $hvm.quickTopUIModel, showAlert: $hvm.showAlert)
            DueBillsView(fetchedBill: fetchedBill)
                .shadowBackground()
                .showIf($showDueBills)
            
            RechargeAndBillView(rechargeAndBill: rechargeAndBill)
                .shadowBackground()
                .environmentObject(hvm)
                .handleViewStates(uiModel: $hvm.rechargeAndBillUIModel, showAlert: $hvm.showAlert)
            ExpensesGraphView(chartData: chartData)
                .frame(height: geo.size.height * 0.35)
                .shadowBackground()
            AddNewBillCardView()
        }.onAppear {
            fetchedBill = Observer<Invoice>().objects.filter { $0.amount.convertStringToInt() > 0 && "\(String(describing: $0.enrollment?.hubServiceID) )" != "187"}
            withAnimation {
                showDueBills = !fetchedBill.isEmpty
            }
        }
    }
    fileprivate func handleNavigationDrawer() {
        drawerStatus = .close
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(drawerStatus: .constant(.close))
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
