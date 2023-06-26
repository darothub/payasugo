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
var sampleItem = [
    TabLayoutItem(title: "MY BILLS"){
        AnyView(Text("MY BILLS"))
    },
    TabLayoutItem(title: "RECEIPTS") {
        AnyView(Text("RECEIPTS"))
    }
]
/// Shows user's bills
/// This view is one of the tabs in ``BillView``
public struct MyBillView: View {
    @State private var selectedTab = Tabs.FirstTab
    @State private var color: Color = .green
    @State private var gotoAllRechargesView = false
    @State private var isShowingUpcomingBills = false
    @State private var showPlaceHolderView = false
    @State private var placeHolderText = "You do not have any saved bills.\nGet started by adding a bill."
    private var upcomingBillsheader = AnyView(Text("UPCOMING BILLS"))
    @State var dueBillIsLoading = false
    @State var isShowingSavedBill = false
    @State var savedBillLoading = false
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
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
                    let service = Observer<MerchantService>().getEntities().first { $0.serviceName == bill.serviceName
                    }
                    let enrollment = Observer<Enrollment>().getEntities().first { $0.hubServiceID == service?.hubServiceID.convertStringToInt()
                    }
                    if let i = invoice, let e = enrollment {
                        navigation.navigationStack.append (
                            HomeScreen.nominationDetails(i, e)
                        )
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
            hvm.getSavedBill()
        }
    }
    private func onclickAddBill() {
        let categoryNameAndServices = hvm.getAllServicesForAddBill()
        withAnimation {
            navigation.navigationStack.append(
                HomeScreen.categoriesAndServices(categoryNameAndServices)
            )
        }
    }
}

struct MyBillView_Previews: PreviewProvider {
    struct ExampleTabVieViewHolder: View {
        @State var tabColor: Color = .green
        @State var items = sampleItem
        var body: some View {
            CustomTabView(items: $items, tabColor: $tabColor)
        }
    }
    static var previews: some View {
        MyBillView()
            .environmentObject(HomeDI.createHomeViewModel())
            .environmentObject(NavigationUtils())
    }
}





