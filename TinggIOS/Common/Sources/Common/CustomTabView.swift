//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//

import SwiftUI


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
                iTerateTabHeader()
            }
            TabView(selection: $selectedTab) {
                iTerateTabViews()
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }.onAppear{
            selectedTab = items.first!.title
        }
        
    }
    @ViewBuilder
    private func iTerateTabHeader() -> some View {
        ForEach(items, id: \.title) { tab in
            TabItemView(tabTitle: .constant(tab.title), selected: $selectedTab, color: $tabColor)
        }
    }
    @ViewBuilder
    private func iTerateTabViews() -> some View {
        ForEach(items, id: \.title) { tabId in
            tabId.view
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

public struct TabLayoutItem {
    var title: String
    var view: AnyView
    public init(title: String, view: AnyView) {
        self.title = title
        self.view = view
    }
}