//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//

import Common
import Core
import SwiftUI
import Theme
enum Tabs: String, CaseIterable {
    case FirstTab
    case SecondTab
    case ThirdTab
    case FourthTab
}

public struct MyBillView: View {
    @State var selectedTab = Tabs.FirstTab
    @State var color: Color = .green
    @State var gotoAllRechargesView = false
    @State var items = [
        TabLayoutItem(title: "MY BILLS", view: AnyView(Text("MY BILLS"))),
        TabLayoutItem(title: "RECEIPTS", view: AnyView(Text("RECEIPTS")))
    ]
    @EnvironmentObject var hvm: HomeViewModel
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        VStack {
            PrimaryTheme.getImage(image: .myBills)
                .clipShape(Circle())
                .padding()
            Text("You do not have any saved bills.\nGet started by adding a bill.")
                .multilineTextAlignment(.center)
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Add bill"
            ) {
                onclickAddBill()
            }
        }
    }
    private func onclickAddBill() {
        hvm.gotoAllRechargesView = true
    }
}

struct MyBillView_Previews: PreviewProvider {
    struct ExampleTabVieViewHolder: View {
        @State var tabColor: Color = .green
        @State var items = [
            TabLayoutItem(title: "MY BILLS", view: AnyView(MyBillView())),
            TabLayoutItem(title: "RECEIPTS", view: AnyView(Text("RECEIPTS")))
        ]
        var body: some View {
            CustomTabView(items: items, tabColor: $tabColor)
        }
    }
    static var previews: some View {
        MyBillView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}



