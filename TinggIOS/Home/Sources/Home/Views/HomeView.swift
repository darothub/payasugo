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
    @EnvironmentObject var navigation: NavigationManager
    @State var chartData: [ChartData] = .init()
    @State var categorySectionHeight: CGFloat = 100.0
    @State var chartSectionHeight: CGFloat = 100.0
    @State var airtimeServices = [MerchantService]()
    @State var categories: [[CategoryDTO]] = [[CategoryDTO]]()
    @State var rechargeAndBill = [MerchantService]()
    @State var allRecharges = [String: [MerchantService]]()
    @State var fetchedBill = [DynamicInvoiceType]()
    @State var billType = DueBillType.dueBills
    @State var isShowingDueBills = false
    @State var isShowingUpcomingBills = false
    @State var dueBillIsLoading = false
    
    @Binding var drawerStatus: DrawerStatus
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HomeTopViewDesign(
                    onHamburgerIconClick: {
                    drawerStatus = .open
                })
                .background(
                    VStack {
                        topBackgroundDesign(
                            color: PrimaryTheme.getColor(.secondaryColor)
                        ).frame(height: geo.size.height/3)
                        Spacer()
                    }
                )
                ScrollView(showsIndicators: false) {
                    bodyView(geo: geo)
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
        VStack(spacing: 10) {
            Text("Welcome back, \(hvm.profile.firstName!)")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.smallTextSize))
            Text("What would you like to do?")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.largeTextSize))
            ActivateCardView() {
                // TODO
            }
            .showIf(.constant(false))
            .padding(10)
            ActiveCategoryTabView(categories: categories)
                .frame(height: categorySectionHeight)
                
            QuickTopupView() { service in
                if service.isAirtimeService {
                    navigation.navigationStack.append(Screens.buyAirtime(service.serviceName))
                }
            }
          
            DueBillsView(isShowingBills: $isShowingDueBills, isLoading: $dueBillIsLoading)
                .shadowBackground()
            DueBillsView(isShowingBills: $isShowingUpcomingBills, billType: .upcomingBills, isLoading: $dueBillIsLoading)
                .shadowBackground()

            RechargeAndBillView()
            .shadowBackground()
          
            ExpensesGraphView(chartData: chartData)
                .frame(height: chartSectionHeight)
                .shadowBackground()
            
            AddNewBillCardView()
            
        }
        .onAppear {
            handleFsu()
            withAnimation {
                categorySectionHeight = geo.size.height/4
                chartSectionHeight = geo.size.height/3
            }
           
        }
        .environmentObject(hvm)
        .handleViewStatesMods(uiState: hvm.$uiModel) { content in
            handleFsu()
        }
    }
    fileprivate func handleNavigationDrawer() {
        drawerStatus = .close
    }
    fileprivate func handleFsu()   {
        Task {
            categories =  hvm.getServicesByCategory()
            airtimeServices =  hvm.getQuickTopups()
            rechargeAndBill =  hvm.displayedRechargeAndBill()
            chartData =  hvm.mapHistoryIntoChartData()
            await hvm.getDueBills()
            hvm.getSavedBill()
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(drawerStatus: .constant(.close))
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
