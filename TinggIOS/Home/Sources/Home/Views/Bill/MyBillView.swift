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
    @State var items = [
        TabLayoutItem(title: "MY BILLS", view: AnyView(Text("MY BILLS"))),
        TabLayoutItem(title: "RECEIPTS", view: AnyView(Text("RECEIPTS")))
    ]
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
           
            }
        }
    }
}

public struct CustomTabView: View {
    @Binding var tabColor: Color
    @State private var selectedTab = ""
    @State var items: [TabLayoutItem]
    public init(items: [TabLayoutItem], tabColor: Binding<Color>) {
        self._tabColor = tabColor
        self._items = State(initialValue: items)
    }
    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(items, id: \.title) { tabId in
                    TabItemView(tabTitle: .constant(tabId.title), selected: $selectedTab, color: $tabColor)
                }
            }
            TabView(selection: $selectedTab) {
                ForEach(items, id: \.title) { tabId in
                    tabId.view
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }.onAppear{
            selectedTab = items.first!.title
        }
        
    }
}

public struct TabItemView: View {
    @Binding var tabTitle: String
    @Binding var selected: String
    @Binding var color: Color
    @State var tabWidth = 100.0
    @State var tabHeight = 50.0
    public var body: some View {
        Text(tabTitle)
            .font(.caption)
            .frame(maxWidth: .infinity, maxHeight: tabHeight)
            .background(
                Rectangle()
                    .foregroundColor(selected == tabTitle ? color : .white)
                    .tag(tabTitle)
            )
            .foregroundColor(selected == tabTitle ? .white : .black)
            .onTapGesture {
                selected = tabTitle
            }
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
    }
}


public struct TabLayoutItem {
    var title: String
    var view: AnyView
    public init(title: String, view: AnyView) {
        self.title = title
        self.view = view
    }
}
