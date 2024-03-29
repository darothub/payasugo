//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//

import CoreUI
import Core
import SwiftUI
import Theme
import CoreNavigation
enum Tabs: String, CaseIterable {
    case FirstTab
    case SecondTab
    case ThirdTab
    case FourthTab
}
public var sampleItem = [
    TabLayoutItem(title: "MY BILLS", view: AnyView(Text("MY BILLS"))),
    TabLayoutItem(title: "RECEIPTS", view:   AnyView(Text("RECEIPTS")))
      
]
/// Shows user's bills
/// This view is one of the tabs in ``BillView``
public struct MyBillView: View {
    @State private var selectedTab = Tabs.FirstTab
    @State private var color: Color = .green
    @State private var isShowingUpcomingBills = false
    @State private var showPlaceHolderView = false
    @State private var placeHolderText = "You do not have any saved bills.\nGet started by adding a bill."
    private var upcomingBillsheader = AnyView(Text("UPCOMING BILLS"))
    @State var dueBillIsLoading = false
    @State var isShowingSavedBill = false
    @State var savedBillLoading = false
    @EnvironmentObject var billViewModel: BillViewModel
    @EnvironmentObject var navigation: NavigationManager
    public init() {
        // 
    }
    public var body: some View {
        ZStack {
            VStack {
                Section {
                    PrimaryTheme.getImage(image: .myBills)
                        .clipShape(Circle())
                        .padding()
                    Text(placeHolderText)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .showIfNot($savedBillLoading)
            .showIfNot($isShowingSavedBill)
            .showIfNot($dueBillIsLoading)
            .showIfNot($isShowingUpcomingBills)
            
            
            ScrollView {
                DueBillsView(
                    isShowingBills: $isShowingUpcomingBills,
                    billType: .others,
                    newHeader: upcomingBillsheader,
                    isLoading: $dueBillIsLoading
                )
              
                SavedBillListView(showSavedBill: $isShowingSavedBill, isLoading: $savedBillLoading) { bill in
                    let invoice = Observer<Invoice>().getEntities().first { $0.billReference == bill.accountNumber
                    }
                    if let i = invoice {
                        navigation.navigateTo(screen: BillsScreen.nominationDetails(i))
                    }
                }
            }
            .background(isShowingUpcomingBills ? .white : .clear)
          
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        onclickAddBill()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("ADD A BILL ")
                        }.foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                    .background(
                        Capsule(style: .continuous)
                                .fill(PrimaryTheme.getColor(.primaryColor))
                                .shadow(radius: 5, y: 10)
                    )
                    .padding()
                }
            }
        }
        .background(.white)
        .onAppear {
            billViewModel.getSavedBills()
        }
    }
    private func onclickAddBill() {
        let titleAndListItem = billViewModel.getTitleAndServicesList()
        withAnimation {
            navigation.navigateTo(
                screen: BillsScreen.categoriesAndServices(titleAndListItem)
            )
        }
    }
}

struct MyBillView_Previews: PreviewProvider {
    static var previews: some View {
        MyBillView()
            .environmentObject(BillsDI.createBillViewModel())
            .environmentObject(NavigationManager.shared)
    }
}





