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
            VStack(spacing: 0) {
                HomeTopViewDesign(onHamburgerIconClick: {
                    drawerStatus = .open
                })
                ScrollView(showsIndicators: false) {
                    bodyView(geo: geo)
                        .background(
                            VStack {
                                topBackgroundDesign(
                                    color: PrimaryTheme.getColor(.secondaryColor)
                                ).frame(height: geo.size.height/7)
                                Spacer()
                            }
                        )
                }
            }.onTapGesture {
                handleNavigationDrawer()
            }
            
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)

    }
 
    @ViewBuilder
    func bodyView(geo: GeometryProxy) -> some View {
        VStack(spacing: 5) {
            Text("Welcome back, \(hvm.profile.firstName!)")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.smallTextSize))
            Text("What would you like to do?")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.largeTextSize))
            ActivateCardView() {
                // TODO
            }.padding(10)
            ActiveCategoryTabView(categories: categories)
                .background(.white)
                .shadow(radius: 0, y: 1)
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
                .scaledToFit()
                .shadowBackground()
            AddNewBillCardView()
        }
     
        .onAppear {
            fetchedBill = Observer<Invoice>().objects.filter {
                $0.hasPaymentInProgress ||
                (
                    ($0.amount.convertStringToInt() > 0) &&
                    "\(String(describing: $0.enrollment?.hubServiceID))" != MerchantService.MULA_CHAMA_ID
                )
                
            }
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
