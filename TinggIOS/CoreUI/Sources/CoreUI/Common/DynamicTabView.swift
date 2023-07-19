//
//  DynamicTabView.swift
//
//
//  Created by Abdulrasaq on 20/09/2022.
//

import SwiftUI

/// Custom tab view
public struct DynamicTabView: View {
    @State private var selectedTab: Tab = .second
    var items: [TabLayoutItem] = sampleItem
    var tabColor: Color
        /// ``DynamicTabView`` initialiser
        /// - Parameters:
        ///   - items: List of tab layouts
        ///   - tabColor: tab color
    public init(items: [TabLayoutItem], selectedTab: Tab, tabColor: Color) {
        self.items = items
        _selectedTab = State(initialValue: selectedTab)
        self.tabColor = tabColor
    }

    public var body: some View {
        ZStack(alignment: .top) {
            if items.count < Tab.allCases.count {
                TabView(selection: $selectedTab) {
                    ForEach(0..<Tab.allCases.prefix(items.count).count, id: \.self) { index in
                        let item = items[index]
                        item.view
                            .tag(Tab.allCases[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.top, 50)

                CustomTabBar(selectedTab: $selectedTab, size: Tab.allCases.prefix(items.count).count, items: items, color: tabColor)
            } else {
                Text("View count is more than 4")
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var size = 2
    var titles = ["Hello", "World"]
    var items: [TabLayoutItem] = sampleItem
    var color: Color = .blue
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<Tab.allCases.prefix(items.count).count, id: \.self) { number in
                let tab = Tab.allCases[number]
                let item = items[number]
                TabBarButton(tab: tab, selectedTab: $selectedTab, tabTitle: item.title, color: color)
            }
        }
    }
}

struct TabBarButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let tabTitle: String
    let color: Color
    @State private var tabHeight = 50.0
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(tabTitle)
                .font(.caption)
                .frame(maxWidth: .infinity, maxHeight: tabHeight)
                .background(
                    Rectangle()
                        .foregroundColor(color)
                )
                .foregroundColor(selectedTab == tab ? .white : .black)
        }
    }
}

public struct TabLayoutItem {
    var id: String {
        UUID().uuidString
    }

    public var title: String
    public var view: AnyView
    public init(title: String, view: AnyView) {
        self.title = title
        self.view = view
    }
}

public enum Tab: String, CaseIterable, Identifiable {
    public var id: String {
        UUID().uuidString
    }
    case first, second, third, fourth
}

var sampleItem = [
    TabLayoutItem(title: "MY BILLS", view: AnyView(Text("MY BILLS"))),
    TabLayoutItem(title: "RECEIPTS", view: AnyView(Text("RECEIPTS"))),
]


struct ContentView_Previews: PreviewProvider {
    struct SampleView: View {
        var items: [TabLayoutItem] = sampleItem
        @State private var selectedTab: Tab = .second
        var body: some View {
            DynamicTabView(items: items, selectedTab: selectedTab, tabColor: .blue)
        }
    }

    static var previews: some View {
        SampleView()
    }
}
