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

    var chartData: [ChartData] {
        hvm.mapHistoryIntoChartData()
    }
    @Binding var drawerStatus: DrawerStatus
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
            ActiveCategoryTabView()
                .frame(maxWidth: .infinity)
                .background(.white)
                .shadow(radius: 0, y: 1)
                .padding(.vertical, 10)
            
            QuickTopupView() { service in
                if service.isAirtimeService {
                    navigation.navigationStack.append(Screens.buyAirtime(service.serviceName))
                }
            }
           
            .padding()
            .shadowBackground()
           
            DueBillsView()
                .shadowBackground()

            DueBillsView(billType: .upcomingBills)
                .shadowBackground()
             

            RechargeAndBillView()
                .shadowBackground()
          
            ExpensesGraphView(chartData: chartData)
                .scaledToFit()
                .shadowBackground()
            
            AddNewBillCardView()
        }
        .environmentObject(hvm)

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
